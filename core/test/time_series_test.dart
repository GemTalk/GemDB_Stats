import 'package:test/test.dart';
import 'package:vsd_core/vsd_core.dart';

Statistic _stat(String type) => Statistic(
  name: 'S',
  type: type,
  level: 'common',
  units: '',
  isOs: false,
  description: '',
);

TimeSeries _series(List<double> values, {String type = 'counter'}) {
  final series = TimeSeries(statistic: _stat(type));
  for (var i = 0; i < values.length; i++) {
    series.add(1000 * i, values[i]);
  }
  return series;
}

void main() {
  test('an empty series has no stats', () {
    final s = _series([]);
    expect(s.length, 0);
    expect(s.points, isEmpty);
    expect(s.hasData, isFalse);
    expect(s.min, isNull);
    expect(s.max, isNull);
    expect(s.average, isNull);
    expect(s.stddev, 0.0);
  });

  test('a constant series reports its value', () {
    final s = _series([7, 7, 7]);
    expect(s.length, 3);
    expect(s.points.map((p) => p.value), [7, 7, 7]);
    expect(s.points[2].timestamp.millisecondsSinceEpoch, 2000);
    expect(s.hasData, isTrue);
    expect((s.min, s.max, s.average, s.stddev), (7, 7, 7.0, 0.0));
  });

  test('an all-zero series has no data', () {
    expect(_series([0, 0, 0]).hasData, isFalse);
  });

  test('a series that changes after a constant run keeps every value', () {
    final s = _series([3, 3, 3, 5, 3])..trim();
    expect(s.points.map((p) => p.value), [3, 3, 3, 5, 3]);
    expect((s.min, s.max, s.average), (3, 5, 3.4));
    expect(s.stddev, closeTo(0.8, 1e-9));
  });

  test('-0.0 after 0.0 is kept as a change', () {
    final s = _series([0.0, -0.0], type: 'float');
    expect(s.points[1].value, isA<double>());
    expect((s.points[1].value as double).isNegative, isTrue);
  });

  test('points are bounds-checked for a constant series', () {
    final s = _series([1, 1]);
    expect(() => s.points[2], throwsRangeError);
  });

  test('series sharing timestamps take values only', () {
    final timestamps = Timestamps()..add(0);
    final a = TimeSeries(statistic: _stat('counter'), timestamps: timestamps)
      ..addValue(1);
    final b = TimeSeries(statistic: _stat('counter'), timestamps: timestamps)
      ..addValue(0);
    timestamps.add(1000);
    a.addValue(2);
    b.addValue(0);

    expect(a.points.map((p) => p.value), [1, 2]);
    expect(b.points.map((p) => p.value), [0, 0]);
    expect(b.points[1].timestamp.millisecondsSinceEpoch, 1000);
  });
}
