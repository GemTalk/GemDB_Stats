import 'package:test/test.dart';
import 'package:vsd_core/vsd_core.dart';
import 'package:vsd_mcp/vsd_mcp.dart';
import 'package:vsd_mcp/src/mcp/tools/analytics_tools.dart';
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

  group('in-process MCP server', () {
    test('exposes the analytics tools and answers a tool call', () async {
      await DataManager().loadStatistics();
      await DataManager().loadFromFile(_fixture);

      final server = await VsdMcpServer.create();
      addTearDown(server.dispose);

      final tools = await server.listTools();
      final names = tools.tools.map((t) => t.name).toSet();
      // In-process server exposes the 7 analytics tools, no load_file.
      expect(names, contains(VsdTools.listProcesses));
      expect(names, contains(VsdTools.getDatasetOverview));
      expect(names.contains(VsdTools.loadFile), isFalse);
      expect(names.length, 7);

      final result = await server.callTool(VsdTools.getDatasetOverview, {});
      final json = extractToolResultText(result);
      expect(json, contains('process_count'));
    });
  });
}
