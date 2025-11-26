import 'package:flutter_caculator_nguyennamphuong/models/angle_mode.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/calculator_provider.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Khởi tạo một đối tượng CalculatorProvider cho mỗi test
  late CalculatorProvider calculatorProvider;
  setUp(() {
    calculatorProvider = CalculatorProvider();
  });

  // Hàm trợ giúp thực thi một phép tính và kiểm tra kết quả
  Future<void> _testCalculation(
    String expression,
    String expectedResult,
  ) async {
    // Gán biểu thức cho provider
    calculatorProvider.reuseExpression(expression);
    // Thực hiện tính toán
    await calculatorProvider.calculate();
    // Kiểm tra kết quả
    expect(calculatorProvider.result, expectedResult);
  }

  group('CalculatorProvider Unit Tests', () {
    //Test Case 1: Basic Arithmetic
    group('1. Basic Arithmetic', () {
      test('should handle addition correctly', () async {
        await _testCalculation('5+3', '8');
      });
      test('should handle subtraction correctly', () async {
        await _testCalculation('10-4', '6');
      });
      test('should handle multiplication correctly', () async {
        await _testCalculation('5×3', '15');
      });
      test('should handle division correctly', () async {
        await _testCalculation('15÷3', '5');
      });
    });
    //Test Case 2: Order of Operations
    group('2. Order of Operations (PEMDAS)', () {
      test('should respect multiplication before addition', () async {
        await _testCalculation('2+3×4', '14');
      });
      test('should respect parentheses', () async {
        await _testCalculation('(2+3)×4', '20');
      });
    });
    //Test Case 3: Scientific Functions
    group('3. Scientific Functions (Degrees)', () {
      setUp(() {
        // Đảm bảo chế độ góc là Degrees
        expect(calculatorProvider.angleMode, AngleMode.degrees);
      });
      test('should calculate sin(30) correctly in Degrees mode', () async {
        // sin(30) ≈ 0.5
        await _testCalculation('sin(30)', '0.5');
      });
      test('should calculate cos(60) correctly in Degrees mode', () async {
        // cos(60) ≈ 0.5
        await _testCalculation('cos(60)', '0.5');
      });
      test('should calculate square root correctly', () async {
        // √16 = 4
        await _testCalculation('√(16)', '4');
      });
    });
    //Test Case 4: Edge Cases / Error Handling
    group('4. Edge Cases and Error Handling', () {
      test('should return "Lỗi" for division by zero', () async {
        await _testCalculation('5÷0', 'Lỗi');
      });
      test(
        'should return "Lỗi" for invalid input (e.g., sqrt of negative)',
        () async {
          await _testCalculation('√(-4)', 'Lỗi');
        },
      );
      test('should return "Lỗi" for incomplete expression', () async {
        await _testCalculation('5+', 'Lỗi');
      });
      test('should return "Lỗi" for mismatched parentheses', () async {
        await _testCalculation('(5+3', 'Lỗi');
      });
    });
    //Test Case 5: Other functionalities
    group('5. Other Functionalities', () {
      test('clear() should reset expression and result', () {
        calculatorProvider.buttonPressed('5');
        calculatorProvider.buttonPressed('+');
        calculatorProvider.buttonPressed('3');
        calculatorProvider.buttonPressed('C');
        expect(calculatorProvider.expression, '');
        expect(calculatorProvider.result, '0');
      });
      test('deleteLastCharacter() should remove the last character', () {
        calculatorProvider.reuseExpression('123+');
        calculatorProvider.deleteLastCharacter();
        expect(calculatorProvider.expression, '123');
      });
    });
    //Test Case 6: Advanced Unit Tests
    group('6. Advanced Unit Tests', () {
      test(
        'Complex Expression: should correctly handle order of operations',
        () async {
          // (5 + 3) × 2 - 4 ÷ 2  =>  8 × 2 - 2  =>  16 - 2 = 14
          await _testCalculation('(5+3)×2-4÷2', '14');
        },
      );
      test(
        'Scientific Calculation: should correctly combine sin and cos in Degrees mode',
        () async {
          // sin(45) + cos(45) ≈ 0.7071 + 0.7071 ≈ 1.4142
          // Giả định độ chính xác mặc định là 10
          await _testCalculation('sin(45)+cos(45)', '1.4142135624');
        },
      );
      test('Memory Operations: should handle M+, M+, MR sequence', () async {
        //Xóa bộ nhớ để đảm bảo test sạch
        calculatorProvider.memoryClear();
        expect(calculatorProvider.hasMemory, isFalse);

        //Nhập '5', tính toán và nhấn M+
        await _testCalculation('5', '5');
        calculatorProvider.memoryAdd();
        expect(calculatorProvider.memory, 5.0);
        expect(calculatorProvider.hasMemory, isTrue);

        //Nhập '3', tính toán và nhấn M+
        await _testCalculation('3', '3');
        calculatorProvider.memoryAdd();
        expect(calculatorProvider.memory, 8.0);

        //Nhấn MR (Memory Recall)
        calculatorProvider.memoryRecall();

        //Kiểm tra biểu thức được cập nhật thành giá trị trong bộ nhớ
        //MR sẽ đặt giá trị vào biểu thức
        expect(calculatorProvider.expression, '8.0');
      });

      test(
        'Parentheses Nesting: should handle nested parentheses correctly',
        () async {
          //((2 + 3) × (4 - 1)) ÷ 5  =>  (5 × 3) ÷ 5  =>  15 ÷ 5 = 3
          await _testCalculation('((2+3)×(4-1))÷5', '3');
        },
      );

      test(
        'Mixed Scientific & Constants: should handle mixed constants and functions',
        () async {
          //2 × π × √9  =>  2 × 3.1415... × 3 ≈ 18.8495...
          //Giả định độ chính xác mặc định là 10
          await _testCalculation('2×π×√(9)', '18.8495559215');
        },
      );
    });
  });
}
