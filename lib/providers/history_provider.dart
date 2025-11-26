import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_caculator_nguyennamphuong/models/calculation_history.dart';
import 'package:flutter_caculator_nguyennamphuong/providers/calculator_provider.dart';
import 'package:flutter_caculator_nguyennamphuong/services/storage_service.dart';

class HistoryProvider extends ChangeNotifier {
  final CalculatorProvider _calculatorProvider;
  final StorageService _storageService;
  static const _maxHistoryItems = 50;
  List<CalculationHistory> _history = [];
  List<CalculationHistory> get history => _history;
  HistoryProvider(this._calculatorProvider, this._storageService) {
    loadHistory();
  }

  /// Tải lịch sử từ StorageService.
  Future<void> loadHistory() async {
    final historyJsonList = await _storageService.loadHistory();
    _history = historyJsonList
        .map(
          (jsonString) => CalculationHistory.fromJson(jsonDecode(jsonString)),
        )
        .toList();
    notifyListeners();
  }

  /// Lưu lịch sử hiện tại thông qua StorageService.
  Future<void> _saveHistory() async {
    final List<String> historyJsonList = _history
        .map((item) => jsonEncode(item.toJson()))
        .toList();
    await _storageService.saveHistory(historyJsonList);
  }

  /// Thêm một mục mới vào lịch sử và lưu lại.
  Future<void> addHistory(CalculationHistory item) async {
    // Thêm vào đầu danh sách
    _history.insert(0, item);
    // Giới hạn danh sách chỉ chứa 50 mục gần nhất
    if (_history.length > _maxHistoryItems) {
      _history = _history.sublist(0, _maxHistoryItems);
    }
    notifyListeners();
    await _saveHistory();
  }

  /// Xóa toàn bộ lịch sử.
  Future<void> clearAllHistory() async {
    _history.clear();
    notifyListeners();
    // Gọi StorageService để xóa tất cả dữ liệu
    await _storageService.clearAll();
  }

  /// Tái sử dụng một phép tính từ lịch sử.
  /// Sao chép biểu thức của mục lịch sử được chọn vào CalculatorProvider.
  void reuseCalculation(CalculationHistory item) {
    _calculatorProvider.reuseExpression(item.expression);
  }
}
