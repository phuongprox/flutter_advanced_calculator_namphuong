import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_caculator_nguyennamphuong/models/angle_mode.dart';
import 'package:flutter_caculator_nguyennamphuong/models/calculator_settings.dart';
import 'package:flutter_caculator_nguyennamphuong/services/storage_service.dart';

class SettingsProvider extends ChangeNotifier {
  final StorageService _storageService;
  late CalculatorSettings _settings;

  ///Getter công khai để truy cập đối tượng cài đặt hiện tại.
  CalculatorSettings get settings => _settings;

  ///Constructor nhận StorageService và tải cài đặt ngay lập tức.
  SettingsProvider(this._storageService) {
    //Khởi tạo với giá trị mặc định trước khi tải
    _settings = CalculatorSettings.initial();
    loadSettings();
  }

  /// Tải cài đặt từ StorageService.
  Future<void> loadSettings() async {
    final settingsJson = await _storageService.loadSettings();
    if (settingsJson != null) {
      _settings = CalculatorSettings.fromJson(jsonDecode(settingsJson));
    }
    //Nếu không có gì được tải, nó sẽ giữ lại giá trị mặc định đã khởi tạo.
    notifyListeners();
  }

  /// Lưu đối tượng cài đặt hiện tại vào bộ nhớ.
  Future<void> _saveSettings() async {
    await _storageService.saveSettings(jsonEncode(_settings.toJson()));
    notifyListeners();
  }

  //Các phương thức Cài đặt

  Future<void> setDecimalPrecision(int precision) async {
    _settings = _settings.copyWith(decimalPrecision: precision);
    await _saveSettings();
  }

  Future<void> setAngleMode(AngleMode mode) async {
    _settings = _settings.copyWith(angleMode: mode);
    await _saveSettings();
  }

  Future<void> setHapticFeedback(bool isEnabled) async {
    _settings = _settings.copyWith(hapticFeedbackEnabled: isEnabled);
    await _saveSettings();
  }

  Future<void> setSoundEffects(bool isEnabled) async {
    _settings = _settings.copyWith(soundEffectsEnabled: isEnabled);
    await _saveSettings();
  }

  Future<void> setHistorySize(int size) async {
    _settings = _settings.copyWith(historySize: size);
    await _saveSettings();
  }
}
