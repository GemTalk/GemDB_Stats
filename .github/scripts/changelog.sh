#!/usr/bin/env bash
set -euo pipefail

# Keeps CHANGELOG.md in step with releases. Each PR adds its entries under
# "## [Unreleased]"; release.yml files them under the new version and uses them
# as the release notes.
#
#   changelog.sh release VERSION DATE   move the Unreleased entries under VERSION
#   changelog.sh notes SECTION          print a section's entries (VERSION or
#                                       Unreleased), without its heading
#
# CHANGELOG names another file, for testing.

FILE="${CHANGELOG:-CHANGELOG.md}"

# Prints the body of the section headed "## [$1]", trimmed of blank lines.
section() {
  awk -v want="## [$1]" '
    index($0, "## [") == 1 {
      if (on) exit
      on = (index($0, want) == 1)
      next
    }
    on && /^\[[^]]+\]: / { exit } # link definitions at the end of the file
    on { lines[++n] = $0 }
    END {
      s = 1; while (s <= n && lines[s] ~ /^[ \t]*$/) s++
      e = n; while (e >= s && lines[e] ~ /^[ \t]*$/) e--
      for (i = s; i <= e; i++) print lines[i]
    }
  ' "$FILE"
}

release() {
  local version="$1" date="$2"

  if [[ -z "$(section Unreleased)" ]]; then
    echo "::error::$FILE has no entries under [Unreleased]" >&2
    exit 1
  fi
  if grep -qF "## [$version]" "$FILE"; then
    echo "::error::$FILE already has a [$version] section" >&2
    exit 1
  fi
  if ! grep -qE '^\[Unreleased\]: .*/compare/[^/]+\.\.\.HEAD$' "$FILE"; then
    echo "::error::$FILE needs a link like [Unreleased]: <repo>/compare/v1.0.0...HEAD" >&2
    exit 1
  fi

  # Starts the version's section under an empty Unreleased one, and points the
  # links at the new tag.
  awk -v v="$version" -v d="$date" '
    $0 == "## [Unreleased]" {
      print; print ""; print "## [" v "] - " d
      next
    }
    /^\[Unreleased\]: / {
      base = $2; sub(/\/compare\/.*/, "", base)
      prev = $2; sub(/.*\/compare\//, "", prev); sub(/\.\.\.HEAD$/, "", prev)
      print "[Unreleased]: " base "/compare/v" v "...HEAD"
      print "[" v "]: " base "/compare/" prev "...v" v
      next
    }
    { print }
  ' "$FILE" > "$FILE.tmp"
  mv "$FILE.tmp" "$FILE"
}

case "${1:-}" in
  release) release "$2" "$3" ;;
  notes) section "$2" ;;
  *)
    echo "usage: $0 release VERSION DATE | notes SECTION" >&2
    exit 2
    ;;
esac
