#!/usr/bin/env bash
# live smoke test — requires a real MENING_API_TOKEN (consumes the daily cap).
# run deliberately, not in a loop: MENING_API_TOKEN=... bash agent-skill/test/smoke.sh
set -euo pipefail

if [[ -z "${MENING_API_TOKEN:-}" ]]; then
  echo "SKIP: set MENING_API_TOKEN to run the live smoke test" >&2
  exit 0
fi

here="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
sh="$here/scripts/mening.sh"

echo "today:"
"$sh" today | jq -e 'has("prompts")' >/dev/null
echo "  ok: prompts[]"

echo "trends:"
"$sh" trends | jq -e 'has("activity")' >/dev/null
echo "  ok: activity"

echo "submit:"
"$sh" submit "Jag lärde mig ett nytt ord idag." \
  | jq -e 'has("submission_id") and has("status")' >/dev/null
echo "  ok: submission recorded"

echo "ALL SMOKE CHECKS PASSED"
