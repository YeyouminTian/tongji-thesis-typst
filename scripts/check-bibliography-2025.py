#!/usr/bin/env python3
from __future__ import annotations

import subprocess
import tempfile
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

BIB = r"""
@article{zh_article,
  author = {王一 and 李二 and 张三 and 赵四},
  title = {中文题名},
  journal = {中文期刊},
  year = {2025},
  volume = {1},
  number = {2},
  pages = {3--4},
  language = {zh-CN}
}

@article{en_article,
  author = {Godard, Jean-Luc and Smith, John and Doe, Jane and Roe, Richard},
  title = {English title},
  journal = {English Journal},
  year = {2025},
  volume = {2},
  number = {3},
  pages = {10--12},
  language = {en-US}
}

@misc{standard_2025,
  author = {{不应显示的发布者}},
  title = {信息与文献 测试标准},
  number = {GB/T 99999—2025},
  year = {2025},
  publisher = {不应显示的出版社},
  mark = {S},
  language = {zh-CN}
}

@techreport{report_2025,
  author = {{测试研究院}},
  title = {测试报告},
  number = {R-2025-01},
  date = {2025-01-02},
  pages = {7--8},
  url = {https://example.com/report.pdf},
  medium = {OL},
  language = {zh-CN}
}

@inproceedings{conference_2025,
  author = {王五 and 李六},
  title = {会议论文题名},
  eventtitle = {测试学术会议},
  year = {2025},
  pages = {20--25},
  language = {zh-CN}
}

@online{website_2025,
  title = {测试网站},
  date = {2025-02-03},
  url = {https://example.com/},
  urldate = {2026-06-23},
  language = {zh-CN}
}

@misc{archive_2025,
  author = {张档},
  title = {档案题名},
  number = {A-001},
  address = {上海},
  publisher = {测试档案馆},
  date = {1931-11-07},
  mark = {A},
  language = {zh-CN}
}

@misc{map_2025,
  author = {李图},
  title = {测试地图},
  scale = {1∶25 000},
  address = {北京},
  publisher = {测试地图出版社},
  year = {2025},
  dimensions = {100 cm×80 cm},
  mark = {CM},
  language = {zh-CN}
}

@misc{dataset_2025,
  author = {周数},
  title = {测试数据集},
  version = {V1.0},
  publisher = {测试数据平台},
  date = {2025-03-04},
  url = {https://example.com/dataset},
  urldate = {2026-06-23},
  doi = {10.1234/example.dataset},
  mark = {DS},
  medium = {OL},
  language = {zh-CN}
}

@misc{preprint_2025,
  author = {Jenkins, Simon-David and Ruostekoski, Janne},
  title = {Controlled light},
  version = {V2},
  archivePrefix = {arXiv},
  eprint = {1112.6136},
  date = {2012-03-18},
  url = {https://doi.org/10.48550/arXiv.1112.6136},
  urldate = {2020-06-24},
  doi = {10.48550/arXiv.1112.6136},
  language = {en-US}
}

@article{ja_sort,
  author = {Yamada, Taro},
  title = {Japanese group marker},
  journal = {Journal},
  year = {2025},
  language = {ja-JP}
}

@article{ru_sort,
  author = {Ivanov, Ivan},
  title = {Russian group marker},
  journal = {Journal},
  year = {2025},
  language = {ru-RU}
}

@article{other_sort,
  author = {Ali, Ahmad},
  title = {Other group marker},
  journal = {Journal},
  year = {2025},
  language = {ar}
}
"""


def typ(version: str) -> str:
    return f"""#import "../vendor/gb7714-bilingual/lib.typ": init-gb7714, gb7714-bibliography
#set text(lang: "zh", size: 10pt)
#show: init-gb7714.with(
  read("refs.bib"),
  style: "numeric",
  version: "{version}",
  show-url: true,
  show-doi: true,
)

#cite(<zh_article>)
#cite(<en_article>)
#cite(<standard_2025>)
#cite(<report_2025>)
#cite(<conference_2025>)
#cite(<website_2025>)
#cite(<archive_2025>)
#cite(<map_2025>)
#cite(<dataset_2025>)
#cite(<preprint_2025>)

#gb7714-bibliography(title: none)
"""


