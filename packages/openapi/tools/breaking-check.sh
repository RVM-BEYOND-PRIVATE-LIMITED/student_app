#!/usr/bin/env bash
# The breaking-change check (student_app #15): the contract in this branch against the last
# RELEASED contract. "Released" is the newest GitHub release tagged contract-v* (student_app #14);
# before the first such release, it is the file on main.
#
# A breaking change is never made in place (CHANGELOG.md): a removed path or operation, a removed
# response field, a new required request field, a narrowed type or enum. oasdiff finds them; any
# ERR fails the job. Both files are bundled to JSON with Redocly first, because Redocly accepts
# flow-style YAML examples that oasdiff's YAML parser does not.
#
#   bash packages/openapi/tools/breaking-check.sh            (from the repository root)
#
# Needs: node (npx), docker, and gh with GH_TOKEN for the release download (CI has both).
set -euo pipefail

FILE=packages/openapi/openapi.yaml
OASDIFF=tufin/oasdiff:v1.35.0
REDOCLY=@redocly/cli@1.34.5
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

base_from=""
tag=$(gh release list --limit 50 --json tagName --jq '[.[] | select(.tagName | startswith("contract-v"))][0].tagName // ""' 2>/dev/null || true)
if [ -n "$tag" ] && gh release download "$tag" --pattern openapi.yaml --dir "$work/base" >/dev/null 2>&1; then
  mv "$work/base/openapi.yaml" "$work/base.yaml"
  base_from="release $tag"
else
  git fetch --quiet origin main 2>/dev/null || true
  if git show origin/main:"$FILE" > "$work/base.yaml" 2>/dev/null; then
    base_from="main"
  else
    echo "No released contract yet: nothing to compare with."
    exit 0
  fi
fi
cp "$FILE" "$work/rev.yaml"

npx --yes "$REDOCLY" bundle --ext json "$work/base.yaml" -o "$work/base.json" >/dev/null
npx --yes "$REDOCLY" bundle --ext json "$work/rev.yaml" -o "$work/rev.json" >/dev/null

echo "Comparing $FILE with the last released contract ($base_from)."
if docker run --rm -v "$work:/w" "$OASDIFF" breaking /w/base.json /w/rev.json --fail-on ERR; then
  echo "No breaking change against $base_from."
else
  echo "::error file=$FILE::A breaking change against $base_from. Add a new path and raise the minimum app version instead (CHANGELOG.md)."
  exit 1
fi
