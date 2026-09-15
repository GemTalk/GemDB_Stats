import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_test/flutter_test.dart';
import 'package:vsd/presentation/_reusable_components/search_bar.dart';
import 'package:vsd/presentation/process_table.dart';
import 'package:vsd_core/vsd_core.dart';

/// Rebuilds ProcessTable with a new zone without changing its key, the way
/// HomePage does, so the State (and its search query) is kept.
class _Host extends StatefulWidget {
  const _Host();

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  DisplayZone _zone = const DisplayZone.file();
  bool _showYearAndZone = true;

  void setZone(DisplayZone zone) {
    DisplayTime.zone = zone;
    setState(() => _zone = zone);
  }

  void toggleYearAndZone() => setState(() => _showYearAndZone = !_showYearAndZone);

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: SizedBox(
        width: 900,
        height: 400,
        child: ProcessTable(
          // HomePage keys on showYearAndZone, so the State is recreated for it.
          key: ValueKey(_showYearAndZone),
          displayZone: _zone,
          showYearAndZone: _showYearAndZone,
        ),
      ),
    ),
  );
}

void main() {
  setUpAll(() async {
    final dm = DataManager();
    await dm.loadStatistics();
    await dm.loadFromFile('test/test_data/statmon76637.out');
  });

  tearDown(() => DisplayTime.zone = const DisplayZone.file());

  testWidgets('re-formats times on a zone change, keeping the search query', (
    tester,
  ) async {
    await tester.pumpWidget(const _Host());
    await tester.pumpAndSettle();

    // The fixture's zone is -08:00, so the first sample reads 16:09:14 there.
    expect(find.text('2026/02/19 16:09:14'), findsWidgets);
    expect(find.text('Start Time (-08:00)'), findsOneWidget);

    // Filter, then switch zones mid-investigation.
    await tester.enterText(find.byType(SearchBar), 'gs64stone');
    await tester.pumpAndSettle();
    final filteredRows = find.text('2026/02/19 16:09:14').evaluate().length;

    tester.state<_HostState>(find.byType(_Host)).setZone(const DisplayZone.utc());
    await tester.pumpAndSettle();

    // Same instant, eight hours later on the clock.
    expect(find.text('2026/02/19 16:09:14'), findsNothing);
    expect(find.text('2026/02/20 00:09:14'), findsWidgets);
    expect(find.text('Start Time (UTC)'), findsOneWidget);

    // The query survived: the row count is unchanged and the box still holds
    // the text. This is what a ValueKey bump would have thrown away.
    expect(find.text('2026/02/20 00:09:14').evaluate().length, filteredRows);
    expect(find.text('gs64stone'), findsWidgets);
  });

  testWidgets('Show Year & Time Zone drops both halves together', (tester) async {
    await tester.pumpWidget(const _Host());
    await tester.pumpAndSettle();

    expect(find.text('2026/02/19 16:09:14'), findsWidgets);
    expect(find.text('Start Time (-08:00)'), findsOneWidget);

    tester.state<_HostState>(find.byType(_Host)).toggleYearAndZone();
    await tester.pumpAndSettle();

    // Year gone from the cells, zone gone from the header.
    expect(find.text('02/19 16:09:14'), findsWidgets);
    expect(find.text('2026/02/19 16:09:14'), findsNothing);
    expect(find.text('Start Time'), findsOneWidget);
    expect(find.text('End Time'), findsOneWidget);
  });
}
