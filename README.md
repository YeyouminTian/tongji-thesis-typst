# Tongji Graduate Thesis Template

This folder is for building a reusable thesis template based on the Tongji
University graduate thesis writing guide and reference example.

## Source Documents

- `../写作资料/同济大学研究生学位论文写作参考指南.doc`
- `../写作资料/同济大学研究生学位论文写作参考示例.doc`
- The same folder also contains `.docx` versions, which are easier to inspect
  for style and layout details.
- Typst Word migration guide: `https://typst.dev/guide/word.html`.

## Key Format Requirements Read From The Guide

- Paper: A4, white page.
- Margins: top/bottom `2.54cm`, left/right `3.17cm`, header `2.0cm`,
  footer `1.5cm`, gutter `0cm`.
- Main sequence: Chinese cover, English cover, Chinese abstract, English
  abstract, table of contents, symbols, chapters, references, appendix,
  acknowledgements, CV and publications, originality statement, copyright
  authorization.
- Page headers start from the Chinese abstract and use the current section or
  chapter title.
- Page numbers: front matter uses uppercase Roman numerals; main text starts
  from chapter 1 with Arabic numerals.
- Body text: Songti, small fourth size, justified, first-line indent 2 Chinese
  characters, fixed line height 20pt. Paragraph boundaries keep the same 20pt
  baseline rhythm as normal line breaks, with no additional Word-style
  before/after paragraph spacing.
- Chapter title: Heiti, third size, bold, centered, single line spacing,
  24pt before and 18pt after.
- First-level heading: Heiti, small third size, single line spacing, 24pt
  before and 18pt after.
- Second-level heading: Heiti, fourth size, single line spacing, 24pt before
  and 18pt after.
- Third-level heading: Heiti, small fourth size, single line spacing, 24pt
  before and 18pt after.
- Figure captions: below figures, Songti fifth size, centered, 6pt before and
  12pt after.
- Table captions: above tables, Songti fifth size, centered, 6pt before and
  12pt after.
- Distances between body text and figure/table components are additive: the
  normal body paragraph rhythm is retained and caption before/after spacing is
  added on top of it.
- References: title in bold Heiti third size, centered with single spacing, 24pt
  before and 18pt after; entries in Songti/Times New Roman fifth size, hanging
  indent 2 characters, 16pt line height, and adjacent entries kept on the same
  Word-style 16pt line rhythm, GB/T 7714 numeric bibliography style.
- Acknowledgements: FangSong small fourth size, justified, first-line indent
  2 characters, line height 20pt.

## Project Structure

- `thesis.typ`: sample thesis entry point.
- `metadata.typ`: thesis metadata such as title, author, school, supervisor,
  discipline, and date.
- `lib.typ`: public template API. New documents and chapter files should import
  from this file.
- `tongji-thesis.typ`: compatibility facade that re-exports `lib.typ` for older
  documents.
- `utils/`: reusable low-level helpers.
  - `typography.typ`: font stacks, Chinese字号, rhythm, line-height constants,
    and bibliography style.
  - `metadata.typ`: metadata lookup and text joining helpers.
  - `heading.typ`: heading numbering, current-heading lookup, and chapter state.
  - `text.typ`: cover label spreading, emphasized cover text, and vertical text.
  - `caption.typ`: legacy caption helpers retained for compatibility; new
    content should use Typst `figure(...)` syntax.
- `layouts/`: document structure and layout rules.
  - `document.typ`: global `tongji-thesis` show rule and page style.
  - `matter.typ`: front matter, main matter, back matter, and chapter wrapper.
  - `declarations.typ`: originality and copyright declaration layouts.
- `pages/`: concrete page templates.
  - `cover.typ`: Chinese cover, English cover, and spine.
  - `abstract.typ`: Chinese and English abstracts.
  - `outline.typ`: custom table of contents.
  - `symbols.typ`: symbol explanation page.
  - `backmatter.typ`: references, appendix, acknowledgements, and CV pages.
