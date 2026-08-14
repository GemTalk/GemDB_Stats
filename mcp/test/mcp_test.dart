import 'package:test/test.dart';
import 'package:vsd_core/vsd_core.dart';
import 'package:vsd_mcp/vsd_mcp.dart';
import 'package:vsd_mcp/src/mcp/guides/analysis_guides.dart';
import 'package:vsd_mcp/src/mcp/tools/analytics_tools.dart';
import 'package:vsd_mcp/src/mcp/tools/guide_tools.dart';
import 'package:vsd_mcp/src/mcp/tools/process_tools.dart';

const _fixture = 'test/test_data/statmon76637.out';

void main() {
  group('embedded stat definitions', () {
    test('loadStatistics populates statistics from the embedded tcl', () async {
      final dm = DataManager();
      await dm.loadStatistics();
      expect(dm.statistics, isNotEmpty);
      // A few well-known GemStone statistics should be present.
      expect(dm.statistics.containsKey('PageReads'), isTrue);
      expect(dm.statistics['PageReads']!.units, isNotEmpty);
    });
  });

  group('loadFromFile + tools', () {
    setUpAll(() async {
      final dm = DataManager();
      await dm.loadStatistics();
      await dm.loadFromFile(_fixture);
    });

    test('parses processes end-to-end', () {
      final dm = DataManager();
      expect(dm.statTypes, isNotEmpty);
      expect(dm.allProcesses, isNotEmpty);
    });

    test('list_processes returns loaded processes', () {
      final result = executeListProcesses();
      final processes = result['processes'] as List;
      expect(processes, isNotEmpty);
      expect(processes.first, containsPair('name', isA<String>()));
      expect(result['total_matching'], DataManager().allProcesses.length);
    });

    test('list_processes filters by name and caps results', () {
      final all = executeListProcesses();
      final total = all['total_matching'] as int;

      final capped = executeListProcesses(limit: 1);
      expect((capped['processes'] as List).length, 1);
      expect(capped['returned'], 1);
      expect(capped['total_matching'], total);
      if (total > 1) {
        expect(capped['note'], contains('Showing 1 of $total'));
      }

      final name = ((all['processes'] as List).first as Map)['name'] as String;
      final filtered = executeListProcesses(nameFilter: name.toUpperCase());
      final filteredNames = (filtered['processes'] as List).map(
        (p) => (p as Map)['name'],
      );
      expect(filteredNames, contains(name));

      final none = executeListProcesses(nameFilter: 'no-such-process-xyz');
      expect(none['total_matching'], 0);
      expect(none['processes'], isEmpty);
    });

    test('get_dataset_overview summarizes the dataset', () {
      final overview = executeGetDatasetOverview();
      expect(overview['process_count'], greaterThan(0));
      expect(overview['stat_type_names'], isNotEmpty);
      expect(overview['time_range'], isA<Map>());
    });

    test('find_top_statistics ranks statistics for a process', () {
      final dm = DataManager();
      final p = dm.allProcesses.first;
      final result = executeFindTopStatistics(
        processName: p.name,
        statTypeId: p.type.id,
        processId: p.processId,
        sessionId: p.sessionId,
      );
      expect(result['top_statistics'], isA<List>());
    });
  });

  group('analysis guides', () {
    test('list_analysis_guides includes the MFC cycle guide', () {
      final result = executeListAnalysisGuides();
      final guides = result['guides'] as List;
      expect(guides, isNotEmpty);
      final names = guides.map((g) => (g as Map)['name']);
      expect(names, contains('mfc_cycle'));
    });

    test('get_analysis_guide returns the full runbook', () {
      final result = executeGetAnalysisGuide('mfc_cycle');
      expect(result['title'], contains('MFC'));
      final content = result['content'] as String;
      expect(content, contains('PrimitiveNumber'));
      expect(content, contains('ProgressCount'));
      expect(content, contains('find_stat_events'));
    });

    test('unknown guide name lists what is available', () {
      final result = executeGetAnalysisGuide('no_such_guide');
      expect(result['error'], contains('mfc_cycle'));
    });
  });

  group('time primitives', () {
    // Synthetic process with a known shape so event detection and
    // at-time sampling can be asserted exactly:
    //   TestStat: 0 0 3 5 0 0 2 0   (one sample per second)
    final t0 = DateTime.utc(2026, 1, 1, 12);
    DateTime at(int s) => t0.add(Duration(seconds: s));
    const values = [0, 0, 3, 5, 0, 0, 2, 0];
    final stat = Statistic(
      name: 'TestStat',
      type: 'int64',
      level: 'common',
      units: 'objects',
      isOs: false,
      description: 'synthetic',
    );
    final type = StatType(id: 999, name: 'TestType', statistics: [stat]);

    setUpAll(() {
      final ts = TimeSeries(statistic: stat);
      for (var i = 0; i < values.length; i++) {
        ts.add(at(i).millisecondsSinceEpoch, values[i].toDouble());
      }
      final proc = Process(
        name: 'synthetic-proc',
        type: type,
        startTime: t0,
        endTime: at(values.length - 1),
        samples: values.length,
        processId: 42,
        sessionId: null,
      )..statisticData['TestStat'] = ts;
      DataManager().processes['synthetic-proc'] = [proc];
    });

    tearDownAll(() => DataManager().processes.remove('synthetic-proc'));

    test('get_statistic_values respects the time window', () {
      final result = executeGetStatisticValues(
        processName: 'synthetic-proc',
        statTypeId: 999,
        statName: 'TestStat',
        processId: 42,
        startTime: at(2),
        endTime: at(5),
      );
      expect(result['point_count'], 4);
      final points = (result['points'] as List).cast<Map>();
      expect(points.first['v'], 3);
      expect(points.last['v'], 0);
    });

    test('get_statistic_summary over a window uses only windowed samples', () {
      final result = executeGetStatisticSummary(
        processName: 'synthetic-proc',
        statTypeId: 999,
        statName: 'TestStat',
        processId: 42,
        startTime: at(2),
        endTime: at(3),
      );
      expect(result['point_count'], 2);
      expect(result['min'], 3);
      expect(result['max'], 5);
      expect(result['avg'], 4.0);
    });

    test('empty window reports no samples instead of whole series', () {
      final result = executeGetStatisticSummary(
        processName: 'synthetic-proc',
        statTypeId: 999,
        statName: 'TestStat',
        processId: 42,
        startTime: at(100),
      );
      expect(result['point_count'], 0);
      expect(result['note'], contains('No samples'));
    });

    test('find_stat_events detects non-zero activity intervals', () {
      final result = executeFindStatEvents(
        processName: 'synthetic-proc',
        statTypeId: 999,
        statName: 'TestStat',
        processId: 42,
      );
      expect(result['interval_count'], 2);
      final intervals = (result['intervals'] as List).cast<Map>();
      expect(intervals[0]['start'], FileTime.format(at(2)));
      expect(intervals[0]['end'], FileTime.format(at(3)));
      expect(intervals[0]['duration_seconds'], 1.0);
      expect(intervals[0]['max_value'], 5);
      expect(intervals[0]['max_value_time'], FileTime.format(at(3)));
      expect(intervals[1]['start'], FileTime.format(at(6)));
      expect(intervals[1]['max_value'], 2);
      expect(intervals[1].containsKey('truncated'), isFalse);
    });

    test('find_stat_events change mode tracks value movement', () {
      final result = executeFindStatEvents(
        processName: 'synthetic-proc',
        statTypeId: 999,
        statName: 'TestStat',
        processId: 42,
        mode: 'change',
      );
      expect(result['interval_count'], 2);
      final intervals = (result['intervals'] as List).cast<Map>();
      // Changes at samples 2,3,4 (0→3→5→0) then 6,7 (0→2→0).
      expect(intervals[0]['start'], FileTime.format(at(2)));
      expect(intervals[0]['end'], FileTime.format(at(4)));
      expect(intervals[0]['value_before'], 0);
      expect(intervals[0]['value_after'], 0);
      expect(intervals[1]['start'], FileTime.format(at(6)));
      expect(intervals[1]['end'], FileTime.format(at(7)));
    });

    test('find_stat_events respects threshold and window', () {
      final result = executeFindStatEvents(
        processName: 'synthetic-proc',
        statTypeId: 999,
        statName: 'TestStat',
        processId: 42,
        threshold: 2,
        endTime: at(5),
      );
      expect(result['interval_count'], 1);
      final intervals = (result['intervals'] as List).cast<Map>();
      expect(intervals[0]['start'], FileTime.format(at(2)));
      expect(intervals[0]['end'], FileTime.format(at(3)));
    });

    test('get_values_at_time samples at-or-before with the next sample', () {
      final result = executeGetValuesAtTime(
        processName: 'synthetic-proc',
        statTypeId: 999,
        statNames: ['TestStat', 'NoSuchStat'],
        time: at(3).add(const Duration(milliseconds: 500)),
        processId: 42,
      );
      final values = (result['values'] as List).cast<Map>();
      expect(values[0]['value'], 5);
      expect(values[0]['sample_time'], FileTime.format(at(3)));
      expect((values[0]['next_sample'] as Map)['value'], 0);
      expect(values[1]['error'], contains('not found'));
    });

    test('get_values_at_time before the first sample is an error', () {
      final result = executeGetValuesAtTime(
        processName: 'synthetic-proc',
        statTypeId: 999,
        statNames: ['TestStat'],
        time: t0.subtract(const Duration(seconds: 1)),
        processId: 42,
      );
      final values = (result['values'] as List).cast<Map>();
      expect(values[0]['error'], contains('before the first sample'));
    });
  });

  group('in-process MCP server', () {
    test('exposes the analytics tools and answers a tool call', () async {
      await DataManager().loadStatistics();
      await DataManager().loadFromFile(_fixture);

      final server = await VsdMcpServer.create();
      addTearDown(server.dispose);

      final tools = await server.listTools();
      final names = tools.tools.map((t) => t.name).toSet();
      // In-process server exposes the 11 analytics/guide tools, no load_file.
      expect(names, contains(VsdTools.listProcesses));
      expect(names, contains(VsdTools.getDatasetOverview));
      expect(names, contains(VsdTools.findStatEvents));
      expect(names, contains(VsdTools.getValuesAtTime));
      expect(names, contains(VsdTools.listAnalysisGuides));
      expect(names, contains(VsdTools.getAnalysisGuide));
      expect(names.contains(VsdTools.loadFile), isFalse);
      expect(names.length, 11);

      final result = await server.callTool(VsdTools.getDatasetOverview, {});
      final json = extractToolResultText(result);
      expect(json, contains('process_count'));
    });

    test('exposes each analysis guide as a prompt', () async {
      final server = await VsdMcpServer.create();
      addTearDown(server.dispose);

      final prompts = await server.listPrompts();
      final names = prompts.prompts.map((p) => p.name).toSet();
      for (final guide in analysisGuides) {
        expect(names, contains(guide.name));
      }
    });

    test('rejects an unparseable time argument', () async {
      await DataManager().loadStatistics();
      await DataManager().loadFromFile(_fixture);

      final server = await VsdMcpServer.create();
      addTearDown(server.dispose);

      final p = DataManager().allProcesses.first;
      final result = await server.callTool(VsdTools.getStatisticValues, {
        'process_name': p.name,
        'stat_type_id': p.type.id,
        'stat_name': p.type.statistics.first.name,
        'start_time': 'yesterday-ish',
      });
      expect(
        extractToolResultText(result),
        contains('Could not parse start_time'),
      );
    });
  });
}
