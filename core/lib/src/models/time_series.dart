import 'dart:collection';
import 'dart:math' as math;

import 'package:typed_data/typed_data.dart';
import 'package:vsd_core/src/models/statistic.dart';

class DataPoint {
  DataPoint({required this.timestamp, required this.value});
  DateTime timestamp;
  num value;
}

/// Stores samples as flat typed arrays rather than a list of boxed objects.
/// This keeps the object count low so the parse isolate can hand the data
/// to the main isolate quickly, and cuts memory usage several-fold.
class TimeSeries {
  TimeSeries({required this.statistic});

  Statistic statistic;
  // Timestamps are pre-shifted to the file's recorded timezone and exposed as UTC DateTimes.
  final Int64Buffer _timestampsMs = Int64Buffer();
  final Float64Buffer _values = Float64Buffer();

  /// Read-only view of the samples as DataPoints, created on demand.
  late final List<DataPoint> points = _PointsView(this);

  int get length => _values.length;

  void add(int timestampMs, double value) {
    _timestampsMs.add(timestampMs);
    _values.add(value);
  }

  /// Integer statistics are parsed from int fields; preserve their type
  /// when exposing values so they display without a trailing ".0".
  num _asNum(double v) => statistic.type == 'float' ? v : v.toInt();

  // Helper methods
  bool get hasData => _values.any((v) => v != 0);
  num? get min => _values.isEmpty ? null : _asNum(_values.reduce(math.min));
  num? get max => _values.isEmpty ? null : _asNum(_values.reduce(math.max));
  double? get average =>
      _values.isEmpty ? null : _values.reduce((a, b) => a + b) / _values.length;
  double get stddev {
    if (_values.length <= 1) {
      return 0.0;
    }
    final mean = average!;
    final variance =
        _values.fold<double>(
          0.0,
          (sum, v) => sum + math.pow(v - mean, 2).toDouble(),
        ) /
        _values.length;
    return math.sqrt(variance);
  }
}

class _PointsView extends ListBase<DataPoint> {
  _PointsView(this._series);

  final TimeSeries _series;

  @override
  int get length => _series.length;

  @override
  DataPoint operator [](int index) => DataPoint(
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      _series._timestampsMs[index],
      isUtc: true,
    ),
    value: _series._asNum(_series._values[index]),
  );

  @override
  set length(int newLength) =>
      throw UnsupportedError('TimeSeries.points is read-only');

  @override
  void operator []=(int index, DataPoint value) =>
      throw UnsupportedError('TimeSeries.points is read-only');
}
