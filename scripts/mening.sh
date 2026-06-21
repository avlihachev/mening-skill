#!/usr/bin/env bash
set -euo pipefail

: "${MENING_API_TOKEN:?MENING_API_TOKEN is required}"
BASE="${MENING_API_BASE:-https://mening.app/api/v1}"

_req() {
  local method="$1" path="$2" body="${3:-}"
  local args=(-sS -X "$method" -H "Authorization: Bearer ${MENING_API_TOKEN}")
  if [[ -n "$body" ]]; then
    args+=(-H "Content-Type: application/json" -d "$body")
  fi
  curl "${args[@]}" "${BASE}${path}"
}

case "${1:-}" in
  today)  _req GET  /today ;;
  trends) _req GET  /trends ;;
  prompt) _req POST /prompts '{}' ;;
  submit)
    text="${2:?usage: mening.sh submit <text>}"
    _req POST /submissions "$(jq -nc --arg t "$text" '{text:$t}')" ;;
  *)
    echo "usage: mening.sh {today|submit <text>|trends|prompt}" >&2
    exit 2 ;;
esac
