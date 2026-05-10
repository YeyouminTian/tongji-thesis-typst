# Tongji Graduate Thesis Typst Format Audit

This audit compares the Typst template against:

- `../写作资料/FORMAT-SPEC.md`
- `../写作资料/同济大学研究生学位论文写作参考示例.docx`
- `https://typst.dev/guide/word.html`
- Direct OOXML inspection of the DOCX styles and paragraph properties

LibreOffice is not available locally, so DOCX visual rendering was checked via
Quick Look thumbnails and the Typst output was checked by rendered PNG pages.

## Global Page Setup

| Element | Reference Requirement | Typst Implementation | Status |
| --- | --- | --- | --- |
| Paper | A4 | `paper: "a4"` | Matched |
| Margins | top/bottom 2.54cm, left/right 3.17cm | `page.margin` set to exact values | Matched |
| Header position | header at 2.0cm from top | top margin 2.54cm with `header-ascent: 0.54cm` | Matched |
| Footer position | footer at 1.5cm from bottom | bottom margin 2.54cm with `footer-descent: 1.04cm` | Matched |
| Header text | Songti 10.5pt; English abstract uses Times New Roman 10.5pt | `fonts.song` or `fonts.en`, `size.wu` | Matched |
| Page number | Songti 10.5pt centered | footer uses `fonts.song`, `size.wu` | Matched |
| Page transitions | Structure order should be continuous unless an intentional blank page is inserted | `mainmatter()` and `backmatter()` use weak page breaks to avoid accidental blank pages | Matched |

## Font Tokens

| Element | Reference Requirement | Typst Implementation | Status |
| --- | --- | --- | --- |
| Songti | 宋体 | `("STSong", "Songti SC", "FZQingKeBenYueSongS")` | Matched by local fallback |
| Heiti | 黑体 | `("Heiti SC", "STHeiti", "PingFang SC", "Microsoft YaHei")` | Matched by local fallback |
| Fangsong | 仿宋 | `("STFangsong", "Songti SC")` | Matched if `STFangsong` exists |
| English serif | Times New Roman | `("Times New Roman", "Times", "Libertinus Serif")` | Matched by fallback |
| English sans | Arial | `("Arial", "Helvetica")` | Matched by fallback |

## Cover Pages

| Element | Reference Requirement | Typst Implementation | Status |
| --- | --- | --- | --- |
| Tongji logo | 10.0cm x 2.6cm | extracted DOCX image at `assets/tongji-logo.jpeg`, rendered 10cm x 2.6cm | Matched |
| Chinese thesis type | Lishu 22pt bold centered, single spacing, 0.5-line before | `fonts.li`, `size.er`, cover faux-bold stroke, 8pt gap after logo | Matched visually |
| Chinese degree type | Lishu 16pt bold centered, single spacing | `fonts.li`, `size.san`, cover faux-bold stroke | Matched visually |
| Chinese title | Heiti 22pt bold centered, single spacing | `fonts.hei`, `size.er`, bold | Matched |
| Chinese metadata | Fangsong 16pt, single spacing, 4.5-character indent, label text distributed/aligned | `fonts.fang`, `size.san`; single-column metadata block, left pad `4.5em`; labels up to 4 chars distributed across `4em`, long labels natural width | Matched visually |
| Chinese date | Songti 16pt centered | `fonts.song`, `size.san` | Matched |
| English title | Arial 18pt bold centered | `fonts.arial`, `size.xiaoer`, bold | Matched |
| English metadata | Times New Roman 16pt | `fonts.en`, `size.san` | Matched |
| English date | Times New Roman 16pt centered | `fonts.en`, `size.san` | Matched |
| Cover paragraph behavior | no justification stretching | cover pages set `justify: false` | Matched |

## Spine

| Element | Reference Requirement | Typst Implementation | Status |
| --- | --- | --- | --- |
| Spine text | Fangsong 14pt bold, 16pt line height, before/after 0pt | `thesis-spine()` uses vertical Fangsong 14pt bold text with 2pt row gutter | Matched visually |
| Spine placement | about 5cm blank area before the first text group and after the university name | `thesis-spine()` uses a 27.5cm spine box on a full A4 page, with exact 5cm internal top/bottom spacer rows | Matched visually |
| Spine contents | title, author name, 同济大学 | metadata-driven vertical title, author, university text | Matched |

## Front Matter

