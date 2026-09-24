#!/usr/bin/env bash
set -euo pipefail

# Builds the macOS app and, when signing secrets are available, signs it with the
# Developer ID certificate and notarizes it so it launches without Gatekeeper
# warnings. Without those secrets it falls back to an ad-hoc signature.
#
# Signing:
#   MACOS_CERTIFICATE           base64 of the Developer ID Application .p12
#   MACOS_CERTIFICATE_PASSWORD  password the .p12 was exported with
#
# Notarization, either an App Store Connect API key (preferred):
#   NOTARY_KEY                  base64 of the AuthKey_XXXX.p8
#   NOTARY_KEY_ID               the key ID
#   NOTARY_ISSUER_ID            the issuer UUID
# or an Apple ID with an app-specific password:
#   NOTARY_APPLE_ID, NOTARY_PASSWORD, NOTARY_TEAM_ID

cd app

RELEASE_DIR=build/macos/Build/Products/Release
APP="$RELEASE_DIR/vsd.app"
ZIP="$RELEASE_DIR/vsd.app.zip"

WORK_DIR="$(mktemp -d)"
KEYCHAIN="$WORK_DIR/signing.keychain-db"
KEYCHAIN_ADDED=0

cleanup() {
  [[ $KEYCHAIN_ADDED -eq 1 ]] && security delete-keychain "$KEYCHAIN" || true
  rm -rf "$WORK_DIR"
}
trap cleanup EXIT

have_signing_secrets() {
  [[ -n "${MACOS_CERTIFICATE:-}" && -n "${MACOS_CERTIFICATE_PASSWORD:-}" ]]
}

have_notary_secrets() {
  [[ -n "${NOTARY_KEY:-}" && -n "${NOTARY_KEY_ID:-}" && -n "${NOTARY_ISSUER_ID:-}" ]] ||
    [[ -n "${NOTARY_APPLE_ID:-}" && -n "${NOTARY_PASSWORD:-}" && -n "${NOTARY_TEAM_ID:-}" ]]
}

import_certificate() {
  local password
  password="$(uuidgen)"

  security create-keychain -p "$password" "$KEYCHAIN"
  KEYCHAIN_ADDED=1
  # Unlock for the length of the job; the default 5 min auto-lock would strand a
  # slow build with a locked keychain.
  security set-keychain-settings -lut 21600 "$KEYCHAIN"
  security unlock-keychain -p "$password" "$KEYCHAIN"

  printf '%s' "$MACOS_CERTIFICATE" | base64 --decode > "$WORK_DIR/certificate.p12"
  security import "$WORK_DIR/certificate.p12" -k "$KEYCHAIN" \
    -P "$MACOS_CERTIFICATE_PASSWORD" -T /usr/bin/codesign -T /usr/bin/security
  # Lets codesign use the key without an interactive prompt there is nobody to answer.
  security set-key-partition-list -S apple-tool:,apple:,codesign: -s -k "$password" "$KEYCHAIN" > /dev/null

  # Prepend rather than replace, so the login keychain stays searchable.
  local existing
  existing="$(security list-keychains -d user | sed -e 's/^ *"//' -e 's/"$//')"
  # shellcheck disable=SC2086
  security list-keychains -d user -s "$KEYCHAIN" $existing
}

# Fail early, before a long build, if the .p12 is not a Developer ID certificate.
signing_identity() {
  local found
  found="$(security find-identity -p codesigning "$KEYCHAIN" |
    awk -F'"' '/"Developer ID Application/ { print $2; exit }')"
  if [[ -z "$found" ]]; then
    echo "No Developer ID Application certificate in MACOS_CERTIFICATE." >&2
    echo "Identities found:" >&2
    security find-identity -p codesigning "$KEYCHAIN" >&2
    return 1
  fi
  printf '%s' "$found"
}

notarize() {
  local -a auth
  if [[ -n "${NOTARY_KEY:-}" ]]; then
    printf '%s' "$NOTARY_KEY" | base64 --decode > "$WORK_DIR/notary_key.p8"
    auth=(--key "$WORK_DIR/notary_key.p8" --key-id "$NOTARY_KEY_ID" --issuer "$NOTARY_ISSUER_ID")
  else
    auth=(--apple-id "$NOTARY_APPLE_ID" --password "$NOTARY_PASSWORD" --team-id "$NOTARY_TEAM_ID")
  fi

  # Notarization takes a zip; the ticket is stapled to the .app afterwards.
  ditto -c -k --sequesterRsrc --keepParent "$APP" "$WORK_DIR/notarize.zip"

  local rc=0
  xcrun notarytool submit "$WORK_DIR/notarize.zip" "${auth[@]}" --wait \
    --output-format json > "$WORK_DIR/notarize.json" 2> "$WORK_DIR/notarize.err" || rc=$?

  # plutil reports parse errors on stdout, so keep its failures out of the values.
  local submission_id status
  status="$(plutil -extract status raw -o - "$WORK_DIR/notarize.json" 2> /dev/null)" || status=""
  submission_id="$(plutil -extract id raw -o - "$WORK_DIR/notarize.json" 2> /dev/null)" || submission_id=""

  if [[ "$status" != "Accepted" ]]; then
    echo "Notarization failed (status: ${status:-unknown}, notarytool exit: $rc)" >&2
    cat "$WORK_DIR/notarize.err" "$WORK_DIR/notarize.json" >&2
    [[ -n "$submission_id" ]] && xcrun notarytool log "$submission_id" "${auth[@]}" >&2 || true
    exit 1
  fi

  xcrun stapler staple "$APP"
  xcrun stapler validate "$APP"
  spctl --assess --type execute --verbose "$APP"
}

if [[ -n "${CI:-}" ]]; then
  git config --global --add safe.directory "${FLUTTER_HOME:-/sdks/flutter}"
fi

if have_signing_secrets; then
  import_certificate
  IDENTITY="$(signing_identity)" || exit 1
  echo "Signing with: $IDENTITY"
  # The keychain search list is per-session, so codesign needs to be pointed at it.
  export FLUTTER_XCODE_OTHER_CODE_SIGN_FLAGS="--keychain $KEYCHAIN"
  # Leave CODE_SIGN_IDENTITY to the Runner's Release config, as a local build
  # does. FLUTTER_XCODE_* settings apply to every target, and forcing a real
  # identity onto the Swift package resource bundles makes them demand a team.
else
  echo "WARNING: no signing secrets, building an ad-hoc signed app that Gatekeeper will block." >&2
  # The Release config asks for a Developer ID certificate that is not here.
  export FLUTTER_XCODE_CODE_SIGN_IDENTITY="-"
  export FLUTTER_XCODE_CODE_SIGN_STYLE="Manual"
  export FLUTTER_XCODE_DEVELOPMENT_TEAM=""
  export FLUTTER_XCODE_PROVISIONING_PROFILE_SPECIFIER=""
fi

flutter pub get
flutter build macos --release

if have_signing_secrets; then
  codesign --verify --deep --strict --verbose=2 "$APP"
  if have_notary_secrets; then
    notarize
  else
    echo "WARNING: signed but not notarized, no notary credentials." >&2
  fi
fi

# Zip with ditto: upload-artifact does not preserve the symlinks and exec bits
# inside the .app bundle, which would leave it unlaunchable.
rm -f "$ZIP"
ditto -c -k --sequesterRsrc --keepParent "$APP" "$ZIP"
