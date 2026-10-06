# Contributing to GemDB Stats

Thanks for helping. This page covers setting up, making a change, and getting
it merged. Releases are covered in [docs/releasing.md](docs/releasing.md).

## Setup

You need [Flutter](https://docs.flutter.dev/get-started/install) on the stable
channel. It includes the Dart SDK, which must be 3.10.8 or later. Building the
desktop app also needs that platform's toolchain:

- **macOS:** Xcode.
- **Windows:** Visual Studio with the "Desktop development with C++" workload.
- **Linux:** `clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev`.

`flutter doctor` reports anything missing.

```sh
git clone https://github.com/GemTalk/GemDB_Stats.git
cd GemDB_Stats/app
flutter pub get
flutter run -d macos     # or windows, linux, chrome
```

## Layout

The repository holds three Dart packages. Each depends on the ones before it.

| Folder | Package | What it is |
| --- | --- | --- |
| [core/](core/) | `vsd_core` | Parses statmon files and holds the data. Runs on the VM and in a browser, so it can't use `dart:io`, isolates or `Int64List` directly. |
| [mcp/](mcp/) | `vsd_mcp` | The MCP server and its analysis tools and guides, used standalone and by the app's AI assistant. See [mcp/README.md](mcp/README.md). |
| [app/](app/) | `vsd` | The Flutter app for macOS, Windows, Linux and the web. |

The packages are still named after VSD, the app's earlier name.

Other folders:

- [docs/](docs/): longer guides, such as [embedding](docs/embedding.md) and
  [releasing](docs/releasing.md).
- [.github/workflows/](.github/workflows/): CI. `checks` runs on every PR,
  `build` builds the apps, `release` publishes a release, and `pages` deploys
  the web build from `main`.

### Statistic definitions

`vsd_core` includes GemStone's statistic definitions as generated code. To
update them, replace `core/tool/vsd.stats.tcl` and, from `core/`, run:

```sh
dart run tool/gen_stat_definitions.dart
```

## Before you open a PR

CI runs these checks on every pull request, for each package. Run them locally
first. In `core/` and `mcp/`, use `dart`. In `app/`, use `flutter` for
`pub get` and `test`:

```sh
dart pub get
dart format .
dart analyze
dart test
```

CI also runs the web code in Chrome. If you change file loading or anything in
`core/`, run these as well:

```sh
(cd core && dart test -p chrome && dart test -p chrome -c dart2wasm)
(cd app && flutter test --platform chrome test/file_open_test.dart test/embed_test.dart)
(cd app && flutter build web --no-web-resources-cdn)
```

Add tests for what you change. A bug fix should come with a test that fails
without the fix.

## Pull requests

- Branch from `main` and open a PR against `main`. Keep each PR to one change.
- Start the title with a type, such as `feat:`, `fix:`, `docs:`, `ci:`,
  `test:`, `refactor:` or `chore:`, or write a plain sentence that says what
  the change does. PRs are squash-merged, so the title becomes the commit
  message on `main`.
- In the description, say what was wrong or missing, what changed, and how you
  tested it. For changes to the UI, add a screenshot.
- Greptile reviews each PR automatically. Answer or resolve its findings
  before merging.
- If your change touches a file that another open PR also changes, check
  `main` after both merge. Each PR passes CI against the `main` it started
  from, not the `main` it lands on.

## Changelog

If users would notice your change, add an entry to [CHANGELOG.md](CHANGELOG.md)
under `## [Unreleased]` in the same PR. Use the heading that fits:

- **Added:** new features.
- **Changed:** changes to existing behavior, including performance.
- **Deprecated:** features that will be removed.
- **Removed:** features that are gone.
- **Fixed:** bug fixes.
- **Security:** fixes for vulnerabilities.

Write the entry for someone who uses the app, not someone who reads the code.
Say what they'll notice, and end with a link to the PR:

```markdown
### Fixed

- Adding a statistic to a MultiChart keeps the zoomed range.
  ([#13](https://github.com/GemTalk/GemDB_Stats/pull/13))
```

CI, tests, refactoring and docs for contributors don't need an entry. You don't
choose the version number: the release workflow moves the Unreleased entries
under the new version when it publishes a release.
