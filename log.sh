#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$ROOT_DIR/.run/insid3.log"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "Log file not found: $LOG_FILE"
  echo "Start INSID3 first with ./start.sh"
  exit 1
fi

if [[ "${1:-}" == "--follow" || "${1:-}" == "-f" ]]; then
  tail -f "$LOG_FILE"
else
  tail -n "${LINES:-100}" "$LOG_FILE"
fi
