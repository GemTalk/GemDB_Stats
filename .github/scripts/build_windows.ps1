#!/usr/bin/env pwsh
$ErrorActionPreference = 'Stop'
$PSNativeCommandUseErrorActionPreference = $true

Set-Location app

if ($env:CI) {
  git config --global --add safe.directory ($env:FLUTTER_HOME ?? 'C:\hostedtoolcache\windows\flutter')
}

flutter pub get
flutter build windows --release
