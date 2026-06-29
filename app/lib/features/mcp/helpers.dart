import 'dart:convert';
import 'package:mcp_dart/mcp_dart.dart' as mcp;

/// Encodes a [mcp.CallToolResult] to a JSON string for use as a tool result.
String extractToolResultText(mcp.CallToolResult result) {
  if (result.structuredContent != null) {
    return jsonEncode(result.structuredContent);
  }
  return result.content.whereType<mcp.TextContent>().firstOrNull?.text ?? '{}';
}
