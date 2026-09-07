import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/chart/multi_chart_controller.dart';
import 'package:vsd_core/vsd_core.dart';

Statistic _stat(String name) => Statistic(
  name: name,
  type: 'uvalue',
  level: 'basic',
  units: 'count',
  isOs: false,
  description: '',
);

/// A process carrying [statNames], each with [sampleCount] samples. A statistic
/// with fewer than two samples cannot be drawn, which is what `colorFor` skips.
Process _process({
  required String name,
  required List<String> statNames,
  int typeId = 1,
  int? processId,
  int? sessionId,
  int sampleCount = 3,
  Set<String> emptyStats = const {},
}) {
  final stats = statNames.map(_stat).toList();
  final process = Process(
    name: name,
    type: StatType(id: typeId, name: 'TestType', statistics: stats),
    startTime: DateTime.utc(2026),
    endTime: DateTime.utc(2026),
    samples: sampleCount,
    processId: processId,
    sessionId: sessionId,
  );
  for (final stat in stats) {
    final series = TimeSeries(statistic: stat);
    final count = emptyStats.contains(stat.name) ? 0 : sampleCount;
    for (var i = 0; i < count; i++) {
      series.add(1000 * i, i.toDouble());
    }
    process.statisticData[stat.name] = series;
  }
  return process;
}

