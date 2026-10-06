# Changelog

All notable changes to GemDB Stats are recorded here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and versions follow
[Semantic Versioning](https://semver.org/). Add your entries under
**Unreleased**; the release workflow moves them under the new version. See
[CONTRIBUTING.md](CONTRIBUTING.md#changelog).

## [Unreleased]

### Added

- A web version at [gemtalk.github.io/GemDB_Stats](https://gemtalk.github.io/GemDB_Stats/),
  with everything but the AI assistant. The file you open never leaves your
  machine. ([#8](https://github.com/GemTalk/GemDB_Stats/pull/8))
- A host page, such as a VS Code webview in GemDB Code, can choose the file to
  show. In a browser, `?file=<url>&name=<label>` opens a file at startup. See
  [docs/embedding.md](docs/embedding.md).
  ([#10](https://github.com/GemTalk/GemDB_Stats/pull/10))
- Each release includes the web build, `GemDB-Stats-<version>-web.tar.gz`, for
  embedding. ([#10](https://github.com/GemTalk/GemDB_Stats/pull/10))
- A menu button on Linux, Windows and the web, with the same commands as the
  macOS menu bar. ([#11](https://github.com/GemTalk/GemDB_Stats/pull/11))

### Changed

- Large files load about three times faster in a third of the memory. A
  216 MB `.out.gz` now loads in 12 s instead of 34 s, with a peak of 2.0 GB
  instead of 5.9 GB. ([#8](https://github.com/GemTalk/GemDB_Stats/pull/8))

### Fixed

- Some statistics were missing or showed another statistic's values. In files
  whose stat types have no `CacheSerialNum`, including `STATMON "2"` files and
  current files from some platforms, the first statistic of each type was
  dropped (for example `LocalPageCacheMisses` and `UserTime`). A statistic
  missing from GemDB Stats' definitions shifted the values of the ones after
  it. ([#10](https://github.com/GemTalk/GemDB_Stats/pull/10))
- A file whose last line was cut short, as when `statmonitor` is stopped, now
  loads instead of failing. So do older statmon files, back to 1997.
  ([#10](https://github.com/GemTalk/GemDB_Stats/pull/10))
- Adding a statistic to a MultiChart keeps the zoomed range.
  ([#13](https://github.com/GemTalk/GemDB_Stats/pull/13))
- A long file name is shortened with an ellipsis instead of running past the
  top bar or under the menu button.
  ([#14](https://github.com/GemTalk/GemDB_Stats/pull/14))

## [1.0.0] - 2026-09-28

First release, as a desktop app for macOS (signed and notarized), Windows and
Linux.

- Open `.out` and `.out.gz` statmon files.
- Browse processes and their statistics, with min, max and average.
- Chart any statistic, zoom into a time range, and overlay statistics from one
  or more processes on a MultiChart with left and right axes.
- Show times in the file's time zone, UTC, the system zone or any named zone.
- Ask an AI assistant about the loaded file, with your own Anthropic API key.
- Use the same analysis tools from any MCP client with the standalone MCP
  server.

[Unreleased]: https://github.com/GemTalk/GemDB_Stats/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/GemTalk/GemDB_Stats/releases/tag/v1.0.0
