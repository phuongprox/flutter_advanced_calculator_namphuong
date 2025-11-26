import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  static const _themeModeKey = 'theme_mode';
  ThemeMode _themeMode = ThemeMode.system;
  ThemeProvider() {
    _loadThemePreference();
  }

  ///Getter công khai cho themeMode hiện tại.
  ThemeMode get themeMode => _themeMode;

  ///Getter để xác định màu nền chính dựa trên theme hiện tại.
  Color get primaryColor {
    final brightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (_themeMode == ThemeMode.system) {
      return brightness == Brightness.dark
          ? darkTheme.scaffoldBackgroundColor
          : lightTheme.scaffoldBackgroundColor;
    }
    return _themeMode == ThemeMode.dark
        ? darkTheme.scaffoldBackgroundColor
        : lightTheme.scaffoldBackgroundColor;
  }

  bool get isDarkMode {
    if (_themeMode == ThemeMode.system) {
      return WidgetsBinding.instance.platformDispatcher.platformBrightness ==
          Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  ///Chủ đề cho chế độ Sáng (Light).
  ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFFF0F0F0),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1E1E1E),
        secondary: Color(0xFF424242),
        tertiary: Color(0xFFFF6B6B),
      ),
    );
  }

  ///Chủ đề cho chế độ Tối (Dark).
  ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: const Color(0xFF121212),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF121212),
        secondary: Color(0xFF2C2C2C),
        tertiary: Color(0xFF4ECDC4),
      ),
    );
  }

  ///Udpt ThemeMode và lưu lựa chọn.
  Future<void> setTheme(ThemeMode mode) async {
    if (_themeMode == mode) return;
    _themeMode = mode;
    await _saveThemePreference(mode);
    notifyListeners();
  }

  /// Lưu lựa chọn ThemeMode vào SharedPreferences.
  Future<void> _saveThemePreference(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeModeKey, mode.index);
  }

  /// Tải lựa chọn ThemeMode từ SharedPreferences.
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    final savedThemeIndex = prefs.getInt(_themeModeKey);
    if (savedThemeIndex != null) {
      _themeMode = ThemeMode.values[savedThemeIndex];
      notifyListeners();
    }
  }
}
