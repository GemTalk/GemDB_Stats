/// Public API of the `vsd_mcp` package: the MCP server/tools that expose the
/// shared statmon data layer ([package:vsd_core]). Consumed by the Flutter app
/// (in-process server via [VsdMcpServer]) and by the standalone stdio server in
/// `bin/vsd_mcp.dart` (via [registerVsdTools]).
///
/// The data layer (DataManager, models) lives in `package:vsd_core` — import it
/// directly for those types.
library;

export 'src/mcp/helpers.dart';
export 'src/mcp/tool_list.dart';
export 'src/mcp/vsd_mcp_server.dart';