| Element | Reference Requirement | Typst Implementation | Status |
| --- | --- | --- | --- |
| Chinese abstract title | Heiti 16pt bold centered, 24pt before, 18pt after | level 1 heading rule | Matched |
| Chinese abstract body | Songti 12pt, first-line indent 2 chars, 20pt line height, before/after 0pt | `fonts.song + fonts.en`, `size.xiaosi`, `body-indent`, fixed text edges, `body-leading: 8pt`, `body-spacing: 8pt` so cross-paragraph baselines stay 20pt apart | Matched |
| Chinese keywords | Songti 12pt, label bold | explicit bold label and normal keyword text | Matched |
| English abstract title | Arial 16pt bold centered, 24pt before, 18pt after | local level 1 heading rule with Arial display and plain outline text | Matched |
| English abstract body | Times New Roman 12pt, 20pt line height, before/after 0pt | `fonts.en`, `size.xiaosi`, fixed text edges, `body-leading: 8pt`, `body-spacing: 8pt` so cross-paragraph baselines stay 20pt apart | Matched |
| English keywords | Times New Roman 12pt, label bold | explicit bold label and normal keyword text | Matched |
| TOC title | Heiti 16pt bold centered, 24pt before, 18pt after | level 1 heading rule | Matched |
| TOC entries | Songti 12pt, 18pt line height, page numbers right aligned, before/after 0pt | custom outline, `toc-leading: 6pt`, no extra block gap | Matched |
| TOC level 2 indent | left indent 2 chars | `2em` | Matched |
| TOC level 3 indent | left indent 4 chars | `4em` | Matched |
| Symbols body | Songti/TNR 10.5pt, 16pt line height, before/after 0pt | `size.wu`, `compact-leading: 5.5pt`, `compact-spacing: 0pt` | Matched |

## Main Matter

| Element | Reference Requirement | Typst Implementation | Status |
| --- | --- | --- | --- |
| Chapter title | Heiti 16pt bold centered, 24pt before, 18pt after | level 1 heading rule | Matched |
| First-level heading | Heiti 15pt, single spacing, 24pt before, 18pt after | level 2 heading rule | Matched |
| Second-level heading | Heiti 14pt, single spacing, 24pt before, 18pt after | level 3 heading rule | Matched |
| Third-level heading | Heiti 12pt, single spacing, 24pt before, 18pt after | level 4 heading rule | Matched |
| Heading number gap | one character between number and title; no automatic CJK/Latin spacing inside the number | manual heading-number strings, dedicated Heiti number text, `cjk-latin-spacing: none`, then `h(1em)` | Matched |
| Body paragraph | Songti/TNR 12pt, justified, first-line indent 2 chars | global `set text`, `set par`, `body-indent` | Matched |
| Body line height | Word fixed 20pt | Typst fixes text edges to `0.7em/-0.3em` and uses `body-leading: 8pt` for 12pt text, i.e. 20pt baseline rhythm | Matched |
| Paragraph boundary | Word before/after 0pt | Typst uses `body-spacing: body-leading`; this is not extra Word paragraph spacing, it keeps the paragraph boundary on the same 20pt baseline rhythm as normal line breaks | Matched |
| Figure caption | Songti 10.5pt centered, 6pt before, 12pt after | `figure-caption()` block | Matched |
| Table caption | Songti 10.5pt centered, 6pt before, 6pt after | `table-caption()` block | Matched |

## Back Matter

| Element | Reference Requirement | Typst Implementation | Status |
| --- | --- | --- | --- |
| References title | same as chapter title | level 1 heading rule | Matched |
| Reference body | Songti/TNR 10.5pt, hanging indent 2 chars, 16pt line height, before/after 0pt | `size.wu`, `hanging-indent: 2em`, `compact-leading: 5.5pt`, `compact-spacing: 0pt`; supports `.bib` with `gb-7714-2015-numeric` | Matched |
| Appendix body | same as main body | inherits global body settings | Matched |
| Acknowledgements title | same as chapter title | level 1 heading rule | Matched |
| Acknowledgements body | Fangsong 12pt, first-line indent 2 chars, 20pt line height | `fonts.fang`, `size.xiaosi`, body paragraph rhythm | Matched visually |
| CV/publications title | same as chapter title | level 1 heading rule | Matched |
| CV/publications body | Songti/TNR 10.5pt, 16pt line height | `size.wu`, exact compact rhythm | Matched |
| Originality/copyright title | DOCX uses Heiti 18pt bold centered | `_statement-title()` uses Heiti 18pt bold centered | Matched visually |
| Originality/copyright body | DOCX uses Songti 14pt with automatic line spacing | `_statement-body()` uses Songti 14pt with 18pt line rhythm and no extra paragraph spacing | Matched visually |

## Notes

- Typst `leading` and paragraph `spacing` are not identical to Word's fixed
  line height and before/after settings. Fixed line height is implemented as
  `leading = line height - font size`; Word paragraph before/after `0pt` is
  implemented by keeping the same baseline rhythm across paragraph boundaries,
  so body `par.spacing` equals body `par.leading`.
- The reference list can be generated from BibTeX/BibLaTeX through Typst
  `bibliography(..., style: "gb-7714-2015-numeric")`, while the previous manual
  `items` fallback remains available for small static lists.
- Typst automatically inserts CJK/Latin spacing in mixed Chinese-number text.
  It is disabled for thesis headings and the TOC so `第1章` matches the DOCX
  instead of rendering as `第 1 章`.
- The Word sample contains some direct formatting that differs slightly from
  the guide in declaration pages. The template currently follows the guide for
  those pages and keeps the layout editable.
- Figure, table, and formula numbering are still manual helpers in the sample.
  They can be upgraded later to automatic chapter-aware counters.
