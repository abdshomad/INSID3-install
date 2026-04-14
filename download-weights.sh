#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PRETRAIN_DIR="$ROOT_DIR/INSID3/pretrain"

# Default source is a public mirror for the exact filenames used by INSID3.
# You can override this if you want to use a different host.
BASE_URL="${DINOv3_WEIGHTS_BASE_URL:-https://huggingface.co/jaychempan/dinov3/resolve/main}"

usage() {
  cat <<'EOF'
Usage: ./download-weights.sh [small|base|large|all]

Downloads DINOv3 checkpoints into INSID3/pretrain.

Environment variables:
  DINOv3_WEIGHTS_BASE_URL  Override checkpoint host base URL
                           (default: https://huggingface.co/jaychempan/dinov3/resolve/main)
EOF
}

if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi

TARGET="${1:-all}"

case "$TARGET" in
  small)
    FILES=("dinov3_vits16_pretrain_lvd1689m-08c60483.pth")
    ;;
  base)
    FILES=("dinov3_vitb16_pretrain_lvd1689m-73cec8be.pth")
    ;;
  large)
    FILES=("dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd.pth")
    ;;
  all)
    FILES=(
      "dinov3_vits16_pretrain_lvd1689m-08c60483.pth"
      "dinov3_vitb16_pretrain_lvd1689m-73cec8be.pth"
      "dinov3_vitl16_pretrain_lvd1689m-8aa4cbdd.pth"
    )
    ;;
  *)
    echo "Invalid target: $TARGET"
    usage
    exit 1
    ;;
esac

if ! command -v curl >/dev/null 2>&1; then
  echo "curl is required but not installed."
  exit 1
fi

mkdir -p "$PRETRAIN_DIR"

for file in "${FILES[@]}"; do
  dest="$PRETRAIN_DIR/$file"
  if [[ -f "$dest" ]]; then
    echo "Skipping existing file: $dest"
    continue
  fi

  url="$BASE_URL/$file"
  part="$dest.part"

  echo "Downloading: $file"
  echo "Source: $url"
  curl --fail --location --retry 3 --continue-at - --output "$part" "$url"
  mv "$part" "$dest"
  echo "Saved: $dest"
done

echo "Download complete."