- `references.bib`: sample bibliography database used by the GB/T 7714
  reference list.
- `FORMAT-AUDIT.md`: element-by-element comparison between the guide, DOCX
  reference, and this Typst implementation.
- `chapters/`: chapter files included by `thesis.typ`.
- `preview/`: optional preview entry points for compiling individual chapters
  with the same template wrapper.
- `appendices/`: appendix files can be added here.
- `assets/`: logo, figures, and other thesis assets. `tongji-logo.jpeg` is the
  10.0cm x 2.6cm logo image extracted from the graduate thesis reference DOCX.
- `scripts/build.sh`: local build script for the full thesis. It uses `typst`
  from PATH first, then falls back to
  `/Users/tianye/Downloads/typst-aarch64-apple-darwin/typst`.
- `scripts/compile-chapter.sh`: compile a single chapter preview PDF from a
  chapter stem such as `chapter1`.

## Importing the Template

Use `lib.typ` for new files:

```typst
#import "lib.typ": *
```

Chapter files should import only what they use, for example:

```typst
#import "../lib.typ": chapter
```

When changing styles, edit the layered source files under `utils/`, `layouts/`,
or `pages/`. `tongji-thesis.typ` is only a compatibility facade.

## Build

From this folder, compile the full thesis with:

```bash
./scripts/build.sh
```

The script compiles `thesis.typ` to `thesis.pdf`.

For writing and layout preview of a single chapter, compile the checked-in
chapter 1 preview entry point with:

```bash
typst compile --root . preview/chapter1.typ chapter1-preview.pdf
```

Or compile any chapter file by stem with:

```bash
./scripts/compile-chapter.sh chapter1
./scripts/compile-chapter.sh chapter1 /tmp/chapter1-preview.pdf
```

Single-chapter output is only for writing and layout preview, not final
submission. Cross-references, page numbers, and chapter-aware numbering may
therefore differ from the full thesis output.

## Current Template Coverage

- Chinese cover and English cover.
- Chinese abstract and English abstract.
- Table of contents.
- Symbol table.
- Main matter with chapter headings.
- Automatic chapter-aware numbering for figures, tables, and block equations.
- Native Typst `figure(...)` syntax for images and graphics, and
  `figure(table(...), caption: ...)` for tables.
- References, appendix, acknowledgements, CV/publications, originality
  statement, and copyright authorization.
- BibTeX/BibLaTeX bibliography input via `#references(bib: "references.bib")`,
  using Typst's `gb-7714-2015-numeric` style. The manual `items` fallback is
  still supported.

Figures, tables, and formulas are labeled without prefixes at the definition
site, for example `<tech-route>` or `<format-params>`. References use the
auto-generated prefixes from `i-figured`: `@fig:tech-route`,
`@tbl:format-params`, and `@eqt:example-model`.

## Technology Recommendation

Recommended path: Typst first, with Word as the final submission fallback.

Reason:

- Typst is simpler to write and maintain than LaTeX for a custom thesis
  template, especially for Chinese prose-heavy chapters.
- The Tongji template requirements are mostly page geometry, font styles,
  headings, captions, headers, page numbering, and fixed front matter; Typst is
  strong enough for these.
- LaTeX is still better if the thesis has heavy equations, theorem
  environments, complex cross-references, or a department already accepts a
  maintained Tongji LaTeX class.
- Word is safest for final institutional compliance because the official
  examples are Word documents, but it is weaker for long-term version control,
  repeatable builds, and batch formatting.

Current local environment note:

- `typst` is available at `/opt/homebrew/bin/typst` on 2026-05-07.
- `xelatex`, `latexmk`, `pandoc`, and `soffice` were not found in PATH during
  the initial setup check.
- The build script uses `typst` from PATH first, then falls back to a local
  Downloads binary if present.