def compact(text: str) -> str:
    return "".join(text.split())


def compile_source(source: str) -> str:
    with tempfile.TemporaryDirectory(dir=ROOT) as tmp:
        work = Path(tmp)
        (work / "refs.bib").write_text(BIB, encoding="utf-8")
        (work / "case.typ").write_text(source, encoding="utf-8")
        result = subprocess.run(
            [
                "typst",
                "compile",
                "--root",
                ROOT.as_posix(),
                "case.typ",
                "case.pdf",
            ],
            cwd=work,
            capture_output=True,
            text=True,
        )
        if result.returncode != 0:
            raise RuntimeError(result.stderr)
        extracted = subprocess.run(
            ["pdftotext", "-layout", "case.pdf", "-"],
            cwd=work,
            check=True,
            capture_output=True,
            text=True,
        )
        return extracted.stdout


def compile_text(version: str) -> str:
    return compile_source(typ(version))


def compile_citation_text(style: str) -> str:
    return compile_source(
        f"""#import "../vendor/gb7714-bilingual/lib.typ": init-gb7714, gb7714-bibliography, multicite
#set text(lang: "zh", size: 10pt)
#show: init-gb7714.with(read("refs.bib"), style: "{style}", version: "2025")

#cite(<zh_article>, supplement: [15])
#multicite((key: "zh_article", supplement: [21]), "en_article", form: "prose")

#gb7714-bibliography(title: none)
"""
    )


def compile_sort_text() -> str:
    return compile_source(
        """#import "../vendor/gb7714-bilingual/lib.typ": init-gb7714, gb7714-bibliography
#set text(lang: "zh", size: 10pt)
#show: init-gb7714.with(read("refs.bib"), style: "author-date", version: "2025")
#gb7714-bibliography(title: none, full: true)
"""
    )


def check_2025(text: str) -> None:
    value = compact(text)
    required = (
        "王一，李二，张三，等",
        "GodardJ-L,SmithJ,DoeJ,etal.",
        "GB/T99999—2025信息与文献测试标准[S]",
        "测试报告：R-2025-01[R/OL]",
        "会议论文题名[C]//测试学术会议，2025：20–25",
        "测试网站[EB/OL]",
        "档案题名：A-001[A]",
        "测试地图，1∶25000[CM]",
        "测试数据集[DS/OL]",
        "Controlledlight[PP/OL]",
        "[2026-06-23]",
    )
    missing = [item for item in required if item not in value]
    if missing:
        raise AssertionError(f"2025 output missing {missing!r}:\n{text}")

    forbidden = (
        "不应显示的发布者",
        "不应显示的出版社",
        "佚名.测试网站",
        "DOI:10.48550/arXiv.1112.6136",
    )
    present = [item for item in forbidden if item in value]
    if present:
        raise AssertionError(f"2025 output contains forbidden {present!r}:\n{text}")


def check_2015(text: str) -> None:
    value = compact(text)
    required = (
        "GodardJL,SmithJ,DoeJ,etal.",
        "不应显示的发布者",
        "不应显示的出版社,2025",
        "测试网站[EB/OL]",
    )
    missing = [item for item in required if item not in value]
    if missing:
        raise AssertionError(f"2015 compatibility output missing {missing!r}:\n{text}")


def main() -> None:
    check_2025(compile_text("2025"))
    check_2015(compile_text("2015"))
    numeric = compact(compile_citation_text("numeric"))
    if "[1]15" not in numeric or "[1]21,[2]" not in numeric:
        raise AssertionError(f"2025 numeric locator placement is wrong: {numeric}")
    author_date = compact(compile_citation_text("author-date"))
    if "（王一等，2025）15" not in author_date:
        raise AssertionError(
            f"2025 author-date locator placement is wrong: {author_date}"
        )
    sorted_text = compact(compile_sort_text())
    markers = (
        "中文题名",
        "Japanesegroupmarker",
        "Englishtitle",
        "Russiangroupmarker",
        "Othergroupmarker",
    )
    positions = [sorted_text.index(marker) for marker in markers]
    if positions != sorted(positions):
        raise AssertionError(
            f"2025 language-group sorting is wrong: {positions!r}\n{sorted_text}"
        )


if __name__ == "__main__":
    main()
