#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
/usr/bin/time -p pwd
/usr/bin/time -p bash -c 'echo "capture project: $(pwd)"'
if ! /usr/bin/time -p test -n "${CAPTURE_URL:-}"; then
  echo "Set CAPTURE_URL." >&2
  exit 1
fi
if ! /usr/bin/time -p test -n "${CAPTURE_DIR:-}"; then
  echo "Set CAPTURE_DIR." >&2
  exit 1
fi
/usr/bin/time -p bash -c 'echo "CAPTURE_URL=$CAPTURE_URL"'
/usr/bin/time -p bash -c 'echo "CAPTURE_DIR=$CAPTURE_DIR"'
/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
/usr/bin/time -p node --version
/usr/bin/time -p test -f "$HOME/.local/share/omgithub-playwright/linux.json"
/usr/bin/time -p test -n "${RUNTIME_DIR:-}"
/usr/bin/time -p test -f "$RUNTIME_DIR/scripts/default-capture.mjs"
/usr/bin/time -p node "$RUNTIME_DIR/scripts/default-capture.mjs"
/usr/bin/time -p ls -la "$CAPTURE_DIR"
/usr/bin/time -p test -f "$CAPTURE_DIR/final-desktop.png"
/usr/bin/time -p test -f "$CAPTURE_DIR/final-mobile.png"
