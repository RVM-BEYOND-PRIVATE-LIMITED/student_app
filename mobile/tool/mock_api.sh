#!/usr/bin/env bash
# Runs the published Student API contract as a mock on this computer, at the
# address a dev build uses by default (127.0.0.1:3000). Prism answers each
# route with its first named example; send `Prefer: example=<name>` to pick
# another (for example `needs_centre`).
#
#   bash tool/mock_api.sh            # from mobile/
#   adb reverse tcp:3000 tcp:3000    # from a phone, in another terminal
#   flutter run --dart-define=FLAVOR=dev
#
# student_app #1, item 12 and #2: build against the contract, never a guess.
set -euo pipefail

cd "$(dirname "$0")/.."
contract=../packages/openapi/openapi.yaml
test -f "$contract" || { echo "missing $contract" >&2; exit 1; }

exec npx --yes @stoplight/prism-cli@5 mock --port 3000 "$contract"
