// Standalone VSD MCP server.
//
// Speaks the Model Context Protocol over stdio, exposing tools that read and
// analyze GemStone statmon files. Point an MCP client (Claude Desktop, Claude
// Code, the MCP Inspector, ...) at this executable.
//
// Usage:
//   dart run vsd_mcp [path/to/file.statmon]
//
// An optional file path is loaded at startup. The client can also load or
// switch files at runtime with the `load_file` tool.
//
// NOTE: stdout is the JSON-RPC channel — never `print()` to it. All diagnostics
// go to stderr.
import 'dart:io';

import 'package:mcp_dart/mcp_dart.dart';
import 'package:vsd_core/vsd_core.dart';
import 'package:vsd_mcp/vsd_mcp.dart';

Future<void> main(List<String> args) async {
  // Statistic definitions are embedded in the package; load them once up front
  // so parsed statmon files can resolve stat metadata.
  await DataManager().loadStatistics();

  // Optional initial file (CLI arg).
  if (args.isNotEmpty) {
    try {
      await DataManager().loadFromFile(args.first);
      stderr.writeln('Loaded ${args.first}.');
    } catch (e) {
      stderr.writeln('Failed to load ${args.first}: $e');
    }
  }

  final server = McpServer(
    Implementation(name: 'vsd-analytics', version: '1.0.0'),
    options: const McpServerOptions(
      capabilities: ServerCapabilities(tools: ServerCapabilitiesTools()),
    ),
  );
  registerVsdTools(server, includeFileTools: true);

  await server.connect(StdioServerTransport());
  stderr.writeln('vsd_mcp server ready on stdio.');
}
