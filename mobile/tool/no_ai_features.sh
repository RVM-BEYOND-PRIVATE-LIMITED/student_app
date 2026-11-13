#!/usr/bin/env bash
# The student app has no AI doubt solver, AI counsellor, AI mock interview or
# resume builder (student_app #9). Fails when the Flutter project in mobile/
# gains one: pubspec.yaml or pubspec.lock lists a generative-AI SDK, or a
# route in lib/router/ or a key or text in lib/l10n/*.arb names one of those
# features. A counsellor, a mock interview or the word "resume" alone stays
# allowed (staff do those); only the AI ones and a resume or CV builder fail.
#
#   bash tool/no_ai_features.sh [project folder, default: mobile/ itself]
set -euo pipefail
export LC_ALL=C

project=${1:-"$(dirname "$0")/.."}
cd "$project"

# Generative-AI SDKs on pub.dev; every langchain package too.
sdks='google_generative_ai|firebase_vertexai|firebase_ai|dart_openai|openai_dart|chat_gpt_sdk|anthropic_sdk_dart|ollama_dart|mistralai_dart|flutter_gemini|langchain[a-z0-9_]*'

# The features, matched on lower-case words: aiDoubtSolver, ai_counsellor,
# '/ai-mock-interview' and ResumeBuilderScreen all split into such words.
features='(^| )ai (doubt|counsel|mock interview|interview)|(^| )doubt solver|(^| )(resume|cv) (builder|maker|generator)'

# A file's lines, with a Dart file's // comments emptied, so a comment may
# name the rule. The line numbers stay.
code() {
  case "$1" in
    *.dart) sed -E -e 's#^[[:space:]]*//.*##' -e 's#[[:space:]]//.*$##' "$1" ;;
    *) cat "$1" ;;
  esac
}

# The lines of a file as lower-case words: camelCase split, and everything
# but letters and digits turned into one space.
words() {
  code "$1" | sed -E \
    -e 's/([a-z0-9])([A-Z])/\1 \2/g' \
    -e 's/([A-Z])([A-Z][a-z])/\1 \2/g' \
    -e 's/[^A-Za-z0-9]+/ /g' \
    | tr '[:upper:]' '[:lower:]'
}

found=()

if [ ! -f pubspec.yaml ]; then
  echo "::error::No AI features (student_app #9): no pubspec.yaml in $(pwd)"
  exit 1
fi
for file in pubspec.yaml pubspec.lock; do
  [ -f "$file" ] || continue
  while IFS=: read -r line name; do
    found+=("$file:$line lists the generative-AI SDK $name")
  done < <(grep -nE "^[[:space:]]+($sdks)[[:space:]]*:" "$file" \
    | sed -E 's/^([0-9]+):[[:space:]]*([^:[:space:]]+).*/\1:\2/' || true)
done

routes=()
if [ -d lib/router ]; then
  while IFS= read -r file; do
    routes+=("$file")
  done < <(find lib/router -name '*.dart' | sort)
fi
arbs=()
for file in lib/l10n/*.arb; do
  [ -f "$file" ] && arbs+=("$file")
done
# Nothing to read would pass for the wrong reason.
if [ ${#routes[@]} -eq 0 ] || [ ${#arbs[@]} -eq 0 ]; then
  echo "::error::No AI features (student_app #9): no lib/router/*.dart or lib/l10n/*.arb in $(pwd)"
  exit 1
fi

for file in "${routes[@]}" "${arbs[@]}"; do
  while IFS=: read -r line _; do
    text=$(sed -n "${line}p" "$file" | sed -E 's/^[[:space:]]+//')
    found+=("$file:$line names an AI doubt solver, AI counsellor, AI mock interview or resume builder: $text")
  done < <(words "$file" | grep -nE "$features" || true)
done

if [ ${#found[@]} -gt 0 ]; then
  for item in "${found[@]}"; do
    echo "::error::No AI features (student_app #9): $item"
  done
  exit 1
fi
echo "No AI features: no generative-AI SDK, and no AI doubt solver, AI counsellor, AI mock interview or resume builder in $(pwd)"
