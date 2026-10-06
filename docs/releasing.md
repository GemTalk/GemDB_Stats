# Releasing GemDB Stats

A release is one run of the **release** workflow. It sets the version, updates
the changelog, tags `main`, builds every platform, and publishes the files on
the [Releases page](https://github.com/GemTalk/GemDB_Stats/releases). You need
write access to the repository.

## Choose the version

Versions follow [Semantic Versioning](https://semver.org/), `MAJOR.MINOR.PATCH`,
judged by what a user of the app or the MCP server notices:

- **Patch** (1.1.0 → 1.1.1): fixes only.
- **Minor** (1.1.0 → 1.2.0): new features. Existing files, settings and MCP
  tools keep working.
- **Major** (1.1.0 → 2.0.0): something that used to work no longer does, such
  as dropping a platform, renaming or removing an MCP tool, or changing the
  `postMessage` protocol in [embedding.md](embedding.md).

The Unreleased section of [CHANGELOG.md](../CHANGELOG.md) usually decides it:
anything under **Added** means at least a minor version.

## Before you start

1. Make sure the last `checks` run on `main` passed.
2. Read the `## [Unreleased]` section of CHANGELOG.md. It becomes the release
   notes as written. If it's empty, the workflow stops. If it's missing
   something or reads badly, fix it in a PR and merge that first. To find
   what's changed, compare `main` with the last tag:
   `https://github.com/GemTalk/GemDB_Stats/compare/v1.0.0...main`.

## Run the release

1. Open **Actions → release → Run workflow**.
2. Leave **Use workflow from** on `main`. The workflow refuses any other branch.
3. Enter the version, such as `1.1.0`, without the `v`.
4. Leave all four platforms ticked unless one can't be built. A release
   without the web build breaks GemDB Code's next update.
5. Click **Run workflow**. v1.0.0 took about 7 minutes. Notarization can make
   the macOS build take longer.

The workflow:

1. Checks the version and that its tag doesn't already exist.
2. Moves the Unreleased entries in CHANGELOG.md under `## [1.1.0] - <today>`,
   and updates the links at the bottom.
3. Sets `version:` in `app/pubspec.yaml`.
4. Commits both files to `main` as `chore: release v1.1.0`, then tags that
   commit `v1.1.0` and pushes the tag.
5. Builds the ticked platforms from the tag, using `build.yml`. The macOS app
   is signed and notarized.
6. Publishes the release with these files:

   | File | Contents |
   | --- | --- |
   | `GemDB-Stats-<version>-macos.zip` | The signed, notarized app |
   | `GemDB-Stats-<version>-windows-x64.zip` | `GemDBStats.exe`, its DLLs and `data/` |
   | `GemDB-Stats-<version>-linux-x64.tar.gz` | The Linux bundle |
   | `GemDB-Stats-<version>-web.tar.gz` | The web build, for embedding |
   | `SHA256SUMS.txt` | Checksums of the files above |

   The release notes are the version's changelog section, followed by GitHub's
   list of the PRs merged since the last release.

## After the release

- Pull `main`, because the workflow added a commit to it.
- Download the macOS build and open it. It should launch without a Gatekeeper
  warning. If you can, also check the Windows and Linux builds.
- Tell the GemDB Code maintainers, so they can move to the new web build.

The web version on GitHub Pages isn't part of a release. The `pages` workflow
deploys it every time `app/`, `core/` or `mcp/` changes on `main`.

## Pre-releases

A version with a suffix, such as `1.2.0-beta.1`, is published as a
pre-release. It doesn't change CHANGELOG.md, and its notes show the current
Unreleased entries. When the final version is released, those entries move
under it as usual.

## When something goes wrong

- **The version job fails** (bad version, tag exists, empty changelog):
  nothing was pushed. Fix the cause and run the workflow again.
- **A build or publish job fails** for a temporary reason, such as a runner
  problem or an Apple notary outage: open the run and click **Re-run failed
  jobs**. It rebuilds from the same tag.
- **The code needs fixing first:** undo the release so the version can be used
  again.
  1. Delete the release, if it was created, and the tag:
     `git push origin --delete v1.1.0`.
  2. Revert the `chore: release v1.1.0` commit on `main`. That puts the
     changelog entries back under Unreleased.
  3. Merge the fix, then run the workflow again.

  If the release was already downloaded, don't reuse its number. Release the
  next patch version instead.

## Secrets

The macOS build reads these repository secrets (Settings → Secrets and
variables → Actions). If a set is incomplete, the build stops before it starts
compiling.

| Secret | Contents |
| --- | --- |
| `MACOS_CERTIFICATE` | base64 of the Developer ID Application `.p12` |
| `MACOS_CERTIFICATE_PASSWORD` | Password the `.p12` was exported with |
| `NOTARY_KEY`, `NOTARY_KEY_ID`, `NOTARY_ISSUER_ID` | An App Store Connect API key (preferred) |
| `NOTARY_APPLE_ID`, `NOTARY_PASSWORD`, `NOTARY_TEAM_ID` | Or an Apple ID with an app-specific password |

The Developer ID certificate expires every five years. When it's renewed,
update the first two secrets.

## Building a release by hand

The workflow is the supported way to release. To build without it:

- Run `.github/scripts/build_linux.sh`, `build_windows.ps1` or
  `build_macos.sh` from the repository root. They are the same scripts CI
  runs, and the macOS one needs the secrets above as environment variables.
- Or run `app/tool/release_macos.sh`, which builds a signed, notarized `.dmg`
  using a notarytool keychain profile.

Hand-built files aren't recorded in the changelog or tagged, so use them for
testing, not for a release.
