import 'package:flutter/material.dart';
import 'package:flutter_caculator_nguyennamphuong/main.dart' as app;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Đảm bảo rằng integration test binding đã được khởi tạo
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Theme Switching and Persistence Integration Test', () {
    // Trước mỗi test, xóa dữ liệu SharedPreferences để đảm bảo môi trường sạch
    setUp(() async {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    });

    testWidgets('Theme switches from light to dark and persists after restart', (
      WidgetTester tester,
    ) async {
      // --- PHẦN 1: KIỂM TRA CHUYỂN ĐỔI THEME ---

      // 1. Khởi động ứng dụng
      app.main();
      await tester.pumpAndSettle();

      // 2. Kiểm tra ban đầu: Ứng dụng đang ở Light Mode
      // Tìm Scaffold của CalculatorScreen và kiểm tra màu nền của nó.
      final initialScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      // Giả định màu nền của light theme là Colors.white hoặc tương tự
      expect(initialScaffold.backgroundColor, isNot(Colors.black));

      // 3. Điều hướng đến màn hình Cài đặt
      await tester.tap(find.byKey(const Key('settings_button')));
      await tester.pumpAndSettle(); // Chờ animation chuyển trang hoàn tất

      // 4. Kiểm tra đã ở màn hình Cài đặt
      expect(find.text('Cài đặt'), findsOneWidget);

      // 5. Chuyển sang Dark Mode
      await tester.tap(find.byKey(const Key('theme_switch')));
      await tester.pumpAndSettle(); // Chờ theme được áp dụng

      // 6. Kiểm tra màn hình Cài đặt đã chuyển sang Dark Mode
      final settingsScaffold = tester.widget<Scaffold>(
        find.byType(Scaffold).last,
      );
      // Giả định màu nền của dark theme là một màu tối
      expect(
        Theme.of(tester.element(find.byType(Scaffold).last)).brightness,
        Brightness.dark,
      );

      // 7. Quay lại màn hình chính
      await tester.pageBack();
      await tester.pumpAndSettle();

      // 8. Kiểm tra màn hình chính đã ở Dark Mode
      final mainScaffoldAfterSwitch = tester.widget<Scaffold>(
        find.byType(Scaffold),
      );
      expect(
        Theme.of(tester.element(find.byType(Scaffold))).brightness,
        Brightness.dark,
      );

      // --- PHẦN 2: KIỂM TRA TÍNH BỀN VỮNG (PERSISTENCE) ---

      // 9. "Khởi động lại" ứng dụng.
      // Trong integration test, chúng ta không thể tắt và mở lại app,
      // nhưng việc pump lại widget gốc (app.MyApp()) với SharedPreferences đã được lưu
      // sẽ mô phỏng lại quá trình khởi động và tải lại trạng thái.
      await tester.pumpWidget(
        const app.CalculatorApp(),
      ); // SỬA LỖI: Thay thế MyApp bằng tên Widget gốc chính xác của bạn
      await tester.pumpAndSettle();

      // 10. Kiểm tra ứng dụng có khởi động với Dark Mode đã lưu không.
      // Không cần làm gì thêm, chỉ cần xác minh theme hiện tại.
      final finalScaffold = tester.widget<Scaffold>(find.byType(Scaffold));
      expect(
        Theme.of(tester.element(find.byType(Scaffold))).brightness,
        Brightness.dark,
        reason: 'App should load with the persisted Dark Theme',
      );
    });
  });
}
