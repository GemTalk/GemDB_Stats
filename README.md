<p align="center">
  <img src="app/logo/vsd.svg" alt="VSD logo" width="120">
</p>

# GemDB Stats

[![checks](https://github.com/GemTalk/GemDB_Stats/actions/workflows/checks.yml/badge.svg)](https://github.com/GemTalk/GemDB_Stats/actions/workflows/checks.yml)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Visualization and AI-assisted analysis for GemDB (GemStone/S) performance statistics.

GemDB Stats reads the **statmon** files produced by GemStone's `statmonitor`
utility and lets you explore them two ways:

- A **desktop app** for macOS, Windows and Linux: a modernized take on the
  Tcl/Tk [VSD 5.x](https://gemtalksystems.com/products/vsd/). Browse
  processes, plot any statistic, compare processes side by side, and ask an AI
  assistant questions about what you see.
- An **MCP server** that exposes the same analysis tools to any
  [Model Context Protocol](https://modelcontextprotocol.io) client, so Claude
  Desktop or Claude Code can work through a statmon file with you.

For a quick look, here's a [demo from ESUG 2026](https://www.youtube.com/watch?v=I86j6EtlmvQ)
on YouTube.

## Features

**Files**
- Open `.out` and `.out.gz` statmon files; large files are parsed off the UI
  thread with a progress indicator.

**Processes and statistics**
- Browse every process in the file with its start/end time and sample count;
  search by name.
- Drill into a process's statistics: description, units, min / max / avg.
  Search statistics and hide the ones with no data.

**Charts**
- Plot any statistic as a line chart with a trackball tooltip and crosshair for
  precise inspection.
- Drag to zoom into a time range; reset with one click.
- **MultiChart**: overlay statistics from one or several processes on a single
  chart, with a legend that lets you move a series between the left and right
  axes or remove it.

**Time**
- Display timestamps in the file's own time zone, UTC, your system zone, or any
  named zone; show or hide the year and zone label.

**AI assistant**
- Ask natural-language questions about the loaded data ("which process did the
  most page reads?", "walk me through the MFC cycle").
- Built-in analysis guides give the model expert runbooks for common GemStone
  performance questions.
- Requires your own Anthropic API key. See [Using the AI assistant](#using-the-ai-assistant).

## Getting started

### Download

Grab the latest build for your platform from the
[Releases page](https://github.com/GemTalk/GemDB_Stats/releases).

| Platform | Install |
| --- | --- |
| macOS 12+ | Open the `.dmg` and drag **vsd** to Applications. The app is signed and notarized. |
| Windows | Unzip and run `vsd.exe`. Keep the `data/` folder and DLLs next to it. |
| Linux | Extract the bundle and run `./vsd`. Needs a GTK 3 runtime (`libgtk-3-0`). |

### Open a statmon file

Click **No file selected** in the top bar and pick a `.out` or `.out.gz`
file.

Then select a process in the top-left table, pick one of its statistics in the
table next to it, and the chart appears below. Use **Start MultiChart** in the
statistics table to overlay several statistics (from the same process or
different ones).

### Where statmon files come from

Statmon files are written by GemStone's `statmonitor` utility, which samples the
shared page cache statistics of a running stone and its gems. See
[Monitoring GemStone](https://downloads.gemtalksystems.com/docs/GemStone64/3.7.x/GS64-SysAdminGuide-3.7/7-Monitoring.htm)
in the GemStone/S 64 Bit System Administration Guide for how to run it. Both
plain and gzip-compressed output are supported.

## Using the AI assistant

1. Click **Toggle Chat** in the top bar to open the assistant panel.
2. Enter your Anthropic API key (`sk-ant-...`). It is stored locally on this
   machine only and can be changed later with **Set API key**.
3. Ask a question. The assistant uses the in-app MCP tools to query the loaded
   file and streams its answer back.

You bring your own API key, so data from the loaded file goes directly to Anthropic under your account — how it's handled is between you and Anthropic.

## Using the MCP server standalone

The same analysis tools are available as a standalone MCP server that speaks
stdio. It needs the [Dart SDK](https://dart.dev/get-dart) (or Flutter, which
bundles it).

```sh
git clone https://github.com/GemTalk/GemDB_Stats.git
cd GemDB_Stats/mcp
dart pub get
```

Then point your client at `bin/vsd_mcp.dart`. For Claude Desktop, add to
`claude_desktop_config.json`:

```json
{
  "mcpServers": {
    "vsd": {
      "command": "dart",
      "args": ["run", "/absolute/path/to/GemDB_Stats/mcp/bin/vsd_mcp.dart"]
    }
  }
}
```

For Claude Code:

```sh
claude mcp add vsd -- dart run /absolute/path/to/GemDB_Stats/mcp/bin/vsd_mcp.dart
```

Optionally pass a statmon file path as a final argument to load it at startup;
otherwise ask the model to call `load_file`. The full tool list and details are
in [mcp/README.md](mcp/README.md).

## Development notes

The GemStone statistic definitions are embedded in `vsd_core` as generated
code. To update them, replace `core/tool/vsd.stats.tcl` and run
`dart run tool/gen_stat_definitions.dart` from `core/`.