void main() {
  group('SeriesRef', () {
    test('distinguishes the same statistic index on two processes', () {
      final gemA = _process(name: 'Gem', statNames: ['PageReads'], processId: 1, sessionId: 10);
      final gemB = _process(name: 'Gem', statNames: ['PageReads'], processId: 1, sessionId: 11);

      final a = SeriesRef(process: gemA, statIndex: 0);
      final b = SeriesRef(process: gemB, statIndex: 0);

      expect(a, isNot(equals(b)));
      expect(a, equals(SeriesRef(process: gemA, statIndex: 0)));
      expect({a, b, SeriesRef(process: gemA, statIndex: 0)}, hasLength(2));
    });

    test('hasData needs at least two samples, unlike TimeSeries.hasData', () {
      final process = _process(
        name: 'Stone',
        statNames: ['Drawable', 'NoSamples'],
        emptyStats: {'NoSamples'},
      );

      expect(SeriesRef(process: process, statIndex: 0).hasData, isTrue);
      expect(SeriesRef(process: process, statIndex: 1).hasData, isFalse);
    });

    test('key matches Process.identityKey, the form the process table compares', () {
      final process = _process(name: 'Gem', statNames: ['PageReads'], typeId: 7, processId: 42, sessionId: 3);

      expect(process.identityKey, '7|3|42|Gem');
      // Mirrors ProcessTable._rowSelectionKey, which builds the same string
      // from grid cells (empty strings for null ids) to avoid a lookup per row.
      expect(process.identityKey, '${process.type.id}|3|42|${process.name}');
      expect(SeriesRef(process: process, statIndex: 0).key, '7|3|42|Gem#0');
    });

    test('displayLabel omits a null process id', () {
      expect(_process(name: 'Stone', statNames: ['A']).displayLabel, 'Stone');
      expect(_process(name: 'Gem', statNames: ['A'], processId: 99).displayLabel, 'Gem 99');
    });
  });

  group('MultiChartController axis toggling', () {
    late Process process;
    late MultiChartController controller;

    setUp(() {
      process = _process(name: 'Gem', statNames: ['A', 'B'], processId: 1);
      controller = MultiChartController();
    });

    tearDown(() => controller.dispose());

    test('a series lives on at most one axis', () {
      final ref = SeriesRef(process: process, statIndex: 0);

      controller.togglePrimary(ref);
      expect(controller.isPrimary(ref), isTrue);
      expect(controller.isSecondary(ref), isFalse);

      controller.toggleSecondary(ref);
      expect(controller.isPrimary(ref), isFalse);
      expect(controller.isSecondary(ref), isTrue);
      expect(controller.all, [ref]);

      controller.togglePrimary(ref);
      expect(controller.isPrimary(ref), isTrue);
      expect(controller.isSecondary(ref), isFalse);
    });

    test('toggling an already-checked series removes it', () {
      final ref = SeriesRef(process: process, statIndex: 0);

      controller.togglePrimary(ref);
      controller.togglePrimary(ref);
      expect(controller.isEmpty, isTrue);

      controller.toggleSecondary(ref);
      controller.toggleSecondary(ref);
      expect(controller.isEmpty, isTrue);
    });

    test('notifies on every mutation, and not on a no-op', () {
      var notifications = 0;
      controller.addListener(() => notifications++);

      controller.togglePrimary(SeriesRef(process: process, statIndex: 0));
      expect(notifications, 1);

      controller.active = true;
      expect(notifications, 2);
      controller.active = true; // already on
      expect(notifications, 2);

      controller.remove(SeriesRef(process: process, statIndex: 1)); // not charted
      expect(notifications, 2);

      controller.clear();
      expect(notifications, 3);
      controller.clear(); // already empty
      expect(notifications, 3);
    });
  });

  group('MultiChartController.colorFor', () {
    test('packs colors over drawable series, left axis first', () {
      final process = _process(name: 'Gem', statNames: ['A', 'B', 'C'], processId: 1);
      final a = SeriesRef(process: process, statIndex: 0);
      final b = SeriesRef(process: process, statIndex: 1);
      final c = SeriesRef(process: process, statIndex: 2);

      final controller = MultiChartController()
        ..togglePrimary(a)
        ..togglePrimary(b)
        ..toggleSecondary(c);
      addTearDown(controller.dispose);

      expect(controller.colorFor(a), kMultiChartPalette[0]);
      expect(controller.colorFor(b), kMultiChartPalette[1]);
      // Secondary picks up straight after the primary series, not from zero.
      expect(controller.colorFor(c), kMultiChartPalette[2]);
    });

    test('skips series with no drawable data so no palette slot is wasted', () {
      final process = _process(
        name: 'Gem',
        statNames: ['A', 'Empty', 'C'],
        processId: 1,
        emptyStats: {'Empty'},
      );
      final a = SeriesRef(process: process, statIndex: 0);
      final empty = SeriesRef(process: process, statIndex: 1);
      final c = SeriesRef(process: process, statIndex: 2);

      final controller = MultiChartController()
        ..togglePrimary(a)
        ..togglePrimary(empty)
        ..togglePrimary(c);
      addTearDown(controller.dispose);

      expect(controller.colorFor(empty), isNull);
      expect(controller.colorFor(a), kMultiChartPalette[0]);
      expect(controller.colorFor(c), kMultiChartPalette[1]);
    });

    test('re-packs when a series is removed', () {
      final process = _process(name: 'Gem', statNames: ['A', 'B'], processId: 1);
      final a = SeriesRef(process: process, statIndex: 0);
      final b = SeriesRef(process: process, statIndex: 1);

      final controller = MultiChartController()
        ..togglePrimary(a)
        ..togglePrimary(b);
      addTearDown(controller.dispose);

      expect(controller.colorFor(b), kMultiChartPalette[1]);
      controller.remove(a);
      expect(controller.colorFor(b), kMultiChartPalette[0]);
    });

    test('returns null for a series that is not charted', () {
      final process = _process(name: 'Gem', statNames: ['A'], processId: 1);
      final controller = MultiChartController();
      addTearDown(controller.dispose);

      expect(controller.colorFor(SeriesRef(process: process, statIndex: 0)), isNull);
    });
  });

  group('MultiChartController labelling', () {
    test('qualifies names only once the selection spans processes', () {
      final gemA = _process(name: 'Gem', statNames: ['PageReads'], processId: 1);
      final gemB = _process(name: 'Gem', statNames: ['PageReads'], processId: 2);
      final a = SeriesRef(process: gemA, statIndex: 0);
      final b = SeriesRef(process: gemB, statIndex: 0);

      final controller = MultiChartController()..togglePrimary(a);
      addTearDown(controller.dispose);

      expect(controller.spansMultipleProcesses, isFalse);
      expect(controller.labelFor(a), 'PageReads');

      controller.togglePrimary(b);
      expect(controller.spansMultipleProcesses, isTrue);
      expect(controller.labelFor(a), 'Gem 1 · PageReads');
      expect(controller.labelFor(b), 'Gem 2 · PageReads');

      // Dropping back to one process restores the unqualified name.
      controller.remove(b);
      expect(controller.labelFor(a), 'PageReads');
    });

    test('several statistics on one process stay unqualified', () {
      final process = _process(name: 'Gem', statNames: ['A', 'B'], processId: 1);
      final controller = MultiChartController()
        ..togglePrimary(SeriesRef(process: process, statIndex: 0))
        ..toggleSecondary(SeriesRef(process: process, statIndex: 1));
      addTearDown(controller.dispose);

      expect(controller.spansMultipleProcesses, isFalse);
      expect(controller.labelFor(SeriesRef(process: process, statIndex: 1)), 'B');
    });
  });

  group('MultiChartController.seriesFor', () {
    test('drops undrawable series so chart order matches the color packing', () {
      final process = _process(
        name: 'Gem',
        statNames: ['A', 'Empty', 'C'],
        processId: 1,
        emptyStats: {'Empty'},
      );
      final controller = MultiChartController()
        ..togglePrimary(SeriesRef(process: process, statIndex: 0))
        ..togglePrimary(SeriesRef(process: process, statIndex: 1))
        ..togglePrimary(SeriesRef(process: process, statIndex: 2));
      addTearDown(controller.dispose);

      final series = controller.seriesFor(controller.primary);
      expect(series.map((s) => s.name), ['A', 'C']);
      expect(series.map((s) => s.color), [kMultiChartPalette[0], kMultiChartPalette[1]]);
      expect(series.first.points, hasLength(3));
    });

    test('carries qualified names across processes', () {
      final stone = _process(name: 'Stone', statNames: ['PageReads'], typeId: 1);
      final gem = _process(name: 'Gem', statNames: ['PageReads'], typeId: 2, processId: 7);
      final controller = MultiChartController()
        ..togglePrimary(SeriesRef(process: stone, statIndex: 0))
        ..toggleSecondary(SeriesRef(process: gem, statIndex: 0));
      addTearDown(controller.dispose);

      expect(controller.seriesFor(controller.primary).single.name, 'Stone · PageReads');
      expect(controller.seriesFor(controller.secondary).single.name, 'Gem 7 · PageReads');
    });
  });

  test('reset clears the selection and leaves the mode', () {
    final process = _process(name: 'Gem', statNames: ['A'], processId: 1);
    final controller = MultiChartController()
      ..active = true
      ..togglePrimary(SeriesRef(process: process, statIndex: 0));
    addTearDown(controller.dispose);

    controller.reset();
    expect(controller.active, isFalse);
    expect(controller.isEmpty, isTrue);
  });
}
