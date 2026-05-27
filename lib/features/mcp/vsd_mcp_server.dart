import 'dart:async';

import 'package:mcp_dart/mcp_dart.dart';
import 'package:vsd/features/mcp/tool_list.dart';
import 'package:vsd/features/mcp/tools/analytics_tools.dart';
import 'package:vsd/features/mcp/tools/process_tools.dart';

/// Hosts an in-process MCP server exposing VSD analytics tools.
///
/// The server and client communicate over a pair of [StreamController]s.
///
/// Use [VsdMcpServer.create] to obtain a ready-to-use instance.
/// Call [dispose] when the owning widget is destroyed.
class VsdMcpServer {
  VsdMcpServer._({
    required McpServer server,
    required McpClient client,
    required StreamController<List<int>> toServer,
    required StreamController<List<int>> toClient,
  })  : _server = server,
        _client = client,
        _toServer = toServer,
        _toClient = toClient;

  final McpServer _server;
  final McpClient _client;
  final StreamController<List<int>> _toServer;
  final StreamController<List<int>> _toClient;

  /// Creates and fully initializes a [VsdMcpServer].
  static Future<VsdMcpServer> create() async {
    final toServer = StreamController<List<int>>();
    final toClient = StreamController<List<int>>();

    final server = McpServer(
      Implementation(name: 'vsd-analytics', version: '1.0.0'),
      options: const McpServerOptions(
        capabilities: ServerCapabilities(tools: ServerCapabilitiesTools()),
      ),
    );
    _registerTools(server);

    final serverTransport = IOStreamTransport(
      stream: toServer.stream,
      sink: toClient.sink,
    );
    final clientTransport = IOStreamTransport(
      stream: toClient.stream,
      sink: toServer.sink,
    );

    // Connect server first (starts listening), then the client initiates the
    // MCP handshake. Both are async but run on the same Dart event loop, so
    // there is no deadlock risk.
    await server.connect(serverTransport);

    final client = McpClient(
      Implementation(name: 'vsd-client', version: '1.0.0'),
    );
    await client.connect(clientTransport);

    return VsdMcpServer._(
      server: server,
      client: client,
      toServer: toServer,
      toClient: toClient,
    );
  }

  Future<void> dispose() async {
    await _client.close();
    await _server.close();
    await _toServer.close();
    await _toClient.close();
  }

  /// Lists all tools available on the server.
  Future<ListToolsResult> listTools() => _client.listTools();

  /// Calls a tool by [name] with [args] and returns the raw [CallToolResult].
  Future<CallToolResult> callTool(
    String name,
    Map<String, dynamic> args,
  ) =>
      _client.callTool(CallToolRequest(name: name, arguments: args));

