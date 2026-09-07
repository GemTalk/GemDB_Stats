import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/chart/multi_chart_controller.dart';
import 'package:vsd/presentation/chart/multi_statistic_line_chart.dart';
import 'package:vsd/presentation/chart/series_legend.dart';
import 'package:vsd_core/vsd_core.dart';

Statistic _stat(String name) => Statistic(
  name: name,
  type: 'uvalue',
  level: 'basic',
  units: 'count',
  isOs: false,
  description: '',
);

/// A process whose samples run from [startSecond] for [sampleCount] seconds, so
/// two of them can be given deliberately different — and overlapping — time
/// ranges, as processes in a real capture have.
Process _process({
  required String name,
  required List<String> statNames,
  required int typeId,
  int? processId,
  int startSecond = 0,
  int sampleCount = 5,
  double valueOffset = 0,
}) {
  final stats = statNames.map(_stat).toList();
  final start = DateTime.utc(2026, 1, 1, 12, 0, startSecond);
  final process = Process(
    name: name,
    type: StatType(id: typeId, name: 'T$typeId', statistics: stats),
    startTime: start,
    endTime: start.add(Duration(seconds: sampleCount - 1)),
    samples: sampleCount,
    processId: processId,
    sessionId: null,
  );
  for (final stat in stats) {
    final series = TimeSeries(statistic: stat);
    for (var i = 0; i < sampleCount; i++) {
      series.add(
        start.add(Duration(seconds: i)).millisecondsSinceEpoch,
        valueOffset + i,
      );
    }
    process.statisticData[stat.name] = series;
  }
  return process;
}

Future<void> _pumpSized(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(child: SizedBox(width: 700, height: 400, child: child)),
      ),
    ),
  );
  await tester.pump();
}

Future<void> _hoverCenter(WidgetTester tester, Finder target) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(target));
  await tester.pump();
}

void main() {
  // The same statistic name on two processes — the case that used to be
  // unreachable, and the one where a name-keyed lookup would collide.
  late Process stone;
  late Process gem;
  late MultiChartController controller;

  setUp(() {
    stone = _process(name: 'Stone', statNames: ['PageReads'], typeId: 1);
    gem = _process(
      name: 'Gem',
      statNames: ['PageReads'],
      typeId: 2,
      processId: 1234,
      startSecond: 2,
      valueOffset: 100,
    );
    controller = MultiChartController()..active = true;
  });

  tearDown(() => controller.dispose());

  testWidgets('charts the same statistic from two processes on one axis', (tester) async {
    controller
      ..togglePrimary(SeriesRef(process: stone, statIndex: 0))
      ..togglePrimary(SeriesRef(process: gem, statIndex: 0));

    final series = controller.seriesFor(controller.primary);
    expect(series.map((s) => s.name), ['Stone · PageReads', 'Gem 1234 · PageReads']);
    expect(series[0].color, isNot(series[1].color));

    await _pumpSized(
      tester,
      MultiStatisticLineChart(primarySeries: series, secondarySeries: const []),
    );
    await _hoverCenter(tester, find.byType(MultiStatisticLineChart));

    expect(tester.takeException(), isNull);
    // Both processes contribute a tooltip row, distinguishable by name.
    expect(find.textContaining('Stone · PageReads'), findsOneWidget);
    expect(find.textContaining('Gem 1234 · PageReads'), findsOneWidget);
  });

  testWidgets('splits two processes across the left and right axes', (tester) async {
    controller
      ..togglePrimary(SeriesRef(process: stone, statIndex: 0))
      ..toggleSecondary(SeriesRef(process: gem, statIndex: 0));

    await _pumpSized(
      tester,
      MultiStatisticLineChart(
        primarySeries: controller.seriesFor(controller.primary),
        secondarySeries: controller.seriesFor(controller.secondary),
      ),
    );
    await _hoverCenter(tester, find.byType(MultiStatisticLineChart));

    expect(tester.takeException(), isNull);
    expect(find.textContaining('Stone · PageReads'), findsOneWidget);
    expect(find.textContaining('Gem 1234 · PageReads'), findsOneWidget);
  });

  testWidgets('legend lists each process and removing a series drops it', (tester) async {
    final stoneRef = SeriesRef(process: stone, statIndex: 0);
    controller
      ..togglePrimary(stoneRef)
      ..toggleSecondary(SeriesRef(process: gem, statIndex: 0));

    await _pumpSized(tester, SeriesLegend(controller: controller));

    expect(find.text('Stone'), findsOneWidget);
    expect(find.text('Gem 1234'), findsOneWidget);
    expect(find.text('PageReads'), findsNWidgets(2));
    // Axis affordances reflect which side each series sits on.
    expect(find.text('L'), findsOneWidget);
    expect(find.text('R'), findsOneWidget);

    // Rows follow `all` order — left axis first — so Stone's is the first one.
    await tester.tap(find.text('L'));
    await tester.pump();
    expect(controller.isSecondary(stoneRef), isTrue);
    expect(find.text('R'), findsNWidgets(2));

    // Stone is now last in `all`; remove it and its process heading goes too.
    await tester.tap(find.text('×').last);
    await tester.pump();
    expect(controller.all, hasLength(1));
    expect(find.text('Stone'), findsNothing);
    expect(find.text('Gem 1234'), findsOneWidget);
  });
}
