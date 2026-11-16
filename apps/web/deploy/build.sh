#!/usr/bin/env bash
# The files the student web host serves (student_app #20 item 11): apps/web plus the design tokens,
# with index.html pointing at the tokens beside it instead of ../../packages. No build tool.
#   bash apps/web/deploy/build.sh <out folder>     (from the repository root)
set -euo pipefail
out="${1:?usage: build.sh <out folder>}"
rm -rf "$out"
mkdir -p "$out"
cp apps/web/index.html apps/web/app.js apps/web/styles.css "$out/"
cp packages/design-tokens/student.tokens.css "$out/student.tokens.css"
sed -i 's#\.\./\.\./packages/design-tokens/student\.tokens\.css#student.tokens.css#' "$out/index.html"
echo "built $(ls "$out" | wc -l) file(s) into $out"
