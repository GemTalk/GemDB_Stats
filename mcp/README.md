# vsd_mcp

A pure-Dart [Model Context Protocol](https://modelcontextprotocol.io) server for
reading and analyzing GemStone **statmon** files.

This package has two consumers:

- **The standalone MCP server** (`bin/vsd_mcp.dart`) — speaks MCP over **stdio** so
  an MCP client (Claude Desktop, Claude Code, the MCP Inspector, …) can analyze a
  statmon file.
- **The Flutter app** (`../app`) — depends on this package via a path dependency
  and builds an *in-process* server (`VsdMcpServer`) over the data it already has
  loaded in memory (which it gets from `vsd_core`).

## Running the standalone server

```sh
dart pub get
dart run vsd_mcp [path/to/file.statmon]
```

An optional file path is loaded at startup. Clients can also load or switch files
at runtime with the `load_file` tool.

### Example MCP client config

```json
{
  "mcpServers": {
    "vsd": {
      "command": "dart",
      "args": ["run", "vsd_mcp", "/absolute/path/to/file.statmon"]
    }
  }
}
```

## Tools

| Tool | Purpose |
| --- | --- |
| `list_processes` | List loaded processes with metadata |
| `get_process_details` | All statistics for a process (per-stat min/max/avg) |
| `get_dataset_overview` | Process count, stat types, time range, sample count |
| `get_statistic_values` | Time-series data for a statistic (downsampled) |
| `get_statistic_summary` | min / max / avg / stddev for a statistic |
| `compare_processes` | Compare two processes across named statistics |
| `find_top_statistics` | Rank a process's statistics by max/avg/min |
| `load_file` | Load/switch the statmon file (standalone server only) |

## Notes

- **stdout is the JSON-RPC channel** — code on the server path must never `print()`
  to stdout. Diagnostics go to stderr.
- The GemStone statistic definitions (`vsd.stats.tcl`) are embedded as a base64
  constant in `vsd_core` (`../core/lib/src/stat_definitions.g.dart`) so no asset
  bundle is needed. To regenerate, edit `../core/tool/vsd.stats.tcl` and run
  `dart run tool/gen_stat_definitions.dart` from the `core` package.
