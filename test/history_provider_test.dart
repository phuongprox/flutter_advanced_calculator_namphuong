import 'dart:convert';

import 'package:flutter_caculator_nguyennamphuong/models/calculation_history.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/calculator_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/history_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'history_provider_test.mocks.dart';

// Annotation để Mockito tự động tạo file mock
@GenerateMocks([StorageService, CalculatorProvider])
void main() {
  // Khai báo các đối tượng mock và provider
  late MockStorageService mockStorageService;
  late MockCalculatorProvider mockCalculatorProvider;
  late HistoryProvider historyProvider;

  setUp(() {
    // Khởi tạo các mock object trước mỗi test
    mockStorageService = MockStorageService();
    mockCalculatorProvider = MockCalculatorProvider();
    // Cung cấp các mock object cho HistoryProvider
    historyProvider = HistoryProvider(
      mockCalculatorProvider,
      mockStorageService,
    );
  });

  group('HistoryProvider Tests', () {
    // --- Test Case: History Persistence ---
    group('History Persistence', () {
      final testHistoryItem = CalculationHistory(
        expression: '1+1',
        result: '2',
        timestamp: DateTime.now(),
      );

      test(
        'should call storageService.saveHistory when an item is added',
        () async {
          // Giả lập rằng việc lưu sẽ thành công
          when(
            mockStorageService.saveHistory(any),
          ).thenAnswer((_) async => Future.value());

          // Hành động: Thêm một mục vào lịch sử
          await historyProvider.addHistory(testHistoryItem);

          // Kiểm tra: Phương thức saveHistory đã được gọi đúng 1 lần với dữ liệu đúng
          verify(
            mockStorageService.saveHistory([
              jsonEncode(testHistoryItem.toJson()),
            ]),
          ).called(1);
        },
      );

      test('should limit history to 50 items', () async {
        // Giả lập việc lưu thành công
        when(
          mockStorageService.saveHistory(any),
        ).thenAnswer((_) async => Future.value());

        // Hành động: Thêm 51 mục vào lịch sử
        for (int i = 0; i < 51; i++) {
          await historyProvider.addHistory(
            CalculationHistory(
              expression: '$i',
              result: '$i',
              timestamp: DateTime.now(),
            ),
          );
        }

        // Kiểm tra: Danh sách lịch sử chỉ chứa 50 mục
        expect(historyProvider.history.length, 50);
        // Kiểm tra mục đầu tiên là mục cuối cùng được thêm vào ('50')
        expect(historyProvider.history.first.expression, '50');
        // Kiểm tra mục cuối cùng là mục thứ hai được thêm vào ('1')
        expect(historyProvider.history.last.expression, '1');
      });
    });

    // --- Test Case: History Load ---
    group('History Load', () {
      test('should parse and load history from StorageService', () async {
        // Chuẩn bị dữ liệu mock trả về từ StorageService
        final historyJsonList = [
          jsonEncode(
            CalculationHistory(
              expression: '1+1',
              result: '2',
              timestamp: DateTime.now(),
            ).toJson(),
          ),
          jsonEncode(
            CalculationHistory(
              expression: '2*3',
              result: '6',
              timestamp: DateTime.now(),
            ).toJson(),
          ),
        ];

        // Giả lập: Khi loadHistory được gọi, trả về danh sách JSON đã chuẩn bị
        when(
          mockStorageService.loadHistory(),
        ).thenAnswer((_) async => historyJsonList);

        // Hành động: Tải lịch sử
        await historyProvider.loadHistory();

        // Kiểm tra: Danh sách lịch sử trong provider đã được điền đúng
        expect(historyProvider.history.length, 2);
        expect(historyProvider.history[0].expression, '1+1');
        expect(historyProvider.history[1].result, '6');
      });
    });

    // --- Test Case: Reuse Calculation ---
    test(
      'reuseCalculation should call reuseExpression on CalculatorProvider',
      () {
        final historyItem = CalculationHistory(
          expression: '10-5',
          result: '5',
          timestamp: DateTime.now(),
        );

        historyProvider.reuseCalculation(historyItem);

        verify(mockCalculatorProvider.reuseExpression('10-5')).called(1);
      },
    );
  });
}
