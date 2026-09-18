#!/usr/bin/env bash
set -euo pipefail

cd app

if [[ -n "${CI:-}" ]]; then
  SUDO=""
  [[ $EUID -ne 0 ]] && SUDO="sudo"

  $SUDO apt-get update
  $SUDO apt-get install -y --no-install-recommends \
    build-essential clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev
  git config --global --add safe.directory "${FLUTTER_HOME:-/sdks/flutter}"
fi

flutter pub get
flutter build linux --release