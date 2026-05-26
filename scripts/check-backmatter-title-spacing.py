#!/usr/bin/env python3
import html
import re
import subprocess
import sys
import tempfile
from pathlib import Path

PDF = Path(sys.argv[1] if len(sys.argv) > 1 else "thesis.pdf")

# This regression check targets the repository's sample thesis structure.
# Update page numbers here if the sample frontmatter/chapter/backmatter sequence changes.
TARGETS = {
    8: "第1章",
    12: "参考文献",
    13: "附录A",
    14: "致谢",
    15: "个人简历、在读期间发表的学术成果",
}


def page_words(page: int):
    with tempfile.NamedTemporaryFile(delete=False, suffix=".html") as tmp:
        tmp_path = Path(tmp.name)
    try:
        subprocess.run(
            ["pdftotext", "-f", str(page), "-l", str(page), "-bbox-layout", str(PDF), str(tmp_path)],
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
        value = html.unescape(re.sub("<.*?>", "", match.group(5)))
        if y_min > 90:
            words.append((x_min, y_min, x_max, y_max, value))
    return sorted(words, key=lambda item: (round(item[1] / 4) * 4, item[0]))


def heading_top(page: int, target: str) -> float:
    words = page_words(page)
    for index in range(len(words)):
        combined = ""
        tops = []
        for word in words[index : index + 12]:
            combined += word[4]
            tops.append(word[1])
            if combined == target:
                return min(tops)
            if not target.startswith(combined):
                break
    raise AssertionError(f"could not locate heading {target!r} on page {page}")


def main() -> int:
    reference_top = heading_top(8, TARGETS[8])
    failures = []
    for page, target in TARGETS.items():
        top = heading_top(page, target)
        delta = top - reference_top
        print(f"page {page:02d} {target}: top={top:.3f}pt delta={delta:+.3f}pt")
        if abs(delta) > 0.5:
            failures.append((page, target, delta))

    if failures:
        for page, target, delta in failures:
            print(f"FAIL page {page} {target}: title top differs from chapter title by {delta:+.3f}pt", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
