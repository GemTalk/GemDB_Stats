import 'package:flutter/material.dart';
import 'package:vsd_core/vsd_core.dart';

/// MultiChart series colors in assignment order. Both chart modes derive their
/// colors from this palette; see [MultiChartController.colorFor].
const List<Color> kMultiChartPalette = [
  Colors.blue,
  Colors.red,
  Colors.green,
  Colors.orange,
  Colors.purple,
  Colors.brown,
  Colors.pink,
  Colors.grey,
  Colors.cyan,
  Colors.lime,
  Color(0xFF1A237E), // indigo 900
  Color(0xFFB71C1C), // red 900
  Color(0xFF00695C), // teal 800
  Color(0xFFE65100), // orange 900
  Color(0xFF4A148C), // purple 900
  Color(0xFF827717), // lime 900
  Color(0xFFAD1457), // pink 800
  Color(0xFF37474F), // blueGrey 800
  Color(0xFF0288D1), // lightBlue 700
  Color(0xFF558B2F), // lightGreen 800
];

/// A statistic from a specific [Process], identified by its statistics index.
@immutable
class SeriesRef {
  const SeriesRef({required this.process, required this.statIndex});

  final Process process;
  final int statIndex;

  bool get isValid => statIndex >= 0 && statIndex < process.type.statistics.length;

  Statistic get statistic => process.type.statistics[statIndex];

  TimeSeries? get timeSeries => process.statisticData[statistic.name];

  /// Whether this series has at least two points to draw; unlike
  /// [TimeSeries.hasData], this does not check for non-zero samples.
  bool get hasData => isValid && (timeSeries?.points.length ?? 0) >= 2;

  String get key => '${process.identityKey}#$statIndex';

  @override
  bool operator ==(Object other) => other is SeriesRef && other.key == key;

  @override
  int get hashCode => key.hashCode;

  @override
  String toString() => 'SeriesRef($key)';
}

/// Tracks the series shown in MultiChart mode, including axis placement and
/// color. Shared by the table, chart, and legend so they stay in sync. It
/// persists across process changes so one chart can span multiple processes.
class MultiChartController extends ChangeNotifier {
  bool _active = false;
  final List<SeriesRef> _primary = [];
  final List<SeriesRef> _secondary = [];

  /// Whether MultiChart mode is on. When false the chart area falls back to the
  /// single selected statistic.
  bool get active => _active;

  set active(bool value) {
    if (_active == value) {
      return;
    }
    _active = value;
    notifyListeners();
  }

  /// Left-axis series in stable addition, color, and legend order.
  List<SeriesRef> get primary => List.unmodifiable(_primary);

  /// Right-axis series, drawn dashed.
  List<SeriesRef> get secondary => List.unmodifiable(_secondary);

  bool get isEmpty => _primary.isEmpty && _secondary.isEmpty;

  bool isPrimary(SeriesRef ref) => _primary.contains(ref);

  bool isSecondary(SeriesRef ref) => _secondary.contains(ref);

  /// Every charted series, left axis first: the order [colorFor] indexes into.
  List<SeriesRef> get all => [..._primary, ..._secondary];

  /// Toggles [ref] on the left axis, removing it from the right if needed.
  void togglePrimary(SeriesRef ref) {
    if (_primary.remove(ref)) {
      notifyListeners();
      return;
    }
    _secondary.remove(ref);
    _primary.add(ref);
    notifyListeners();
  }

  /// Puts [ref] on the right axis, or takes it off if it is already there.
  void toggleSecondary(SeriesRef ref) {
    if (_secondary.remove(ref)) {
      notifyListeners();
      return;
    }
    _primary.remove(ref);
    _secondary.add(ref);
    notifyListeners();
  }

  void remove(SeriesRef ref) {
    if (_primary.remove(ref) || _secondary.remove(ref)) {
      notifyListeners();
    }
  }

  void clear() {
    if (isEmpty) {
      return;
    }
    _primary.clear();
    _secondary.clear();
    notifyListeners();
  }

  /// Clears the selection and leaves MultiChart mode. Used after loading a
  /// file, when the [Process] objects the selection referred to are gone.
  void reset() {
    _primary.clear();
    _secondary.clear();
    _active = false;
    notifyListeners();
  }

  /// Returns [ref]'s color, packed by drawable series (left axis, then right),
  /// or null if it is uncharted or has no drawable data.
  Color? colorFor(SeriesRef ref) {
    final drawable = all.where((s) => s.hasData).toList();
    final index = drawable.indexOf(ref);
    if (index < 0) {
      return null;
    }
    return kMultiChartPalette[index % kMultiChartPalette.length];
  }

  /// Whether the charted series span more than one process, which is what makes
  /// a bare statistic name ambiguous.
  bool get spansMultipleProcesses => all.map((s) => s.process.identityKey).toSet().length > 1;

  /// Legend and tooltip label, qualified by process when necessary.
  String labelFor(SeriesRef ref) {
    if (!ref.isValid) {
      return '';
    }
    return spansMultipleProcesses ? '${ref.process.displayLabel} · ${ref.statistic.name}' : ref.statistic.name;
  }

  /// Projects [refs] into chart data, dropping empty series so ordering matches
  /// [colorFor].
  List<({String name, Color color, List<DataPoint> points})> seriesFor(
    List<SeriesRef> refs,
  ) {
    return [
      for (final ref in refs)
        if (colorFor(ref) case final color?)
          (
            name: labelFor(ref),
            color: color,
            points: ref.timeSeries?.points ?? const <DataPoint>[],
          ),
    ];
  }
}
