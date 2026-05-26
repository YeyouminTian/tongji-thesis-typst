#!/usr/bin/env python3
import html
import re
import subprocess
import sys
import tempfile
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[1]
PDF = Path(sys.argv[1] if len(sys.argv) > 1 else "thesis.pdf")
DPI = 144
TOLERANCE_PT = 1.0


def normalize(text: str) -> str:
    return re.sub(r"\s+", "", text)


def compile_fixture() -> Path:
    tmp_dir = tempfile.TemporaryDirectory()
    fixture_dir = Path(tmp_dir.name)
    entry = fixture_dir / "page-top-heading-fixture.typ"
    pdf = fixture_dir / "page-top-heading-fixture.pdf"
    entry.write_text(
        """#import \"/lib.typ\": tongji-thesis, mainmatter, chapter
#import \"/metadata.typ\": thesis-info

#show: body => tongji-thesis(info: thesis-info)[#body]

#mainmatter[
  #chapter[测试章节][
    #pagebreak()
    == 页首二级标题
    正文。
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
    compile_fixture._tmp_dir = tmp_dir
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
    for word in sorted(words, key=lambda item: (round(item[1] / 4) * 4, item[0])):
        if any(abs(word[1] - row[0]) < 2 for row in rows):
            continue
        row_words = [item for item in words if abs(item[1] - word[1]) < 2]
        row_words.sort(key=lambda item: item[0])
        rows.append(
            (
                min(item[1] for item in row_words),
                max(item[3] for item in row_words),
                normalize("".join(item[4] for item in row_words)),
            )
        )
    return rows


def title_top(pdf: Path, page: int, target: str, rule_y: float) -> float:
    target = normalize(target)
    candidates = [row for row in page_rows(pdf, page) if row[0] > rule_y + 0.5 and target in row[2]]
    if not candidates:
        raise AssertionError(f"could not locate page-top heading {target!r} on page {page}")
    return candidates[0][0]


def check(pdf: Path, page: int, target: str, expected_gap: float):
    rule_y = header_rule_y(pdf, page)
    gap = title_top(pdf, page, target, rule_y) - rule_y
    print(f"page {page:02d} {target}: header-rule-to-heading-top={gap:.3f}pt expected={expected_gap:.3f}pt")
    return gap


def main() -> int:
    checks = [
        (PDF, 4, "摘要", 24.0),
        (PDF, 5, "ABSTRACT", 24.0),
        (PDF, 6, "目录", 24.0),
        (PDF, 8, "第1章引言", 24.0),
        (PDF, 10, "第2章模板样式示例", 24.0),
        (PDF, 12, "参考文献", 24.0),
        (PDF, 13, "附录A示例附录", 24.0),
        (PDF, 14, "致谢", 24.0),
        (PDF, 15, "个人简历、在读期间发表的学术成果", 24.0),
    ]
    fixture = compile_fixture()
    checks.append((fixture, 2, "页首二级标题", 24.0))

    failures = []
    for pdf, page, target, expected_gap in checks:
        gap = check(pdf, page, target, expected_gap)
        if abs(gap - expected_gap) > TOLERANCE_PT:
            failures.append((page, target, gap, expected_gap))

    if failures:
        for page, target, gap, expected_gap in failures:
            print(
                f"FAIL page {page} {target}: header-rule-to-heading-top should be {expected_gap:.1f}±{TOLERANCE_PT:.1f}pt, got {gap:.3f}pt",
                file=sys.stderr,
            )
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
