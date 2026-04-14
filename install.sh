#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SUBMODULE_DIR="$ROOT_DIR/INSID3"
VENV_DIR="$SUBMODULE_DIR/.venv"
REQUIREMENTS_FILE="$SUBMODULE_DIR/requirements.txt"
WEIGHTS_SCRIPT="$ROOT_DIR/download-weights.sh"
WEIGHTS_TARGET="${DINOv3_WEIGHTS_TARGET:-all}"

if [[ ! -d "$SUBMODULE_DIR" ]]; then
  echo "INSID3 submodule not found at: $SUBMODULE_DIR"
  exit 1
fi

if ! command -v uv >/dev/null 2>&1; then
  echo "uv is not installed. Install it first: https://docs.astral.sh/uv/getting-started/installation/"
  exit 1
fi

if [[ -x "$VENV_DIR/bin/python" ]]; then
  echo "Using existing virtual environment at $VENV_DIR"
else
  echo "Creating uv virtual environment at $VENV_DIR"
  uv venv "$VENV_DIR" --python 3.10
fi

if [[ ! -f "$REQUIREMENTS_FILE" ]]; then
  echo "Requirements file not found: $REQUIREMENTS_FILE"
  exit 1
fi

echo "Installing dependencies from INSID3/requirements.txt"
uv pip install --python "$VENV_DIR/bin/python" -r "$REQUIREMENTS_FILE"

if [[ ! -x "$WEIGHTS_SCRIPT" ]]; then
  echo "Weights script not found or not executable: $WEIGHTS_SCRIPT"
  echo "Skipping DINOv3 weights download."
else
  echo "Ensuring DINOv3 weights are available (target: $WEIGHTS_TARGET)"
  "$WEIGHTS_SCRIPT" "$WEIGHTS_TARGET"
fi

echo "Install complete."
