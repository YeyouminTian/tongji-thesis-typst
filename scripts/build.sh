#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if command -v typst >/dev/null 2>&1; then
  TYPST_BIN="$(command -v typst)"
elif [ -x "$HOME/Downloads/typst-aarch64-apple-darwin/typst" ]; then
  TYPST_BIN="$HOME/Downloads/typst-aarch64-apple-darwin/typst"
else
  echo "typst executable not found. Add typst to PATH or edit scripts/build.sh." >&2
  exit 1
fi

"$TYPST_BIN" compile "$ROOT/thesis.typ" "$ROOT/thesis.pdf"
