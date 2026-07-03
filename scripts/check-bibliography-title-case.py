#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

BIB = """@article{RDDD202004007,
author = {王艳阳 and 梁宇哲 and 罗伟玲 and 谢贻新 and 刘济坤},
title = {基于高分遥感影像和POI的国土空间规划现状细化调查},
journal = {热带地理},
volume = {40},
number = {04},
pages = {649-658},
year = {2020},
issn = {1001-5221},
doi = {10.13284/j.cnki.rddl.003261},
url = {https://doi.org/10.13284/j.cnki.rddl.003261}
}

@article{poi_first,
author = {王艳阳},
title = {POI驱动的城市功能区识别},
journal = {热带地理},
year = {2021}
}

@article{brace_protected,
author = {Smith, John},
title = {{Interpreting black-box models: A review on explainable artificial intelligence}},
journal = {Artificial Intelligence Review},
year = {2022}
}

@article{internal_braces,
author = {Smith, John},
title = {Using {POI} Data for Land Use},
journal = {Journal of {GIS}},
year = {2023}
}

@article{multiline_title,
author = {王艳阳},
title = {基于高分遥感影像和POI的
  国土空间规划现状细化调查},
journal = {热带地理},
year = {2024}
}

@online{ngcc_2024,
author = {{国家地理信息公共服务平台}},
title = {{2024版国家地理信息公共服务平台（天地图）正式发布}},
date = {2024-04-26},
url = {https://www.ngcc.cn/xwzx/ywcg/202404/t20240426_2410.html},
urldate = {2026-05-27},
language = {zh-CN}
}
"""

TYP = """#import "../vendor/gb7714-bilingual/lib.typ": init-gb7714, gb7714-bibliography
#set text(font: ("Times New Roman", "SimSun"), size: 10pt)
#show: init-gb7714.with(read("refs.bib"), style: "numeric", version: "2025", show-url: false, show-doi: false)

#cite(<RDDD202004007>)
#cite(<poi_first>)
#cite(<brace_protected>)
#cite(<internal_braces>)
#cite(<multiline_title>)
#cite(<ngcc_2024>)

#gb7714-bibliography(title: none)
"""


def pdf_text(path: Path) -> str:
    result = subprocess.run(
        ["pdftotext", "-layout", path.as_posix(), "-"],
        check=True,
        capture_output=True,
        text=True,
    )
    return result.stdout


def compact(text: str) -> str:
    return "".join(text.split())


def main() -> None:
    with tempfile.TemporaryDirectory(dir=ROOT) as tmp:
        work = Path(tmp)
        (work / "refs.bib").write_text(BIB, encoding="utf-8")
        (work / "case.typ").write_text(TYP, encoding="utf-8")
        pdf = work / "case.pdf"
        result = subprocess.run(
            ["typst", "compile", "--root", ROOT.as_posix(), "case.typ", pdf.name],
            cwd=work,
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            raise RuntimeError(result.stderr)
        text = pdf_text(pdf)

    compact_text = compact(text)
    expected = (
        "基于高分遥感影像和POI的国土空间规划现状细化调查",
        "POI驱动的城市功能区识别",
        "Interpretingblack-boxmodels:Areviewonexplainableartificialintelligence",
        "UsingPOIDataforLandUse",
        "JournalofGIS",
        "2024版国家地理信息公共服务平台（天地图）正式发布",
        "[2026-05-27]",
        "https://www.ngcc.cn/xwzx/ywcg/202404/t20240426_2410.html",
    )
    missing = [item for item in expected if item not in compact_text]
    if missing:
        raise AssertionError(
            "bibliography title case was not preserved; missing "
            + repr(missing)
            + " in extracted text:\n"
            + text
        )

    forbidden = (
        "{Interpretingblack-boxmodels:Areviewonexplainableartificialintelligence}",
        "Using{POI}DataforLandUse",
        "Journalof{GIS}",
    )
    leaked = [item for item in forbidden if item in compact_text]
    if leaked:
        raise AssertionError(
            "BibTeX protection braces leaked into bibliography output; found "
            + repr(leaked)
            + " in extracted text:\n"
            + text
        )

    hidden = ("https://doi.org/10.13284/j.cnki.rddl.003261",)
    shown = [item for item in hidden if item in compact_text]
    if shown:
        raise AssertionError(
            "non-webpage URLs were rendered despite show-url: false; found "
            + repr(shown)
            + " in extracted text:\n"
            + text
        )


if __name__ == "__main__":
    main()
