import 'dart:math' as math;

import 'package:cristalyse/cristalyse.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/chart/multi_chart_controller.dart';
import 'package:vsd/presentation/chart/multi_statistic_line_chart.dart';
import 'package:vsd/presentation/chart/statistic_line_chart.dart';
import 'package:vsd_core/vsd_core.dart';

List<DataPoint> _points({int count = 20, double offset = 0}) {
  final base = DateTime.utc(2026, 1, 1, 12);
  return List.generate(
    count,
    (i) => DataPoint(
      timestamp: base.add(Duration(seconds: i * 10)),
      value: offset + 100 + (i % 5) * 20,
    ),
  );
}

typedef _Limits = ({(double?, double?)? x, (double?, double?)? y, (double?, double?)? y2});

// The axis ranges the chart is currently drawn with.
_Limits _limits(WidgetTester tester) {
  final chart = tester.widget<AnimatedCristalyseChartWidget>(find.byType(AnimatedCristalyseChartWidget));
  return (x: chart.xScale?.limits, y: chart.yScale?.limits, y2: chart.y2Scale?.limits);
}

Future<void> _pumpSized(WidgetTester tester, Widget child) async {
  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: Center(
          child: SizedBox(width: 600, height: 400, child: child),
        ),
      ),
    ),
  );
  await tester.pump();
}

// Drags a marquee box well inside the plot area of a 600x400 chart.
Future<void> _dragBox(WidgetTester tester) async {
  final origin = tester.getTopLeft(find.byType(SizedBox).last);
  final start = origin + const Offset(200, 150);
  final gesture = await tester.startGesture(start);
  await gesture.moveBy(const Offset(80, 60));
  await gesture.moveBy(const Offset(80, 60)); // ends at +160,+120 — past thresholds
  await gesture.up();
  await tester.pump();
}

void main() {
  // Pin the display zone: axis tick text would otherwise depend on the zone
  // the test machine is set to. (Only the title names the zone — tick labels
  // stay HH:mm:ss, which is what keeps the hard-coded drag offsets below
  // valid, since sampleXLabel's width sizes the plot rect.)
  setUp(() => DisplayTime.zone = const DisplayZone.utc());
  tearDown(() => DisplayTime.zone = const DisplayZone.file());

  testWidgets('StatisticLineChart drag zooms in and reset clears it', (tester) async {
    await _pumpSized(tester, StatisticLineChart(points: _points(), statisticName: 'CpuLoad'));

    // No zoom yet → no reset button.
    expect(find.byTooltip('Reset zoom'), findsNothing);

    await _dragBox(tester);

    // Zoom applied → reset button appears.
    expect(find.byTooltip('Reset zoom'), findsOneWidget);

    // Tapping reset returns to the full range.
    await tester.tap(find.byTooltip('Reset zoom'));
    await tester.pump();
    expect(find.byTooltip('Reset zoom'), findsNothing);
  });

  testWidgets('StatisticLineChart ignores a click (no drag)', (tester) async {
    await _pumpSized(tester, StatisticLineChart(points: _points(), statisticName: 'CpuLoad'));

    final origin = tester.getTopLeft(find.byType(SizedBox).last);
    await tester.tapAt(origin + const Offset(250, 200));
    await tester.pump();

    expect(find.byTooltip('Reset zoom'), findsNothing);
  });

  testWidgets('MultiStatisticLineChart dual-axis drag zooms in', (tester) async {
    await _pumpSized(
      tester,
      MultiStatisticLineChart(
        primarySeries: [(name: 'A', color: kMultiChartPalette[0], points: _points())],
        secondarySeries: [(name: 'B', color: kMultiChartPalette[1], points: _points())],
      ),
    );

    expect(find.byTooltip('Reset zoom'), findsNothing);

    await _dragBox(tester);

    expect(find.byTooltip('Reset zoom'), findsOneWidget);
  });

  testWidgets('MultiStatisticLineChart keeps its zoom when a series is added', (tester) async {
    final a = (name: 'A', color: kMultiChartPalette[0], points: _points());
    await _pumpSized(tester, MultiStatisticLineChart(primarySeries: [a], secondarySeries: const []));
    final full = _limits(tester);

    await _dragBox(tester);
    final zoomed = _limits(tester);
    final (zoomMinX, zoomMaxX) = zoomed.x!;
    final (zoomMinY, zoomMaxY) = zoomed.y!;
    expect(zoomed.x, isNot(full.x));
    expect(zoomed.y, isNot(full.y));
    // The window still shows some of the plotted data.
    expect(
      a.points.any((p) {
        final x = p.timestamp.millisecondsSinceEpoch;
        return x >= zoomMinX! && x <= zoomMaxX! && p.value >= zoomMinY! && p.value <= zoomMaxY!;
      }),
      isTrue,
    );

    // Each added series widens the full range in both directions, so a lost
    // zoom would change the drawn limits.

    // Another left-axis series.
    final b = (name: 'B', color: kMultiChartPalette[1], points: _points(count: 30, offset: 500));
    await _pumpSized(tester, MultiStatisticLineChart(primarySeries: [a, b], secondarySeries: const []));
    expect(_limits(tester).x, zoomed.x);
    expect(_limits(tester).y, zoomed.y);
    expect(find.byTooltip('Reset zoom'), findsOneWidget);

    // A right-axis series, which turns the chart dual-axis. The left axis keeps
    // its window; the new right axis starts at its full range.
    final c = (name: 'C', color: kMultiChartPalette[2], points: _points(count: 40, offset: 1000));
    await _pumpSized(tester, MultiStatisticLineChart(primarySeries: [a, b], secondarySeries: [c]));
    expect(_limits(tester).x, zoomed.x);
    expect(_limits(tester).y, zoomed.y);
    final (y2Min, y2Max) = _limits(tester).y2!;
    expect(y2Min, lessThanOrEqualTo(c.points.map((p) => p.value).reduce(math.min)));
    expect(y2Max, greaterThanOrEqualTo(c.points.map((p) => p.value).reduce(math.max)));
    expect(find.byTooltip('Reset zoom'), findsOneWidget);
  });

  testWidgets('StatisticLineChart double-tap resets zoom', (tester) async {
    await _pumpSized(tester, StatisticLineChart(points: _points(), statisticName: 'CpuLoad'));

    await _dragBox(tester);
    expect(find.byTooltip('Reset zoom'), findsOneWidget);

    final origin = tester.getTopLeft(find.byType(SizedBox).last);
    final center = origin + const Offset(300, 200);
    await tester.tapAt(center);
    await tester.pump(kDoubleTapMinTime);
    await tester.tapAt(center);
    await tester.pump();
    // Flush the double-tap recognizer's timeout timer.
    await tester.pump(kDoubleTapTimeout);

    expect(find.byTooltip('Reset zoom'), findsNothing);
  });
}
