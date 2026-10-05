import 'dart:collection';
import 'dart:math' as math;

import 'package:typed_data/typed_data.dart';
import 'package:vsd_core/src/models/statistic.dart';

class DataPoint {
  DataPoint({required this.timestamp, required this.value});
  DateTime timestamp;
  num value;
}

/// Sample times, as epoch ms, held once per process and shared by all of its
/// [TimeSeries]: a process records every statistic at each sample time.
class Timestamps {
  // Held as doubles because the web has no Int64List; epoch ms is far below
  // 2^53, so every value is exact.
  Float64Buffer _ms = Float64Buffer();

  int get length => _ms.length;

  int operator [](int index) => _ms[index].toInt();

  void add(int timestampMs) => _ms.add(timestampMs.toDouble());

  /// Releases the spare capacity left by growing while samples were added.
  void trim() => _ms = _trimmed(_ms);
}

/// Stores samples as flat typed arrays rather than a list of boxed objects.
/// This keeps the object count low so the parse isolate can hand the data
/// to the main isolate quickly, and cuts memory usage several-fold.
class TimeSeries {
  /// A series with its own [timestamps], or ones shared with the other
  /// statistics of its process. A series that shares them is filled with
  /// [addValue], after its owner adds each timestamp.
  TimeSeries({required this.statistic, Timestamps? timestamps})
    : timestamps = timestamps ?? Timestamps(),
      _ownsTimestamps = timestamps == null;

  Statistic statistic;
  // Timestamps are true instants: epoch ms, exposed as UTC DateTimes.
  final Timestamps timestamps;
  final bool _ownsTimestamps;

  // Most series never change: in a large file, two-thirds of all values are
  // in constant series, most of them zero. So a series holds one value until
  // a different one arrives, and only then stores each value.
  int _length = 0;
  double _constant = 0;
  Float64Buffer? _values;

  /// Read-only view of the samples as DataPoints, created on demand.
  late final List<DataPoint> points = _PointsView(this);

  int get length => _length;

  /// Adds a sample to a series that owns its timestamps.
  void add(int timestampMs, double value) {
    assert(_ownsTimestamps, 'Shared timestamps are added by their owner');
    timestamps.add(timestampMs);
    _append(value);
  }

  /// Adds the value for the latest of the shared [timestamps].
  void addValue(double value) {
    assert(_length < timestamps.length, 'No timestamp for this value');
    _append(value);
  }

  void _append(double value) {
    final values = _values;
    if (values != null) {
      values.add(value);
    } else if (_length == 0 || _same(value, _constant)) {
      _constant = value;
    } else {
      _values = Float64Buffer(_length)
        ..fillRange(0, _length, _constant)
        ..add(value);
    }
    _length++;
  }

  /// Equal, and for zero the same sign, so a -0.0 sample is kept as -0.0.
  static bool _same(double a, double b) =>
      a == b && (a != 0 || a.isNegative == b.isNegative);

  double _valueAt(int index) => _values?[index] ?? _constant;

  /// Releases the spare capacity left by growing while samples were added.
  void trim() {
    final values = _values;
    if (values != null) {
      _values = _trimmed(values);
    }
    if (_ownsTimestamps) {
      timestamps.trim();
    }
  }

  /// Integer statistics are parsed from int fields; preserve their type
  /// when exposing values so they display without a trailing ".0".
  num _asNum(double v) => statistic.type == 'float' ? v : v.toInt();

  // Helper methods
  bool get hasData =>
      _values?.any((v) => v != 0) ?? (_length > 0 && _constant != 0);
  num? get min =>
      _length == 0 ? null : _asNum(_values?.reduce(math.min) ?? _constant);
  num? get max =>
      _length == 0 ? null : _asNum(_values?.reduce(math.max) ?? _constant);
  double? get average {
    if (_length == 0) {
      return null;
    }
    final values = _values;
    return values == null
        ? _constant
        : values.reduce((a, b) => a + b) / _length;
  }

  double get stddev {
    final values = _values;
    if (_length <= 1 || values == null) {
      return 0.0;
    }
    final mean = average!;
    final variance =
        values.fold<double>(
          0.0,
          (sum, v) => sum + math.pow(v - mean, 2).toDouble(),
        ) /
        _length;
    return math.sqrt(variance);
  }
}

class _PointsView extends ListBase<DataPoint> {
  _PointsView(this._series);

  final TimeSeries _series;

  @override
  int get length => _series.length;

  @override
  DataPoint operator [](int index) {
    // A constant series has no array to bounds-check the index.
    RangeError.checkValidIndex(index, this);
    return _point(index);
  }

  DataPoint _point(int index) => DataPoint(
    timestamp: DateTime.fromMillisecondsSinceEpoch(
      _series.timestamps[index],
      isUtc: true,
    ),
    value: _series._asNum(_series._valueAt(index)),
  );

  @override
  set length(int newLength) =>
      throw UnsupportedError('TimeSeries.points is read-only');

  @override
  void operator []=(int index, DataPoint value) =>
      throw UnsupportedError('TimeSeries.points is read-only');
}

/// A copy of [buffer] with no spare capacity: a buffer doubles as it grows.
Float64Buffer _trimmed(Float64Buffer buffer) =>
    Float64Buffer(buffer.length)..setRange(0, buffer.length, buffer);
