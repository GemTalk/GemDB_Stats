import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/chart/chart_utils.dart';
import 'package:vsd/presentation/chart/multi_chart_controller.dart';
import 'package:vsd/presentation/chart/multi_statistic_line_chart.dart';
import 'package:vsd/presentation/chart/statistic_line_chart.dart';
import 'package:vsd_core/vsd_core.dart';

// Two samples sharing one timestamp. Sample times have 1-second resolution
// (data_manager stores `seconds * 1000`), so any capture spanning under a
// second collapses to first.timestamp == last.timestamp, i.e. maxX == minX.
List<DataPoint> _sameTimestampPoints() {
  final t = DateTime.utc(2026, 1, 1, 12);
  return [
    DataPoint(timestamp: t, value: 100),
    DataPoint(timestamp: t, value: 200),
  ];
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

// Moves a mouse pointer to the center of [chart] to trigger MouseRegion.onHover,
// which is what drives the crosshair overlay.
Future<void> _hoverCenter(WidgetTester tester, Finder chart) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(chart));
  await tester.pump();
}

void main() {
  group('dataXToPixel', () {
    const plot = Rect.fromLTWH(50, 10, 500, 300);

    test('maps proportionally within a normal range', () {
      expect(dataXToPixel(0, plot, 0, 100), 50); // left edge
      expect(dataXToPixel(100, plot, 0, 100), 550); // right edge
      expect(dataXToPixel(50, plot, 0, 100), 300); // midpoint
    });

    test('returns plot center (never NaN) when the x range is degenerate', () {
      // maxX == minX would divide 0/0 → NaN; helper must center instead.
      final px = dataXToPixel(1000, plot, 1000, 1000);
      expect(px.isFinite, isTrue);
      expect(px, plot.left + plot.width / 2);
    });
  });

  testWidgets('StatisticLineChart hover over single-timestamp series does not crash', (tester) async {
    await _pumpSized(
      tester,
      StatisticLineChart(points: _sameTimestampPoints(), statisticName: 'WriteKBytes'),
    );

    await _hoverCenter(tester, find.byType(StatisticLineChart));

    // Before the fix this hover produced a NaN crosshair Offset and threw
    // inside CrosshairPainter.paint.
    expect(tester.takeException(), isNull);
  });

  testWidgets('MultiStatisticLineChart hover over single-timestamp series does not crash', (tester) async {
    await _pumpSized(
      tester,
      MultiStatisticLineChart(
        primarySeries: [(name: 'WriteKBytes', color: kMultiChartPalette[0], points: _sameTimestampPoints())],
        secondarySeries: const [],
      ),
    );

    await _hoverCenter(tester, find.byType(MultiStatisticLineChart));

    expect(tester.takeException(), isNull);
  });
}
