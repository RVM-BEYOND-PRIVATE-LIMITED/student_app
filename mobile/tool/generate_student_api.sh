#!/usr/bin/env bash
# Regenerate the Dart client from the published Student API contract.
# Pinned: Redocly 1.34.5 (bundle to JSON) and OpenAPI Generator 7.27.0 (Dart).
# The generated package is checked in; run this after a contract publish and
# commit the diff. `--check` regenerates into a temp folder and fails on drift.
set -euo pipefail
cd "$(dirname "$0")/.."
contract=../packages/openapi/openapi.yaml
out=packages/student_api
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
npx --yes @redocly/cli@1.34.5 bundle --ext json "$contract" -o "$tmp/contract.json"
npx --yes @openapitools/openapi-generator-cli generate \
  -g dart -i "$tmp/contract.json" -o "$tmp/client" \
  --additional-properties=pubName=student_api,serializationLibrary=json_serializable
rm -rf "$tmp/client/doc" "$tmp/client/test" "$tmp/client/.travis.yml" \
  "$tmp/client/git_push.sh" "$tmp/client/.gitignore" "$tmp/client/.openapi-generator-ignore"
if [ "${1:-}" = "--check" ]; then
  diff -ru --exclude='.openapi-generator' --exclude='.dart_tool' --exclude='pubspec.lock' --exclude='.gitignore' "$out" "$tmp/client"
  echo "generated client matches the contract"
else
  rm -rf "$out"
  mv "$tmp/client" "$out"
  echo "regenerated $out"
fi
