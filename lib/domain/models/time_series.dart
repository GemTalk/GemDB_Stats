import 'package:vsd/domain/models/statistic.dart';

class DataPoint {
  DataPoint({required this.timestamp, required this.value});
  DateTime timestamp;
  double value;
}

class TimeSeries {
  TimeSeries({
    required this.statistic,
    required this.points,
  });

  Statistic statistic;
  List<DataPoint> points;

  // Helper methods
  bool get hasData => points.isNotEmpty && points.any((p) => p.value != 0);
  double? get min => points.isEmpty ? null : points.map((p) => p.value).reduce((a, b) => a < b ? a : b);
  double? get max => points.isEmpty ? null : points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
  double? get average => points.isEmpty ? null : points.map((p) => p.value).reduce((a, b) => a + b) / points.length;
}
