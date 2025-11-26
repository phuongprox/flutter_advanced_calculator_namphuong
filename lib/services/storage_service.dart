import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  //Khóa để lưu trữ các giá trị trong SharedPreferences.
  static const _themeKey = 'theme_preference';
  static const _historyKey = 'calculation_history';
  static const _memoryKey = 'memory_value';
  static const _settingsKey = 'calculator_settings';

  ///Lưu sở thích chủ đề của người dùng.
  Future<void> saveTheme(String themeName) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, themeName);
  }

  ///Tải sở thích chủ đề đã lưu.
  ///Trả về 'system' nếu không có gì được lưu.
  Future<String> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_themeKey) ?? 'system'; // Giá trị mặc định
  }

  ///Lưu danh sách lịch sử tính toán.
  Future<void> saveHistory(List<String> historyJsonList) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_historyKey, historyJsonList);
  }

  ///Tải danh sách lịch sử đã lưu.
  ///Trả về một danh sách rỗng nếu không có gì được lưu.
  Future<List<String>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_historyKey) ?? []; // Giá trị mặc định
  }

  ///Lưu giá trị bộ nhớ (memory).
  Future<void> saveMemoryValue(double value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble(_memoryKey, value);
  }

  ///Tải giá trị bộ nhớ đã lưu.
  ///Trả về 0.0 nếu không có gì được lưu.
  Future<double> loadMemoryValue() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(_memoryKey) ?? 0.0; // Giá trị mặc định
  }

  ///Xóa tất cả dữ liệu liên quan đến ứng dụng đã lưu.
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    //Xóa từng khóa một để tránh xóa nhầm dữ liệu của các phần khác
    //nếu ứng dụng được mở rộng trong tương lai.
    await Future.wait([
      prefs.remove(_themeKey),
      prefs.remove(_historyKey),
      prefs.remove(_memoryKey),
      prefs.remove(_settingsKey),
    ]);
  }

  /// Lưu chuỗi JSON của đối tượng cài đặt.
  Future<void> saveSettings(String settingsJson) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, settingsJson);
  }

  ///Tải chuỗi JSON của đối tượng cài đặt.
  ///Trả về null nếu không tìm thấy.
  Future<String?> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_settingsKey);
  }
}
