#!/usr/bin/env bash
# Release builds of the student app (student_app #8, items 5 and 6): the App
# Bundle for Play and one APK per ABI, both obfuscated, with the files that
# turn an obfuscated crash back into readable names kept under build/symbols/.
#
#   cd mobile && bash tool/build_release.sh [more `flutter build` flags]
#
# Extra flags go to both builds, for example
#   --dart-define=FLAVOR=prod --dart-define=STUDENT_API_HOST=https://...
#
# Signing: this script signs nothing itself. A release build is signed only
# once the key route is decided (student_app #20); until then only CI's size
# build is signed, with the runner's throwaway debug key
# (RVM_CI_SIZE_REPORT=true, android/app/build.gradle.kts).
#
# Keep, for every build that leaves this computer (one folder per version):
#   build/symbols/appbundle/   Dart symbols (app.android-*.symbols) and R8's
#                              mapping.txt for the App Bundle
#   build/symbols/apk/         the same for the per-ABI APKs
# `flutter symbolize -d <symbols file> -i <stack trace>` reads them. The App
# Bundle also carries R8's mapping inside, for Play.
set -euo pipefail

cd "$(dirname "$0")/.."

symbols=build/symbols
mapping=build/app/outputs/mapping/release/mapping.txt

# From a clean tree: Flutter keeps its compiled Dart between builds and does
# not write the symbol files again for a build it finds up to date, so a
# reused tree could leave them missing, or from another build.
flutter clean

# One build, then its symbol files and R8 mapping are checked and kept.
build() {
  local kind=$1
  shift
  rm -f "$mapping"
  flutter build "$kind" --release --obfuscate \
    --split-debug-info="$symbols/$kind" "$@"
  if ! compgen -G "$symbols/$kind/app.android-*.symbols" > /dev/null; then
    echo "error: no Dart symbol files in $symbols/$kind" >&2
    exit 1
  fi
  if [ ! -s "$mapping" ]; then
    echo "error: R8 wrote no mapping file ($mapping): is shrinking off?" >&2
    exit 1
  fi
  cp "$mapping" "$symbols/$kind/mapping.txt"
}

build appbundle "$@"
build apk --split-per-abi "$@"

echo "Symbols kept in $symbols:"
ls -1 "$symbols"/*
