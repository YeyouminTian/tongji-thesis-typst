#!/usr/bin/env python3
import html
import re
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
PDF = Path(sys.argv[1]) if len(sys.argv) > 1 else None
PAGE = int(sys.argv[2] if len(sys.argv) > 2 else "2")
EXPECTED_GAP_PT = 8.0
TOLERANCE_PT = 1.0
DPI = 144


def fixture_pdf() -> Path:
    tmp_dir = tempfile.TemporaryDirectory()
    fixture_dir = Path(tmp_dir.name)
    entry = fixture_dir / "continuation-fixture.typ"
    pdf = fixture_dir / "continuation-fixture.pdf"
    entry.write_text(
        """#import \"/lib.typ\": tongji-thesis, mainmatter, chapter
#import \"/metadata.typ\": thesis-info

#show: body => tongji-thesis(info: thesis-info)[#body]

#mainmatter[
  #chapter[测试章节][
    #for i in range(160) {
      [这是用于测量续页页眉横线到正文首行视觉距离的正文行。它应该在续页顶部直接出现而不是标题。]
      parbreak()
    }
  ]
]
"""
    )
    with entry.open("rb") as source:
        subprocess.run(
            ["typst", "compile", "--root", str(ROOT), "-", str(pdf)],
            check=True,
            stdin=source,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
    fixture_pdf._tmp_dir = tmp_dir
    return pdf


def header_rule_y(pdf: Path, page: int) -> float:
    with tempfile.TemporaryDirectory() as tmp_dir:
        prefix = Path(tmp_dir) / "page"
        subprocess.run(
            ["pdftocairo", "-png", "-r", str(DPI), "-f", str(page), "-l", str(page), str(pdf), str(prefix)],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        image_path = next(Path(tmp_dir).glob("*.png"))
        image = Image.open(image_path).convert("L")
        width, _height = image.size
        candidates = []
        for y in range(40, 240):
            row = [image.getpixel((x, y)) for x in range(int(width * 0.08), int(width * 0.92))]
            dark_pixels = sum(1 for pixel in row if pixel < 130)
            if dark_pixels > 600:
                candidates.append((y, dark_pixels))

    if not candidates:
        raise AssertionError(f"could not locate header rule on page {page}")

    groups = []
    for y, dark_pixels in candidates:
        if not groups or y > groups[-1][-1][0] + 1:
            groups.append([])
        groups[-1].append((y, dark_pixels))

    y = max(groups[0], key=lambda item: item[1])[0]
    return y * 72 / DPI


def page_rows(pdf: Path, page: int):
    with tempfile.NamedTemporaryFile(delete=False, suffix=".html") as tmp:
        tmp_path = Path(tmp.name)
    try:
        subprocess.run(
            ["pdftotext", "-f", str(page), "-l", str(page), "-bbox-layout", str(pdf), str(tmp_path)],
            check=True,
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
        )
        text = tmp_path.read_text(errors="ignore")
    finally:
        tmp_path.unlink(missing_ok=True)

    words = []
    pattern = re.compile(
        r'<word [^>]*xMin="([0-9.]+)" yMin="([0-9.]+)" xMax="([0-9.]+)" yMax="([0-9.]+)"[^>]*>(.*?)</word>'
    )
    for match in pattern.finditer(text):
        x_min, y_min, x_max, y_max = map(float, match.group(1, 2, 3, 4))
        value = html.unescape(re.sub("<.*?>", "", match.group(5))).strip()
        if value:
            words.append((x_min, y_min, x_max, y_max, value))

    rows = []
    for word in sorted(words, key=lambda item: (item[1], item[0])):
        if any(abs(word[1] - row[0]) < 2 for row in rows):
            continue
        row_words = [item for item in words if abs(item[1] - word[1]) < 2]
        row_words.sort(key=lambda item: item[0])
        rows.append(
            (
                min(item[1] for item in row_words),
                max(item[3] for item in row_words),
                "".join(item[4] for item in row_words),
            )
        )
    return rows


def main() -> int:
    pdf = PDF if PDF is not None else fixture_pdf()
    rule_y = header_rule_y(pdf, PAGE)
    content_rows = [row for row in page_rows(pdf, PAGE) if rule_y + 0.5 < row[0] < 760]
    if not content_rows:
        raise AssertionError(f"could not locate continuation page body text on page {PAGE}")

    body = content_rows[0]
    gap = body[0] - rule_y
    print(f"page {PAGE}: header_rule={rule_y:.3f}pt body_top={body[0]:.3f}pt gap={gap:.3f}pt body={body[2][:24]}")
    if abs(gap - EXPECTED_GAP_PT) > TOLERANCE_PT:
        print(
            f"FAIL page {PAGE}: header-rule-to-body visual gap should be {EXPECTED_GAP_PT:.1f}±{TOLERANCE_PT:.1f}pt, got {gap:.3f}pt",
            file=sys.stderr,
        )
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
