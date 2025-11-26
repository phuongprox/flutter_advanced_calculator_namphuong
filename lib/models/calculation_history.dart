/// Model dữ liệu cho một mục trong lịch sử tính toán.
final class CalculationHistory {
  final String expression;
  final String result;
  final DateTime timestamp;

  /// Constructor với các thuộc tính bắt buộc.
  const CalculationHistory({
    required this.expression,
    required this.result,
    required this.timestamp,
  });

  /// Chuyển đổi đối tượng thành một Map JSON.
  /// DateTime được lưu dưới dạng chuỗi ISO 8601.
  Map<String, dynamic> toJson() {
    return {
      'expression': expression,
      'result': result,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  /// Tạo một đối tượng CalculationHistory từ một Map JSON.
  factory CalculationHistory.fromJson(Map<String, dynamic> json) {
    return CalculationHistory(
      expression: json['expression'] as String,
      result: json['result'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }
}
