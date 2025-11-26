import 'package:flutter/material.dart';
import 'package:flutter_caculator_nguyennamphuong/models/angle_mode.dart';
import 'package:flutter_caculator_nguyennamphuong/models/calculator_mode.dart';
import 'package:flutter_caculator_nguyennamphuong/models/calculation_history.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/history_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/settings_provider.dart';
import 'package:math_expressions/math_expressions.dart';

typedef CalculationCallback = void Function(CalculationHistory history);

class CalculatorProvider extends ChangeNotifier {
  //Thuộc tính Private
  String _expression = '';
  String _result = '0';
  CalculatorMode _mode = CalculatorMode.basic;
  AngleMode _angleMode = AngleMode.degrees;
  double _memory = 0;
  bool _hasMemory = false;
  bool _isResultCalculated = false;
  CalculationCallback? onCalculationComplete;
  SettingsProvider? settingsProvider;
  //Getters Công khai
  String get expression => _expression;
  String get result => _result;
  CalculatorMode get mode => _mode;
  AngleMode get angleMode => _angleMode;
  double get memory => _memory;
  bool get hasMemory => _hasMemory;
  bool get isResultCalculated => _isResultCalculated;
  bool get isRadMode => _angleMode == AngleMode.radians;

  //Cập nhật settingsProvider khi nó thay đổi
  void setSettingsProvider(SettingsProvider provider) {
    settingsProvider = provider;
  }

  //Phương thức
  ///Phương thức điều phối chính khi một nút được nhấn.
  void buttonPressed(String text) {
    //Xử lý các nút cụ thể
    switch (text) {
      case '=':
        calculate();
        break;
      case 'C':
        clear();
        break;
      case 'CE': //Clear Entry
        clearEntry();
        break;
      case 'AC': //Clear All
        clear();
        break;
      case 'M+':
        memoryAdd();
        break;
      case 'M-':
        memorySubtract();
        break;
      case 'MR':
        memoryRecall();
        break;
      case 'MC':
        memoryClear();
        break;
      case '±':
        _toggleSign();
        break;
      case 'RAD':
        toggleAngleMode();
        break;
      case '(':
      case ')':
        _handleParenthesis(text);
        break;
      //Trường hợp mặc định cho tất cả các nút khác (số, toán tử, hàm khoa học)
      default:
        //Nếu kết quả vừa được tính, hoặc có lỗi, bắt đầu biểu thức mới
        if (_isResultCalculated ||
            _expression.endsWith('Lỗi') ||
            _result == 'Lỗi') {
          _isResultCalculated =
              false; //Luôn đặt lại cờ khi bắt đầu hành động mới
          _result = '0';
          //Nếu nhấn toán tử, tiếp tục tính toán với kết quả cũ
          if (['+', '-', '×', '÷', '%', '^'].contains(text)) {
            _expression = _result;
            addToExpression(text); //Thêm toán tử vào sau kết quả cũ
          } else {
            _startNewExpression(text);
          }
        } else {
          //Nếu không, chỉ cần gọi hàm addToExpression để xử lý logic thêm ký tự
          addToExpression(text);
        }
        notifyListeners(); // Chỉ gọi notifyListeners một lần ở cuối default case
        break;
    }
  }

  /// Tính toán biểu thức hiện tại.
  Future<void> calculate() async {
    if (_expression.isEmpty) return;
    try {
      //Chuẩn bị biểu thức để tính toán
      String preparedExpression = _prepareExpressionForCalculation(_expression);

      //Tính toán sử dụng math_expressions
      Expression exp = ShuntingYardParser().parse(preparedExpression);

      //Sử dụng ContextModel để có thể thêm các hàm tùy chỉnh trong tương lai
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      //Lấy độ chính xác từ settingsProvider
      final precision = settingsProvider?.settings.decimalPrecision ?? 10;

      //Định dạng kết quả theo độ chính xác và bỏ ".0" nếu là số nguyên
      if (eval == eval.toInt()) {
        _result = eval.toInt().toString();
      } else {
        _result = eval.toStringAsFixed(
          precision,
        ); //Loại bỏ các số 0 không cần thiết ở cuối
        _result = _result
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }
      _isResultCalculated = true;

      //Cập nhật và lưu vào lịch sử
      onCalculationComplete?.call(
        CalculationHistory(
          expression: _expression,
          result: _result,
          timestamp: DateTime.now(),
        ),
      );
    } catch (e) {
      //Xử lý lỗi
      _result = 'Lỗi';
    }
    //Thêm một khoảng trễ nhỏ để UI có thời gian phản ứng (hỗ trợ animation)
    await Future.delayed(const Duration(milliseconds: 50));
    notifyListeners();
  }

