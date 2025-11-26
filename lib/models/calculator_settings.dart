import 'package:flutter_caculator_nguyennamphuong/models/angle_mode.dart';

/// Model để lưu trữ các cài đặt của người dùng cho máy tính.
final class CalculatorSettings {
  final int decimalPrecision;
  final AngleMode angleMode;
  final bool hapticFeedbackEnabled;
  final bool soundEffectsEnabled;
  final int historySize;

  /// Constructor với các thuộc tính bắt buộc.
  const CalculatorSettings({
    required this.decimalPrecision,
    required this.angleMode,
    required this.hapticFeedbackEnabled,
    required this.soundEffectsEnabled,
    required this.historySize,
  });

  /// Constructor mặc định cho các cài đặt ban đầu.
  factory CalculatorSettings.initial() {
    return const CalculatorSettings(
      decimalPrecision: 10,
      angleMode: AngleMode.degrees,
      hapticFeedbackEnabled: true,
      soundEffectsEnabled: false,
      historySize: 50,
    );
  }

  /// Chuyển đổi đối tượng thành một Map JSON để lưu trữ.
  Map<String, dynamic> toJson() {
    return {
      'decimalPrecision': decimalPrecision,
      'angleMode': angleMode.name, // Lưu tên của enum
      'hapticFeedbackEnabled': hapticFeedbackEnabled,
      'soundEffectsEnabled': soundEffectsEnabled,
      'historySize': historySize,
    };
  }

  /// Tạo một đối tượng CalculatorSettings từ một Map JSON.
  factory CalculatorSettings.fromJson(Map<String, dynamic> json) {
    return CalculatorSettings(
      decimalPrecision: json['decimalPrecision'] as int,
      angleMode: AngleMode.values.byName(json['angleMode'] as String),
      hapticFeedbackEnabled: json['hapticFeedbackEnabled'] as bool,
      soundEffectsEnabled: json['soundEffectsEnabled'] as bool,
      historySize: json['historySize'] as int,
    );
  }

  CalculatorSettings copyWith({
    int? decimalPrecision,
    AngleMode? angleMode,
    bool? hapticFeedbackEnabled,
    bool? soundEffectsEnabled,
    int? historySize,
  }) {
    return CalculatorSettings(
      decimalPrecision: decimalPrecision ?? this.decimalPrecision,
      angleMode: angleMode ?? this.angleMode,
      hapticFeedbackEnabled:
          hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      historySize: historySize ?? this.historySize,
    );
  }
}
