#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 <chapter-stem> [output-pdf]" >&2
  exit 2
fi

CHAPTER_STEM="$1"
CHAPTER_FILE="$ROOT/chapters/$CHAPTER_STEM.typ"
OUTPUT="${2:-$ROOT/$CHAPTER_STEM.pdf}"

case "$CHAPTER_STEM" in
  */*|*..*|"")
    echo "Invalid chapter stem: $CHAPTER_STEM" >&2
    exit 2
    ;;
esac

if [ ! -f "$CHAPTER_FILE" ]; then
  echo "Chapter file not found: $CHAPTER_FILE" >&2
  exit 1
fi

if command -v typst >/dev/null 2>&1; then
  TYPST_BIN="$(command -v typst)"
elif [ -x "$HOME/Downloads/typst-aarch64-apple-darwin/typst" ]; then
  TYPST_BIN="$HOME/Downloads/typst-aarch64-apple-darwin/typst"
else
  echo "typst executable not found. Add typst to PATH or edit scripts/compile-chapter.sh." >&2
  exit 1
fi

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT HUP INT TERM
TMP_ENTRY="$TMP_DIR/$CHAPTER_STEM.typ"

cat >"$TMP_ENTRY" <<EOF
#import "/vendor/gb7714-bilingual/lib.typ": init-gb7714
#import "/lib.typ": tongji-thesis, mainmatter, references
#import "/metadata.typ": thesis-info

#show: init-gb7714.with(read("/references.bib"), style: "numeric", version: "2015", show-url: false, show-doi: false)
#show: body => tongji-thesis(info: thesis-info)[#body]

#mainmatter[
  #include "/chapters/$CHAPTER_STEM.typ"
]

#references(bib: "references.bib")
EOF

"$TYPST_BIN" compile --root "$ROOT" - "$OUTPUT" <"$TMP_ENTRY"