  ///Thêm một giá trị (số hoặc toán tử) vào biểu thức hiện tại.
  void addToExpression(String value) {
    //Chuẩn hóa giá trị đầu vào để đảm bảo tính nhất quán
    String normalizedValue = value;
    if (value == '−' || value == '–') {
      if (value == ',') {
        normalizedValue = '.';
      }
      const scientificFunctions = {
        'sin',
        'cos',
        'tan',
        'log',
        'ln',
        '√',
        'sinh',
        'cosh',
        'tanh',
        'log₁₀',
      };
      const operators = {'+', '-', '×', '÷', '^', '%'};

      if (scientificFunctions.contains(normalizedValue)) {
        //Nếu là hàm khoa học, thêm hàm và dấu ngoặc mở.
        _expression += '$normalizedValue(';
      } else if (operators.contains(normalizedValue)) {
        //Nếu là toán tử, kiểm tra và thay thế toán tử cuối cùng nếu cần.
        if (_expression.isNotEmpty &&
            operators.contains(_expression[_expression.length - 1])) {
          //Thay thế toán tử cuối cùng bằng toán tử mới.
          _expression =
              _expression.substring(0, _expression.length - 1) +
              normalizedValue;
        } else {
          _expression += normalizedValue;
        }
      } else {
        //Đối với số, dấu thập phân, và các ký tự khác, chỉ cần thêm vào.
        _expression += normalizedValue;
      }

      //notifyListeners() sẽ được gọi trong buttonPressed
    }
  }

  ///Xóa toàn bộ biểu thức và đặt lại kết quả về '0'.
  void clear() {
    _expression = '';
    _result = '0';
    _isResultCalculated = false;
    notifyListeners();
  }

  /// Xóa mục nhập cuối cùng trong biểu thức.
  /// Ví dụ: "123+45" -> "123+", "123+" -> "123", "123" -> ""
  void clearEntry() {
    if (_expression.isEmpty) return;

    //Tìm vị trí cuối cùng của một toán tử hoặc dấu cách
    final operators = ['+', '-', '×', '÷', '^'];
    int lastOperatorIndex = -1;
    for (var operator in operators) {
      int index = _expression.lastIndexOf(operator);
      if (index > lastOperatorIndex) {
        lastOperatorIndex = index;
      }
    }

    //Nếu ký tự cuối cùng là một toán tử, chỉ cần xóa nó
    if (lastOperatorIndex == _expression.length - 1) {
      _expression = _expression.substring(0, _expression.length - 1);
    } else {
      // Nếu không, xóa toàn bộ số cuối cùng
      if (lastOperatorIndex != -1) {
        _expression = _expression.substring(0, lastOperatorIndex + 1);
      } else {
        // Nếu không có toán tử nào, xóa toàn bộ biểu thức
        _expression = '';
      }
    }

    notifyListeners();
  }

  ///Xóa ký tự cuối cùng từ biểu thức (dành cho cử chỉ vuốt).
  void deleteLastCharacter() {
    if (_expression.isNotEmpty) {
      _expression = _expression.substring(0, _expression.length - 1);
      _isResultCalculated = false; // Đặt lại trạng thái tính toán
      notifyListeners();
    }
  }

  ///Chuyển đổi chế độ máy tính (cơ bản hoặc khoa học).
  void toggleMode() {
    _mode = _mode == CalculatorMode.basic
        ? CalculatorMode.scientific
        : CalculatorMode.basic;
    notifyListeners();
  }

  ///Đặt chế độ máy tính một cách tường minh.
  void setMode(CalculatorMode newMode) {
    _mode = newMode;
    notifyListeners();
  }

