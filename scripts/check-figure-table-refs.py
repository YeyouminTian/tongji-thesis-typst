#!/usr/bin/env python3
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

ENTRY = r'''#import "/lib.typ": tongji-thesis, mainmatter, backmatter, chapter, appendix
#import "/metadata.typ": thesis-info

#show: body => tongji-thesis(info: thesis-info)[#body]

#mainmatter[
  #chapter(label: <chap:ref-test>)[引用测试][
    章节引用 @chap:ref-test。
    #figure(rect(width: 1cm, height: 1cm), caption: [测试图]) <fig:test>
    图引用 @fig:test。
    #figure(table(columns: 1, [A]), caption: [测试表]) <tbl:test>
    表引用 @tbl:test。
    完整检验结果见@app:kip-statistical-tests。
  ]
]

#backmatter[
  #appendix(label: <app:kip-statistical-tests>)[KIP 消融实验完整统计检验结果][
    附录内容。
  ]
]
'''


def render_text() -> str:
    with tempfile.TemporaryDirectory() as tmp_dir:
        tmp = Path(tmp_dir)
        entry = tmp / "figure-ref-fixture.typ"
        pdf = tmp / "figure-ref-fixture.pdf"
        txt = tmp / "figure-ref-fixture.txt"
        entry.write_text(ENTRY)
        with entry.open("rb") as source:
            subprocess.run(
                ["typst", "compile", "--root", str(ROOT), "-", str(pdf)],
                check=True,
                stdin=source,
                stdout=subprocess.DEVNULL,
                stderr=subprocess.DEVNULL,
            )
        subprocess.run(["pdftotext", str(pdf), str(txt)], check=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        return txt.read_text(errors="ignore")


def main() -> int:
    text = re.sub(r"\s+", " ", render_text())
    failures = []
    for expected in ("章节引用 第 1 章", "图引用 图 1-1", "表引用 表 1-1", "完整检验结果见附录A"):
        if expected not in text:
            failures.append(expected)

    print(text)
    if failures:
        for expected in failures:
            print(f"FAIL missing expected reference text: {expected}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
