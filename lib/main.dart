import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ButtonWidget.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF1C1C1C),
      ),
      home: const CalculatorScreen(),
    );
  }
}

// Widget chính quản lý trạng thái của máy tính
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';

  @override
  void initState() {
    super.initState();
    _loadState(); // Tải trạng thái đã lưu khi widget được tạo
  }

  // Hàm để lưu trạng thái
  Future<void> _saveState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('expression', _expression);
    await prefs.setString('result', _result);
  }

  // Hàm để tải trạng thái
  Future<void> _loadState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _expression = prefs.getString('expression') ?? '';
      _result = prefs.getString('result') ?? '0';
    });
  }

  void _buttonPressed(String text) {
    setState(() {
      if (text == 'C') {
        _expression = '';
        _result = '0';
        _saveState(); // Lưu trạng thái sau khi xóa
        return; // Kết thúc sớm để không lưu lại ở cuối hàm
      } else if (text == '=') {
        _calculate();
      } else if (text == '( )') {
        _handleParenthesis();
      } else if (text == '+/-') {
        // Logic đổi dấu
        if (_result.startsWith('-')) {
          _result = _result.substring(1);
        } else if (_result != '0') {
          _result = '-$_result';
        }
      } else if (_expression.endsWith('Lỗi')) {
        // Nếu phép tính trước đó bị lỗi, bắt đầu biểu thức mới
        _expression = text;
      } else if (_expression == _result &&
          !['+', '-', '×', '÷', '%'].contains(text)) {
        _expression = text;
      } else {
        _expression += text;
      }
    });
    _saveState(); // Lưu trạng thái sau mỗi lần nhấn nút
  }

  void _calculate() {
    // Trả về 0 nếu k có biểu thức để tính
    if (_expression.isEmpty) {
      return;
    }
    try {
      String finalExpression = _expression;
      finalExpression = finalExpression.replaceAll('×', '*');
      finalExpression = finalExpression.replaceAll('÷', '/');
      finalExpression = finalExpression.replaceAll('%', '/100');
      Parser p = Parser();
      Expression exp = p.parse(finalExpression);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);
      setState(() {
        // Nếu kết quả là số nguyên, hiển thị không có phần thập phân
        if (eval == eval.toInt()) {
          _result = eval.toInt().toString();
        } else {
          _result = eval.toString();
        }
        _expression = _result; // Cho phép tính toán tiếp
        _saveState(); // Lưu trạng thái sau khi tính toán thành công
      });
    } catch (e) {
      setState(() {
        _saveState(); // Cũng lưu trạng thái lỗi
        _result = 'Lỗi';
      });
    }
  }

  void _handleParenthesis() {
    // Nếu biểu thức bị lỗi, bắt đầu lại với dấu ngoặc mở
    if (_expression.endsWith('Lỗi')) {
      _expression = '(';
      return;
    }

    int openParenCount = '('.allMatches(_expression).length;
    int closeParenCount = ')'.allMatches(_expression).length;

    if (_expression.isEmpty) {
      _expression += '(';
      return;
    }
    String lastChar = _expression.substring(_expression.length - 1);
    // Logic đóng mở dấu ngoặc ()
    // Nếu ký tự cuối là số hoặc ')' VÀ số ngoặc mở > số ngoặc đóng
    if (RegExp(r'[0-9)]').hasMatch(lastChar) &&
        openParenCount > closeParenCount) {
      _expression += ')';
    }
    // Điều kiện để thêm dấu ngoặc mở '('
    // Nếu ký tự cuối là toán tử hoặc '('
    else if (['+', '-', '×', '÷', '('].contains(lastChar)) {
      _expression += '(';
    } else if (RegExp(r'[0-9)]').hasMatch(lastChar)) {
      // Tự động thêm phép nhân khi mở ngoặc sau một số hoặc ngoặc đóng
      _expression += '×(';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 2, // Chia 2 phần cho khung kết quả
            child: Container(
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _expression,
                      style: const TextStyle(color: Colors.grey, fontSize: 24),
                      textAlign: TextAlign.end,
                    ),
                  ),
                  Padding(
                    // Hiển thị kết quả
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      _result,
                      style: const TextStyle(color: Colors.white, fontSize: 60),
                      textAlign: TextAlign.end,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 3, //Chia 3 phần cho khung nút bấm
            child: Container(
              color: Colors.black, // Đồng bộ màu nền với khung kết quả
              child: Column(
                children: [
                  _buildButtonRow(['C', '( )', '%', '÷']),
                  _buildButtonRow(['7', '8', '9', '×']),
                  _buildButtonRow(['4', '5', '6', '-']),
                  _buildButtonRow(['1', '2', '3', '+']),
                  _buildButtonRow(['+/-', '0', '.', '=']),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonRow(List<String> buttons) {
    // Tạo hàng nút bấm
    return Expanded(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttons
            .map(
              (text) => Expanded(
                child: ButtonWidget(
                  text: text,
                  onPressed: () => _buttonPressed(text),
                  backgroundColor: _getButtonColor(text),
                  textColor: Colors.white,
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Color _getButtonColor(String text) {
    // Xác định màu nút dựa trên ký tự
    switch (text) {
      case 'C':
        return const Color(0xFF963E3E);
      case '÷':
      case '×':
      case '-':
      case '+':
        return const Color(0xFF394734);
      case '=':
        return const Color(0xFF076544);
      case '( )':
      case '%':
      case '+/-':
      case '.':
      default:
        return const Color(0xFF272727);
    }
  }
}
