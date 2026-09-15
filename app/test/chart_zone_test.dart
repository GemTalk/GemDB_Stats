import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/chart/chart_utils.dart';
import 'package:vsd/presentation/chart/statistic_line_chart.dart';
import 'package:vsd/presentation/chart/trackball_tooltip.dart';
import 'package:vsd_core/vsd_core.dart';

List<DataPoint> _points({int count = 20}) {
  final base = DateTime.utc(2026, 1, 1, 12);
  return List.generate(
    count,
    (i) => DataPoint(
      timestamp: base.add(Duration(seconds: i * 10)),
      value: 100 + (i % 5) * 20,
    ),
  );
}

/// Drives the chart the way HomePage does: set the global zone, then rebuild.
/// The chart has no key, so its State — hover and zoom — is kept.
class _Host extends StatefulWidget {
  const _Host();

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  // Identity-stable, like the TimeSeries.points view HomePage passes: the
  // chart resets its zoom when the points list identity changes.
  final List<DataPoint> _series = _points();

  void setZone(DisplayZone zone) {
    DisplayTime.zone = zone;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: Center(
        child: SizedBox(
          width: 600,
          height: 400,
          child: StatisticLineChart(points: _series, statisticName: 'CpuLoad'),
        ),
      ),
    ),
  );
}

Future<void> _pumpChart(WidgetTester tester) async {
  await tester.pumpWidget(const _Host());
  await tester.pump();
}

void _setZone(WidgetTester tester, DisplayZone zone) => tester.state<_HostState>(find.byType(_Host)).setZone(zone);

Future<void> _hoverCenter(WidgetTester tester) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await tester.pump();
  await gesture.moveTo(tester.getCenter(find.byType(StatisticLineChart)));
  await tester.pump();
}

/// The tooltip's first Text is its time header.
String _tooltipTimeLabel(WidgetTester tester) => tester
    .widget<Text>(
      find
          .descendant(
            of: find.byType(TrackballTooltip),
            matching: find.byType(Text),
          )
          .first,
    )
    .data!;

Future<void> _dragBox(WidgetTester tester) async {
  final origin = tester.getTopLeft(find.byType(SizedBox).last);
  final gesture = await tester.startGesture(origin + const Offset(200, 150));
  await gesture.moveBy(const Offset(80, 60));
  await gesture.moveBy(const Offset(80, 60));
  await gesture.up();
  await tester.pump();
}

void main() {
  tearDown(() => DisplayTime.zone = const DisplayZone.file());

  // The axis title is painted onto the chart canvas rather than built as a
  // Text widget, so it is asserted at its source.
  test('the axis title names the zone the tick labels are in', () {
    final instant = DateTime.utc(2026, 1, 1, 12);

    DisplayTime.zone = const DisplayZone.utc();
    expect(xAxisTitle(instant), 'Timestamp (UTC)');

    DisplayTime.zone = const DisplayZone.named('Asia/Kolkata');
    expect(xAxisTitle(instant), 'Timestamp (IST)');

    DisplayTime.zone = const DisplayZone.file();
    DisplayTime.fileZone = const FileZone(offsetMs: -8 * 3600000);
    addTearDown(() => DisplayTime.fileZone = FileZone.unknown);
    expect(xAxisTitle(instant), 'Timestamp (-08:00)');
  });

  testWidgets('the tooltip reads the hovered instant in the display zone', (
    tester,
  ) async {
    DisplayTime.zone = const DisplayZone.utc();
    await _pumpChart(tester);
    await _hoverCenter(tester);

    final utcLabel = _tooltipTimeLabel(tester);
    expect(utcLabel, contains('UTC'));

    // A half-hour zone, so a wrong conversion can't coincide with the right one.
    _setZone(tester, const DisplayZone.named('Asia/Kolkata'));
    await tester.pump();

    final istLabel = _tooltipTimeLabel(tester);
    expect(istLabel, contains('IST'));
    // 12:xx UTC is 17:xx IST — the clock really moved, not just the suffix.
    expect(istLabel, isNot(utcLabel));
    expect(utcLabel, contains('12:'));
    expect(istLabel, contains('17:'));
  });

  testWidgets('changing the zone does not reset an active zoom', (tester) async {
    DisplayTime.zone = const DisplayZone.utc();
    await _pumpChart(tester);

    await _dragBox(tester);
    expect(find.byTooltip('Reset zoom'), findsOneWidget);

    // The zoom window is held in epoch ms, which no zone change can move.
    _setZone(tester, const DisplayZone.named('Asia/Kolkata'));
    await tester.pump();
    expect(find.byTooltip('Reset zoom'), findsOneWidget);
  });
}
