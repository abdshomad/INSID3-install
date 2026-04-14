#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_DIR="$ROOT_DIR/INSID3"
VENV_PYTHON="$SUBMODULE_DIR/.venv/bin/python"
RUN_DIR="$ROOT_DIR/.run"
PID_FILE="$RUN_DIR/insid3.pid"
LOG_FILE="$RUN_DIR/insid3.log"

mkdir -p "$RUN_DIR"

if [[ ! -x "$VENV_PYTHON" ]]; then
  echo "Virtual environment not found. Run ./install.sh first."
  exit 1
fi

if [[ -f "$PID_FILE" ]]; then
  EXISTING_PID="$(cat "$PID_FILE")"
  if [[ -n "$EXISTING_PID" ]] && kill -0 "$EXISTING_PID" 2>/dev/null; then
    echo "INSID3 is already running (PID $EXISTING_PID)."
    echo "Use ./log.sh to view logs or ./stop.sh to stop it."
    exit 1
  fi
  rm -f "$PID_FILE"
fi

if [[ $# -eq 0 ]]; then
  set -- --dataset coco --exp-name insid3-coco
fi

(
  cd "$SUBMODULE_DIR"
  nohup "$VENV_PYTHON" inference.py "$@" >"$LOG_FILE" 2>&1 &
  echo $! >"$PID_FILE"
)

PID="$(cat "$PID_FILE")"
echo "INSID3 started (PID $PID)."
echo "Log file: $LOG_FILE"