  static void _registerTools(McpServer s) {
    s.registerTool(
      VsdTools.listProcesses,
      description: 'List all loaded processes with their name, stat type, '
          'process ID, session ID, time range, and sample count.',
      inputSchema: JsonObject(),
      callback: (args, extra) async {
        return CallToolResult.fromStructuredContent(executeListProcesses());
      },
    );

    s.registerTool(
      VsdTools.getProcessDetails,
      description:
          'Get all statistics available for a specific process, including '
          'per-statistic min/max/avg and metadata.',
      inputSchema: JsonObject(
        properties: {
          'process_name': JsonString(
            description: 'The process name (from list_processes).',
          ),
          'stat_type_id': JsonInteger(
            description: 'The stat type ID (from list_processes).',
          ),
          'process_id': JsonInteger(
            description: 'Optional process ID (omit or null if not applicable).',
          ),
          'session_id': JsonInteger(
            description:
                'Optional session ID (omit or null if not applicable).',
          ),
        },
        required: ['process_name', 'stat_type_id'],
      ),
      callback: (args, extra) async {
        return CallToolResult.fromStructuredContent(
          executeGetProcessDetails(
            processName: args['process_name'] as String,
            statTypeId: args['stat_type_id'] as int,
            processId: args['process_id'] as int?,
            sessionId: args['session_id'] as int?,
          ),
        );
      },
    );

    s.registerTool(
      VsdTools.getDatasetOverview,
      description:
          'Get a high-level overview of all loaded data: process count, '
          'names, stat types, time range, and total sample count.',
      inputSchema: JsonObject(),
      callback: (args, extra) async {
        return CallToolResult.fromStructuredContent(executeGetDatasetOverview());
      },
    );

    s.registerTool(
      VsdTools.getStatisticValues,
      description:
          'Get time-series data for a specific statistic on a process. '
          'Returns timestamp/value pairs, downsampled if needed.',
      inputSchema: JsonObject(
        properties: {
          'process_name': JsonString(description: 'The process name.'),
          'stat_type_id': JsonInteger(description: 'The stat type ID.'),
          'stat_name': JsonString(
            description: 'The statistic name (from get_process_details).',
          ),
          'process_id': JsonInteger(description: 'Optional process ID.'),
          'session_id': JsonInteger(description: 'Optional session ID.'),
          'max_points': JsonInteger(
            description:
                'Maximum number of data points to return (default 200). '
                'Increase for anomaly detection.',
          ),
        },
        required: ['process_name', 'stat_type_id', 'stat_name'],
      ),
      callback: (args, extra) async {
        return CallToolResult.fromStructuredContent(
          executeGetStatisticValues(
            processName: args['process_name'] as String,
            statTypeId: args['stat_type_id'] as int,
            statName: args['stat_name'] as String,
            processId: args['process_id'] as int?,
            sessionId: args['session_id'] as int?,
            maxPoints: args['max_points'] as int? ?? 200,
          ),
        );
      },
    );

    s.registerTool(
      VsdTools.getStatisticSummary,
      description:
          'Get statistical summary (min, max, avg, stddev) for a specific '
          'statistic on a process.',
      inputSchema: JsonObject(
        properties: {
          'process_name': JsonString(description: 'The process name.'),
          'stat_type_id': JsonInteger(description: 'The stat type ID.'),
          'stat_name': JsonString(description: 'The statistic name.'),
          'process_id': JsonInteger(description: 'Optional process ID.'),
          'session_id': JsonInteger(description: 'Optional session ID.'),
        },
        required: ['process_name', 'stat_type_id', 'stat_name'],
      ),
      callback: (args, extra) async {
        return CallToolResult.fromStructuredContent(
          executeGetStatisticSummary(
            processName: args['process_name'] as String,
            statTypeId: args['stat_type_id'] as int,
            statName: args['stat_name'] as String,
            processId: args['process_id'] as int?,
            sessionId: args['session_id'] as int?,
          ),
        );
      },
    );

    s.registerTool(
      VsdTools.compareProcesses,
      description:
          'Compare two processes side-by-side on a list of statistics, '
          'showing min/max/avg/stddev for each.',
      inputSchema: JsonObject(
        properties: {
          'process1_name': JsonString(description: 'First process name.'),
          'process1_type_id': JsonInteger(
            description: 'First process stat type ID.',
          ),
          'process2_name': JsonString(description: 'Second process name.'),
          'process2_type_id': JsonInteger(
            description: 'Second process stat type ID.',
          ),
          'stat_names': JsonArray(
            items: JsonString(),
            description: 'List of statistic names to compare.',
          ),
          'process1_id': JsonInteger(
            description: 'Optional process ID for process 1.',
          ),
          'process1_session_id': JsonInteger(
            description: 'Optional session ID for process 1.',
          ),
          'process2_id': JsonInteger(
            description: 'Optional process ID for process 2.',
          ),
          'process2_session_id': JsonInteger(
            description: 'Optional session ID for process 2.',
          ),
        },
        required: [
          'process1_name',
          'process1_type_id',
          'process2_name',
          'process2_type_id',
          'stat_names',
        ],
      ),
      callback: (args, extra) async {
        final rawNames = args['stat_names'] as List<dynamic>;
        return CallToolResult.fromStructuredContent(
          executeCompareProcesses(
            process1Name: args['process1_name'] as String,
            process1TypeId: args['process1_type_id'] as int,
            process2Name: args['process2_name'] as String,
            process2TypeId: args['process2_type_id'] as int,
            statNames: rawNames.cast<String>(),
            process1Id: args['process1_id'] as int?,
            process1SessionId: args['process1_session_id'] as int?,
            process2Id: args['process2_id'] as int?,
            process2SessionId: args['process2_session_id'] as int?,
          ),
        );
      },
    );

    s.registerTool(
      VsdTools.findTopStatistics,
      description:
          'Find the top N statistics for a process ranked by max, avg, or min '
          'value. Useful for discovering which statistics are most significant.',
      inputSchema: JsonObject(
        properties: {
          'process_name': JsonString(description: 'The process name.'),
          'stat_type_id': JsonInteger(description: 'The stat type ID.'),
          'metric': JsonString(
            description:
                'Sort metric: "max" (default "avg"). Use "min" to find '
                'lowest values.',
          ),
          'limit': JsonInteger(
            description: 'Number of results to return (default 10).',
          ),
          'process_id': JsonInteger(description: 'Optional process ID.'),
          'session_id': JsonInteger(description: 'Optional session ID.'),
        },
        required: ['process_name', 'stat_type_id'],
      ),
      callback: (args, extra) async {
        return CallToolResult.fromStructuredContent(
          executeFindTopStatistics(
            processName: args['process_name'] as String,
            statTypeId: args['stat_type_id'] as int,
            processId: args['process_id'] as int?,
            sessionId: args['session_id'] as int?,
            metric: args['metric'] as String? ?? 'avg',
            limit: args['limit'] as int? ?? 10,
          ),
        );
      },
    );
  }
}
