#!/usr/bin/env bash
# The student app is Android only (student_app #8, item 13): no iOS target is
# built or published, and there is no web or desktop app either. Fails when
# the Flutter project in mobile/ grows another platform: its folder exists, or
# .metadata lists it (as `flutter create --platforms=...` would).
#
#   bash tool/android_only.sh [project folder, default: mobile/ itself]
set -euo pipefail

project=${1:-"$(dirname "$0")/.."}
cd "$project"

found=()
for platform in ios macos web linux windows; do
  if [ -e "$platform" ]; then
    found+=("$platform/")
  fi
done

if [ -f .metadata ]; then
  while read -r platform; do
    case "$platform" in
      root | android) ;;
      *) found+=(".metadata platform $platform") ;;
    esac
  done < <(sed -n 's/^[[:space:]]*- platform:[[:space:]]*//p' .metadata)
fi

if [ ${#found[@]} -gt 0 ]; then
  for item in "${found[@]}"; do
    echo "::error::The student app is Android only (student_app #8, item 13): remove $item"
  done
  exit 1
fi
echo "Android only: no other platform in $(pwd)"
