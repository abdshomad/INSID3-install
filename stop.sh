#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PID_FILE="$ROOT_DIR/.run/insid3.pid"

if [[ ! -f "$PID_FILE" ]]; then
  echo "No PID file found. INSID3 does not appear to be running."
  exit 0
fi

PID="$(cat "$PID_FILE")"

if [[ -z "$PID" ]]; then
  echo "PID file is empty. Cleaning up."
  rm -f "$PID_FILE"
  exit 0
fi

if ! kill -0 "$PID" 2>/dev/null; then
  echo "Process $PID is not running. Cleaning up."
  rm -f "$PID_FILE"
  exit 0
fi

kill "$PID"

for _ in {1..10}; do
  if ! kill -0 "$PID" 2>/dev/null; then
    rm -f "$PID_FILE"
    echo "INSID3 stopped."
    exit 0
  fi
  sleep 1
done

echo "Process did not stop gracefully. Sending SIGKILL."
kill -9 "$PID"
rm -f "$PID_FILE"
echo "INSID3 stopped."
