#!/usr/bin/env python3
import html
import re
import subprocess
import sys
import tempfile
from pathlib import Path

PDF = Path(sys.argv[1] if len(sys.argv) > 1 else "thesis.pdf")
REFERENCE = Path(sys.argv[2] if len(sys.argv) > 2 else "同济大学研究生学位论文写作参考示例.pdf")

# This regression check targets the repository's sample thesis structure.
# Update page numbers here if the sample frontmatter/chapter/backmatter sequence changes.

CASES = [
    ("摘要", PDF, 4, "摘要", REFERENCE, 9, "摘要", 80, 340),
    ("Abstract", PDF, 5, "ABSTRACT", REFERENCE, 10, "ABSTRACT", 80, 340),
    ("正文第1章", PDF, 8, "第1章引言", REFERENCE, 12, "第1章引言", 80, 340),
    ("参考文献", PDF, 12, "参考文献", REFERENCE, 16, "参考文献", 80, 340),
    ("致谢", PDF, 14, "致谢", REFERENCE, 18, "致谢", 80, 340),
    ("个人简历", PDF, 15, "个人简历、在读期间发表的学术成果", REFERENCE, 19, "个人简历、在读期间发表的学术成果", 80, 340),
]


def normalize(text: str) -> str:
    return re.sub(r"\s+", "", text)


def page_words(pdf: Path, page: int):
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

    pattern = re.compile(
        r'<word [^>]*xMin="([0-9.]+)" yMin="([0-9.]+)" xMax="([0-9.]+)" yMax="([0-9.]+)"[^>]*>(.*?)</word>'
    )
    words = []
    for match in pattern.finditer(text):
        x_min, y_min, x_max, y_max = map(float, match.group(1, 2, 3, 4))
        value = html.unescape(re.sub("<.*?>", "", match.group(5)))
        words.append((x_min, y_min, x_max, y_max, value))
    return sorted(words, key=lambda item: (item[1], item[0]))


def title_box(words, target: str):
    target = normalize(target)
    candidates = []
    for index in range(len(words)):
        combined = ""
        group = []
        for word in words[index : index + 16]:
            if not 80 <= word[1] <= 130:
                continue
            combined += normalize(word[4])
            group.append(word)
            if combined == target or target in combined:
                candidates.append(group[:])
                break
            if not target.startswith(combined):
                break
    if not candidates:
        raise AssertionError(f"could not locate title {target!r}")
    group = max(candidates, key=lambda item: len(normalize("".join(word[4] for word in item))))
    return min(word[1] for word in group), max(word[3] for word in group), "".join(word[4] for word in group)


def next_content(words, title, x_min: float, x_max: float):
    _title_top, title_bottom, _title_text = title
    candidates = []
    for word in words:
        wx_min, wy_min, _wx_max, wy_max, value = word
        if wy_min <= title_bottom + 0.5 or wy_min > 260:
            continue
        if wx_min < x_min or wx_min > x_max:
            continue
        if re.fullmatch(r"[.。…]+", value.strip()):
            continue
        candidates.append(word)
    if not candidates:
        raise AssertionError(f"could not locate content below title {title[2]!r}")
    y_min = min(word[1] for word in candidates)
    row = [word for word in candidates if abs(word[1] - y_min) < 2]
    return y_min, max(word[3] for word in row), "".join(word[4] for word in row)


def main() -> int:
    failures = []
    for name, current_pdf, current_page, current_title, ref_pdf, ref_page, ref_title, x_min, x_max in CASES:
        current_words = page_words(current_pdf, current_page)
        ref_words = page_words(ref_pdf, ref_page)
        current_title_box = title_box(current_words, current_title)
        ref_title_box = title_box(ref_words, ref_title)
        current_next = next_content(current_words, current_title_box, x_min, x_max)
        ref_next = next_content(ref_words, ref_title_box, x_min, x_max)
        current_gap = current_next[0] - current_title_box[1]
        ref_gap = ref_next[0] - ref_title_box[1]
        delta = current_gap - ref_gap
        print(
            f"{name}: current_gap={current_gap:.3f}pt ref_gap={ref_gap:.3f}pt "
            f"delta={delta:+.3f}pt current_next={current_next[2][:24]} ref_next={ref_next[2][:24]}"
        )
        if abs(delta) > 2.0:
            failures.append((name, delta))

    if failures:
        for name, delta in failures:
            print(f"FAIL {name}: title-to-content gap differs by {delta:+.3f}pt", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
