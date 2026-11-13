#!/usr/bin/env bash
# Release builds of the student app (student_app #8, items 5 and 6), all
# prod (FLAVOR=prod) and obfuscated, with the files that turn an obfuscated
# crash back into readable names kept under build/symbols/:
#
#   app-release.aab                 the App Bundle, for Play
#   app-release.apk                 one universal APK (every ABI): the pilot
#                                   build handed out by hand until Play
#                                   approves (D11). Same versionCode as the
#                                   bundle, so Play's build updates it.
#   app-<abi>-release.apk           one APK per ABI, for the size report
#                                   only. Never hand one out: its versionCode
#                                   is raised per ABI (1001, 2001, 4001), so
#                                   a Play build can never update it
#                                   (README, "Version codes").
#
#   cd mobile && bash tool/build_release.sh [more `flutter build` flags]
#
# Extra flags go to every build, for example
#   --dart-define=STUDENT_API_HOST=https://...
# A FLAVOR other than prod is refused: a release build never carries the
# Developer menu and its test switches, and tool/check_release.dart fails
# one that does. The FLAVOR is read as Dart and Gradle read it, trimmed and
# in any case, so FLAVOR=Prod or FLAVOR=PROD is prod too.
#
# Signing: this script signs nothing itself. A release build is signed only
# once the key route is decided (student_app #20); until then only CI's size
# build is signed, with the runner's throwaway debug key
# (RVM_CI_SIZE_REPORT=true, android/app/build.gradle.kts).
#
# Keep, for every build that leaves this computer (one folder per version):
#   build/symbols/appbundle/   for the App Bundle
#   build/symbols/apk/         for the universal APK
# Each holds, per ABI, the Dart symbols (app.android-<abi>.symbols) and the
# Dart obfuscation map (app.android-<abi>.obfuscation.map.json), and R8's
# mapping.txt. README, "Reading an obfuscated crash", says how to use them.
# The App Bundle also carries R8's mapping inside, for Play.
# build/symbols/apk-per-abi/ holds the same per ABI, but one R8 mapping per
# ABI (mapping.android-<abi>.txt): each per-ABI APK is its own Gradle build,
# with its own R8 run.
set -euo pipefail

cd "$(dirname "$0")/.."

# FLAVOR's value as lib/core/env/student_env.dart (trim().toLowerCase())
# and android/app/build.gradle.kts (trim().lowercase()) read it. tr, not
# ${var,,}, so the bash 3.2 that macOS ships runs it too.
flavor_of() {
  printf '%s' "${1##*FLAVOR=}" |
    sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//' |
    tr '[:upper:]' '[:lower:]'
}

for arg in "$@"; do
  case "$arg" in
    *FLAVOR=*)
      if [ "$(flavor_of "$arg")" != prod ]; then
        echo "error: release builds are prod builds; remove $arg" >&2
        exit 64
      fi
      ;;
  esac
done

extra=("$@")
symbols=build/symbols
mapping=build/app/outputs/mapping/release/mapping.txt
bundle=build/app/outputs/bundle/release/app-release.aab
apks=build/app/outputs/flutter-apk
# Flutter's name for each ABI, then Android's.
abis=(android-arm:armeabi-v7a android-arm64:arm64-v8a android-x64:x86_64)

# From a clean tree: Flutter keeps its compiled Dart between builds and does
# not write the symbol files again for a build it finds up to date, so a
# reused tree could leave them missing, or from another build.
flutter clean

# One build (`build <name> <mapping file> <flutter build args>`), then its
# Dart symbol files and R8 mapping are checked and kept in $symbols/<name>,
# the mapping under the given file name.
build() {
  local name=$1 kept=$2
  shift 2
  local out="$symbols/$name"
  rm -f "$mapping"
  flutter build "$@" --release --obfuscate --split-debug-info="$out" \
    --dart-define=FLAVOR=prod ${extra[@]+"${extra[@]}"}
  if ! compgen -G "$out/app.android-*.symbols" > /dev/null; then
    echo "error: no Dart symbol files in $out" >&2
    exit 1
  fi
  if [ ! -s "$mapping" ]; then
    echo "error: R8 wrote no mapping file ($mapping): is shrinking off?" >&2
    exit 1
  fi
  cp "$mapping" "$out/$kept"
}

build appbundle mapping.txt appbundle
build apk mapping.txt apk

# The per-ABI APKs, one ABI at a time, each saving its Dart obfuscation map.
# The map differs between ABIs, and Flutter hands every ABI of one build the
# same --save-obfuscation-map path, so a build of several ABIs keeps only
# one of them. Each of these builds runs R8 again, so each keeps its own R8
# mapping too (mapping.android-<abi>.txt), for a Java or Kotlin trace from
# that APK.
for pair in "${abis[@]}"; do
  dart_abi=${pair%%:*}
  build apk-per-abi "mapping.$dart_abi.txt" \
    apk --split-per-abi --target-platform "$dart_abi" \
    --extra-gen-snapshot-options=--save-obfuscation-map="$PWD/$symbols/apk-per-abi/app.$dart_abi.obfuscation.map.json"
done

# Each ABI's map also belongs to the App Bundle and the universal APK: Dart
# compiles the same code to the same bytes in every build, which is checked
# here (the same libapp.so), before the map is kept beside their symbols.
libapp() { unzip -p "$1" "$2" | sha256sum | cut -d' ' -f1; }
for pair in "${abis[@]}"; do
  dart_abi=${pair%%:*}
  abi=${pair##*:}
  map="$symbols/apk-per-abi/app.$dart_abi.obfuscation.map.json"
  if [ ! -s "$map" ]; then
    echo "error: no Dart obfuscation map for $dart_abi ($map)" >&2
    exit 1
  fi
  want=$(libapp "$apks/app-$abi-release.apk" "lib/$abi/libapp.so")
  for target in "appbundle:$bundle:base/lib/$abi/libapp.so" \
    "apk:$apks/app-release.apk:lib/$abi/libapp.so"; do
    IFS=: read -r name file entry <<< "$target"
    if [ "$(libapp "$file" "$entry")" != "$want" ]; then
      echo "error: $file holds another $abi build of the Dart code than" \
        "the per-ABI APK, so $map does not fit it" >&2
      exit 1
    fi
    cp "$map" "$symbols/$name/"
  done
done

echo "Symbols kept in $symbols:"
ls -1 "$symbols"/*
