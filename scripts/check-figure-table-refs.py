#!/usr/bin/env python3
import re
import subprocess
import sys
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

ENTRY = r'''#import "/lib.typ": tongji-thesis, mainmatter, chapter
#import "/metadata.typ": thesis-info

#show: body => tongji-thesis(info: thesis-info)[#body]

#mainmatter[
  #chapter[引用测试][
    #figure(rect(width: 1cm, height: 1cm), caption: [测试图]) <fig:test>
    图引用 @fig:test。
    #figure(table(columns: 1, [A]), caption: [测试表]) <tbl:test>
    表引用 @tbl:test。
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
    for expected in ("图引用 图 1-1", "表引用 表 1-1"):
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