  ///Xử lý cử chỉ nhấn giữ nút Clear để xóa toàn bộ lịch sử.
  void handleLongPressClear() {}

  ///Chuyển đổi chế độ góc (độ hoặc radian).
  void toggleAngleMode() {
    //Ưu tiên cập nhật thông qua SettingsProvider nếu có
    final newMode =
        (settingsProvider?.settings.angleMode ?? _angleMode) ==
            AngleMode.degrees
        ? AngleMode.radians
        : AngleMode.degrees;
    notifyListeners();
  }

  ///Cộng kết quả hiện tại vào bộ nhớ.
  void memoryAdd() {
    final currentValue = double.tryParse(_result);
    if (currentValue == null)
      return; //Không làm gì nếu kết quả không phải là số
    _memory += currentValue;
    _hasMemory = true;
    notifyListeners();
  }

  ///Trừ kết quả hiện tại khỏi bộ nhớ.
  void memorySubtract() {
    final currentValue = double.tryParse(_result);
    if (currentValue == null) return;

    _memory -= currentValue;
    _hasMemory = true;
    notifyListeners();
  }

  ///Gọi lại giá trị từ bộ nhớ.
  void memoryRecall() {
    if (!_hasMemory) return;
    _expression = _memory.toString();
    notifyListeners();
  }

  ///Xóa bộ nhớ.
  void memoryClear() {
    _memory = 0;
    _hasMemory = false;
    notifyListeners();
  }

  ///Đặt lại biểu thức để tái sử dụng từ lịch sử.
  void reuseExpression(String expression) {
    _expression = expression;
    _result = '0'; //Đặt lại kết quả hiển thị
    _isResultCalculated = false; //Đảm bảo người dùng có thể chỉnh sửa
    notifyListeners();
  }

  //Các phương thức private hỗ trợ

  void _toggleSign() {
    //Logic này cần được làm phức tạp hơn để xử lý các số trong biểu thức
    //Hiện tại, nó chỉ đổi dấu của toàn bộ biểu thức
    if (_expression.startsWith('-')) {
      _expression = _expression.substring(1);
    } else if (_expression.isNotEmpty) {
      _expression = '-($_expression)';
    }
    notifyListeners();
  }

  ///Bắt đầu một biểu thức mới với một giá trị cho trước.
  void _startNewExpression(String text) {
    const scientificFunctions = {
      'sin',
      'cos',
      'tan',
      'log',
      'ln',
      '√',
      'sinh',
      'cosh',
      'tanh',
      'log₁₀',
    };

    if (scientificFunctions.contains(text)) {
      _expression = '$text(';
    } else {
      _expression = text;
    }
  }

  ///Chuẩn bị chuỗi biểu thức để thư viện math_expressions có thể tính toán.
  String _prepareExpressionForCalculation(String rawExpression) {
    String finalExpression = rawExpression
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('π', 'pi')
        .replaceAll('e', 'e');
    //Chuẩn hóa các hàm và toán tử đặc biệt
    finalExpression = finalExpression.replaceAllMapped(
      RegExp(r'(\d+)(x²|x³)'),
      (match) {
        final number = match.group(1);
        final power = match.group(2) == 'x²' ? '2' : '3';
        return '$number^$power';
      },
    );
    finalExpression = finalExpression.replaceAll('√', 'sqrt');
    finalExpression = finalExpression.replaceAll('xʸ', '^');
    finalExpression = finalExpression.replaceAll('ln', 'log');
    finalExpression = finalExpression.replaceAll('log₁₀', 'log10');
    //Xử lý góc
    final currentAngleMode = settingsProvider?.settings.angleMode ?? _angleMode;
    if (currentAngleMode == AngleMode.degrees) {
      final regExp = RegExp(r'(sin|cos|tan|sinh|cosh|tanh)\((-?\d+\.?\d*)\)');
      finalExpression = finalExpression.replaceAllMapped(regExp, (match) {
        final function = match.group(1)!;
        final argument = match.group(2)!;
        return '$function(($argument) * (pi / 180))';
      });
    }
    return finalExpression;
  }

  void _handleParenthesis(String paren) {
    //Logic đơn giản để thêm dấu ngoặc
    _expression += paren;
    notifyListeners();
  }
}
