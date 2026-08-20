#!/usr/bin/env bash
#
# Build, sign, notarize and package the macOS app for distribution.
#
# Produces build/macos/dist/vsd-<version>.dmg — a signed, notarized and
# stapled disk image containing a signed, notarized and stapled vsd.app.
#
# Credentials (one of):
#   1. A notarytool keychain profile (preferred). Create it once with:
#        xcrun notarytool store-credentials vsd-notary \
#          --apple-id you@gemtalksystems.com \
#          --team-id 72G58AHU7P \
#          --password <app-specific-password>
#      Override the profile name with NOTARY_PROFILE.
#
#   2. Environment variables, for CI:
#        APPLE_ID, TEAM_ID, APPLE_APP_PASSWORD
#
# Usage: app/tool/release_macos.sh [--skip-notarize]

set -euo pipefail

TEAM_ID="${TEAM_ID:-72G58AHU7P}"
NOTARY_PROFILE="${NOTARY_PROFILE:-vsd-notary}"
SIGN_ID="${SIGN_ID:-Developer ID Application}"

APP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
BUILD_DIR="$APP_DIR/build/macos/Build/Products/Release"
DIST_DIR="$APP_DIR/build/macos/dist"
APP_BUNDLE="$BUILD_DIR/vsd.app"
ENTITLEMENTS="$APP_DIR/macos/Runner/Release.entitlements"

SKIP_NOTARIZE=0
[[ "${1:-}" == "--skip-notarize" ]] && SKIP_NOTARIZE=1

step() { printf '\n\033[1;34m==>\033[0m \033[1m%s\033[0m\n' "$1"; }
fail() { printf '\n\033[1;31mError:\033[0m %s\n' "$1" >&2; exit 1; }

# --- Preflight ---------------------------------------------------------------

step "Checking signing identity"
if ! security find-identity -v -p codesigning | grep -q "$SIGN_ID.*$TEAM_ID"; then
  fail "No '$SIGN_ID' certificate for team $TEAM_ID in the keychain.
       Download it from developer.apple.com and add it to the login keychain."
fi
security find-identity -v -p codesigning | grep "$SIGN_ID.*$TEAM_ID"

VERSION="$(grep '^version:' "$APP_DIR/pubspec.yaml" | sed 's/version: *//' | tr -d '[:space:]')"
VERSION="${VERSION%%+*}"
[[ -n "$VERSION" ]] || fail "Could not read version from pubspec.yaml"

# Resolve notarization credentials up front so we fail before a long build.
NOTARY_ARGS=()
if [[ $SKIP_NOTARIZE -eq 0 ]]; then
  if xcrun notarytool history --keychain-profile "$NOTARY_PROFILE" >/dev/null 2>&1; then
    NOTARY_ARGS=(--keychain-profile "$NOTARY_PROFILE")
  elif [[ -n "${APPLE_ID:-}" && -n "${APPLE_APP_PASSWORD:-}" ]]; then
    NOTARY_ARGS=(--apple-id "$APPLE_ID" --team-id "$TEAM_ID" --password "$APPLE_APP_PASSWORD")
  else
    fail "No notarization credentials. Either store a keychain profile named
       '$NOTARY_PROFILE' (see the header of this script) or set APPLE_ID and
       APPLE_APP_PASSWORD. Use --skip-notarize to build a signed-only app."
  fi
fi

# --- Build -------------------------------------------------------------------

step "Building vsd $VERSION (release)"
cd "$APP_DIR"
flutter build macos --release

[[ -d "$APP_BUNDLE" ]] || fail "Build did not produce $APP_BUNDLE"

# --- Sign --------------------------------------------------------------------

# Xcode signs the app and its embedded frameworks during the build, but plugin
# bundles and dylibs pulled in by Flutter occasionally slip through ad-hoc
# signed, which notarization rejects. Re-sign everything inside-out to be sure.
step "Signing nested code"
while IFS= read -r -d '' item; do
  codesign --force --timestamp --options runtime \
    --sign "$SIGN_ID" "$item"
done < <(find "$APP_BUNDLE/Contents" \
  \( -name '*.framework' -o -name '*.dylib' -o -name '*.bundle' \) \
  -not -path '*/Frameworks/*/Versions/*/Frameworks/*' -print0)

step "Signing app bundle"
codesign --force --timestamp --options runtime \
  --entitlements "$ENTITLEMENTS" \
  --sign "$SIGN_ID" "$APP_BUNDLE"

step "Verifying signature"
codesign --verify --deep --strict --verbose=2 "$APP_BUNDLE"
codesign -dvv "$APP_BUNDLE" 2>&1 | grep -E 'Authority|TeamIdentifier|flags'

# --- Notarize the app --------------------------------------------------------

mkdir -p "$DIST_DIR"
DMG="$DIST_DIR/vsd-$VERSION.dmg"
ZIP="$DIST_DIR/vsd-$VERSION.zip"

if [[ $SKIP_NOTARIZE -eq 0 ]]; then
  step "Notarizing app (this can take a few minutes)"
  rm -f "$ZIP"
  ditto -c -k --keepParent "$APP_BUNDLE" "$ZIP"
  xcrun notarytool submit "$ZIP" "${NOTARY_ARGS[@]}" --wait
  rm -f "$ZIP"

  step "Stapling app"
  xcrun stapler staple "$APP_BUNDLE"
fi

# --- Package -----------------------------------------------------------------

step "Building disk image"
STAGE="$(mktemp -d)"
trap 'rm -rf "$STAGE"' EXIT
cp -R "$APP_BUNDLE" "$STAGE/"
ln -s /Applications "$STAGE/Applications"

rm -f "$DMG"
hdiutil create \
  -volname "vsd $VERSION" \
  -srcfolder "$STAGE" \
  -fs HFS+ \
  -format UDZO \
  -ov \
  "$DMG" >/dev/null

step "Signing disk image"
codesign --force --timestamp --sign "$SIGN_ID" "$DMG"

if [[ $SKIP_NOTARIZE -eq 0 ]]; then
  step "Notarizing disk image"
  xcrun notarytool submit "$DMG" "${NOTARY_ARGS[@]}" --wait

  step "Stapling disk image"
  xcrun stapler staple "$DMG"

  step "Verifying Gatekeeper acceptance"
  spctl --assess --type open --context context:primary-signature -vv "$DMG"
fi

printf '\n\033[1;32m✓\033[0m %s\n' "$DMG"
if [[ $SKIP_NOTARIZE -eq 1 ]]; then
  printf '\033[1;33m!\033[0m Not notarized — this build will not open on other Macs.\n'
fi
