# vsd_mcp

A pure-Dart [Model Context Protocol](https://modelcontextprotocol.io) server for
reading and analyzing GemStone **statmon** files. Part of
[GemDB Stats](../README.md).

This package has two consumers:

- **The standalone MCP server** (`bin/vsd_mcp.dart`) — speaks MCP over **stdio** so
  an MCP client (Claude Desktop, Claude Code, the MCP Inspector, …) can analyze a
  statmon file.
- **The VSD app** (`../app`) — depends on this package via a path dependency and
  builds an *in-process* server (`VsdMcpServer`) over the data it already has
  loaded in memory (which it gets from `vsd_core`).

## Running the standalone server

```sh
dart pub get
dart run vsd_mcp [path/to/statmon.out]
```

An optional file path (`.out` or `.out.gz`) is loaded at startup. Clients can
also load or switch files at runtime with the `load_file` tool.

`dart run` also works from any directory when given the entrypoint path, which
is the form MCP client configs need:

```sh
dart run /absolute/path/to/GemDB_Stats/mcp/bin/vsd_mcp.dart
```

### Claude Desktop

Add to `claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "vsd": {
      "command": "dart",
      "args": [
        "run",
        "/absolute/path/to/GemDB_Stats/mcp/bin/vsd_mcp.dart",
        "/absolute/path/to/statmon.out"
      ]
    }
  }
}
```

### Claude Code

```sh
claude mcp add vsd -- dart run /absolute/path/to/GemDB_Stats/mcp/bin/vsd_mcp.dart
```

### Compiled binary

To avoid a Dart SDK on the client machine, compile once and point the client at
the executable instead:

```sh
dart compile exe bin/vsd_mcp.dart -o vsd_mcp
```

## Tools

| Tool | Purpose |
| --- | --- |
| `get_dataset_overview` | Process count, names, stat types, time range and zone, total sample count |
| `list_processes` | Loaded processes with name, stat type, process/session ID, time range, sample count; `name_filter` and `limit` |
| `get_process_details` | All statistics for a process with per-stat min/max/avg and metadata |
| `get_statistic_values` | Time-series data for a statistic, downsampled to `max_points`; optional `start_time`/`end_time` window |
| `get_statistic_summary` | min / max / avg / stddev for a statistic, optionally windowed |
| `find_stat_events` | Activity intervals (start/end/duration/peak) at full resolution; `nonzero` or `change` mode |
| `get_values_at_time` | Sample several statistics of a process at one moment ("what was X when Y happened") |
| `compare_processes` | Two processes side by side across named statistics |
| `find_top_statistics` | Rank a process's statistics by max / avg / min |
| `list_analysis_guides` | List the built-in analysis runbooks |
| `get_analysis_guide` | Full text of one guide, e.g. `mfc_cycle` |
| `load_file` | Load or switch the statmon file (standalone server only) |

Time arguments are ISO-8601. Include a UTC offset or `Z` to name an exact
instant; without one, the time is read in the zone the dataset's timestamps are
displayed in (see `get_dataset_overview`).

## Analysis guides

Guides are expert, step-by-step runbooks for common GemStone performance
questions, written in markdown and executed by the model with the generic query
tools above. They live in
[`lib/src/mcp/guides/analysis_guides.dart`](lib/src/mcp/guides/analysis_guides.dart);
adding a runbook means adding an `AnalysisGuide` entry there — no new tool code.

| Guide | Covers |
| --- | --- |
| `mfc_cycle` | Reconstructing a Mark For Collection (garbage-collection) cycle: which process ran it, objects scanned, possible and confirmed dead objects, gem voting, object and page reclaim timing |

## Development

```sh
dart format --set-exit-if-changed .
dart analyze
dart test
```

## Notes

- **stdout is the JSON-RPC channel** — code on the server path must never `print()`
  to stdout. Diagnostics go to stderr.
- The in-app server deliberately omits `load_file`: the app owns the loaded file
  through its UI.
- The GemStone statistic definitions (`vsd.stats.tcl`) are embedded as a base64
  constant in `vsd_core` (`../core/lib/src/stat_definitions.g.dart`) so no asset
  bundle is needed. To regenerate, edit `../core/tool/vsd.stats.tcl` and run
  `dart run tool/gen_stat_definitions.dart` from the `core` package.
