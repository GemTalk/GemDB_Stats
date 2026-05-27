import 'dart:math' as math;

import 'package:vsd/domain/models/statistic.dart';

class DataPoint {
  DataPoint({required this.timestamp, required this.value});
  DateTime timestamp;
  num value;
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
  num? get min => points.isEmpty ? null : points.map((p) => p.value).reduce((a, b) => a < b ? a : b);
  num? get max => points.isEmpty ? null : points.map((p) => p.value).reduce((a, b) => a > b ? a : b);
  double? get average => points.isEmpty ? null : points.map((p) => p.value).reduce((a, b) => a + b) / points.length;
  double get stddev {
    if (points.length <= 1) {
      return 0.0;
    }
    final mean = average!;
    final variance = points.fold<double>(0.0, (sum, p) => sum + math.pow(p.value - mean, 2).toDouble()) / points.length;
    return math.sqrt(variance);
  }
}
