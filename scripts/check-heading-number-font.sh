#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if ! grep -Fq '  hei-strict: ("Source Han Sans SC", "Source Han Sans", "Noto Sans CJK SC", "SimHei", "Heiti SC", "STHeiti"),' "$ROOT/utils/typography.typ"; then
  echo "heading number font stack must use strict Heiti fonts without Latin fallback" >&2
  exit 1
fi

if ! grep -Eq 'text\(font: fonts\.hei-strict, size: 1\.04em, baseline: 0\.[0-9]+em, cjk-latin-spacing: none\)\[#number\]' "$ROOT/utils/heading.typ"; then
  echo "heading numeric runs must use strict Heiti with size and baseline compensation" >&2
  exit 1
fi

if ! grep -Fq '"第 " + str(nums.at(0)) + " 章"' "$ROOT/utils/heading.typ"; then
  echo "chapter heading text must space the number as 第 1 章" >&2
  exit 1
fi

if ! grep -Fq '(prefix: "第 ", number: str(nums.at(0)), suffix: " 章")' "$ROOT/utils/heading.typ"; then
  echo "chapter heading rendering parts must space the numeric run as 第 1 章" >&2
  exit 1
fi

if grep -Fq 'for char in chars' "$ROOT/utils/heading.typ"; then
  echo "heading number compensation must preserve numeric runs instead of splitting characters" >&2
  exit 1
fi

if grep -Fq 'size: 1.12em' "$ROOT/utils/heading.typ"; then
  echo "heading number compensation must not scale the whole prefix" >&2
  exit 1
fi
