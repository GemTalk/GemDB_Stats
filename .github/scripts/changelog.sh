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

# The name of the section a "## [name] ..." heading starts, or "" for another
# line. Every command finds sections with it, so they agree on what a heading
# is, trailing spaces and all.
NAME='
  function name(line) {
    if (index(line, "## [") != 1) return ""
    line = substr(line, 5)
    return substr(line, 1, index(line, "]") - 1)
  }
'

# Prints the body of section $1, trimmed of blank lines.
section() {
  awk -v want="$1" "$NAME"'
    index($0, "## ") == 1 {
      if (on) exit
      on = (name($0) == want)
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

has_section() {
  awk -v want="$1" "$NAME"'
    name($0) == want { found = 1; exit }
    END { exit !found }
  ' "$FILE"
}

# Whether section $1 has an entry: a line that's neither blank nor a
# "### Added" style heading.
has_entries() {
  section "$1" | grep -qvE '^([[:space:]]*|###.*)$'
}

release() {
  local version="$1" date="$2"

  if ! has_entries Unreleased; then
    echo "::error::$FILE has no entries under [Unreleased]" >&2
    exit 1
  fi
  if has_section "$version"; then
    echo "::error::$FILE already has a [$version] section" >&2
    exit 1
  fi
  if ! grep -qE '^\[Unreleased\]: .*/compare/[^/]+\.\.\.HEAD$' "$FILE"; then
    echo "::error::$FILE needs a link like [Unreleased]: <repo>/compare/v1.0.0...HEAD" >&2
    exit 1
  fi

  # Starts the version's section under an empty Unreleased one, and points the
  # links at the new tag.
  awk -v v="$version" -v d="$date" "$NAME"'
    name($0) == "Unreleased" {
      print "## [Unreleased]"; print ""; print "## [" v "] - " d
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

  # The release commit must carry the entries under the new version.
  if ! FILE="$FILE.tmp" has_entries "$version" || FILE="$FILE.tmp" has_entries Unreleased; then
    rm -f "$FILE.tmp"
    echo "::error::Could not move the [Unreleased] entries under [$version]" >&2
    exit 1
  fi
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
