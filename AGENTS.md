# AGENTS.md

This file provides guidance to Codex (Codex.ai/code) when working with code in this repository.

## Project Overview

A Typst template for Tongji University graduate theses (同济大学研究生学位论文模板). Supports both master's and doctoral dissertations with full Chinese/English bilingual formatting.

## Build Commands

### Full Thesis Compilation
```bash
# Via script
./scripts/build.sh

# Direct compilation
typst compile thesis.typ thesis.pdf
```

### Single-Chapter Preview (for quick iteration)
```bash
# Compile a single chapter for faster preview
./scripts/compile-chapter.sh chapter1 chapter1.pdf

# The script creates a temporary entry point that includes only the specified chapter
```

### Full Preview Entry Point
```bash
# Alternative entry for full preview
typst compile full-preview.typ full-preview.pdf
```

## Architecture Overview

### Module Hierarchy

```
lib.typ                 # Public API - all exports centralized here
├── layouts/
│   ├── document.typ    # Root document template (tongji-thesis function)
│   ├── matter.typ      # Frontmatter/mainmatter/backmatter switches
│   └── declarations.typ # Originality statements and copyright
├── pages/
│   ├── cover.typ       # Chinese/English covers and spine
│   ├── abstract.typ    # Chinese/English abstracts
│   ├── outline.typ     # Table of contents
│   └── backmatter.typ  # References, appendix, acknowledgements
└── utils/
    ├── typography.typ  # Font stacks, sizes, baseline rhythm
    ├── heading.typ     # Heading numbering and formatting
    ├── text.typ        # Text utilities (bold with stroke, etc.)
    ├── caption.typ     # Figure/table caption formatting
    └── metadata.typ    # Date/discipline formatting utilities
```

### Entry Points

| File | Purpose |
|------|---------|
| `thesis.typ` | Full thesis compilation - assembles all chapters |
| `full-preview.typ` | Simple wrapper that includes thesis.typ |
| `preview/chapter1.typ` | Single-chapter preview example |
| `tongji-thesis.typ` | Legacy compatibility facade (imports lib.typ) |

### Content Organization

- `chapters/` - Chapter content files (chapter1.typ, chapter2.typ, etc.)
- `appendices/` - Appendix content
- `metadata.typ` - Thesis metadata (title, author, supervisor, etc.)
- `references.bib` - Bibliography database

### Appendix API

Use `#appendix(label: <app:...>)[裸标题][body]` for appendices.
Do not hardcode `附录A` / `附录B` in the title text; the template now generates the appendix prefix automatically in the正文标题、页眉、目录 and `@app:` references.

## Key Configuration

### Font Configuration
Fonts are defined in `utils/typography.typ`:
- **Chinese**: Songti/SimSun (serif), Heiti/SimHei (sans), Kaiti/KaiTi (italic)
- **Heading numbers**: Forced through the strict Heiti stack (`fonts.hei-strict`) with numeric-run size and baseline compensation so Arabic digits in chapter/section prefixes do not fall back to Arial or look smaller than Chinese heading text; Chinese prefix text such as `第` and `章` remains at the heading's base size
- **English**: Times New Roman (serif), Arial (sans)
- **Math**: New Computer Modern Math

### Citation Style
- Uses the vendored `vendor/gb7714-bilingual` engine in selectable GB/T 7714—2015/2025 numeric mode; `metadata.typ` currently selects 2025
- Entry language is read from `references.bib` `language` / `langid` fields, with Chinese-character detection as fallback
- Use `language = {zh-CN}` for Chinese references and `language = {en-US}` for English references so author truncation renders `等` / `et al.` correctly
- Local vendor rules keep English surnames in title case, preserve raw BibTeX casing for display fields such as `title`, `booktitle`, and `journal` so acronyms like `POI` are not normalized to `poi` / `Poi`, and compress numeric citation ranges only for three or more consecutive references (`[1,2]`, `[1-3]`)

### Numbering
- Uses `i-figured` package for chapter-aware figure/table/equation numbering
- Figures: "图 2-1", Tables: "表 2-1", Equations: "(2-1)"
- Inline `@fig:` / `@tbl:` references are handled by the template `show ref` rule so body references match captions and render with body font/size

## Common Tasks

### Adding a New Chapter
1. Create `chapters/chapterN.typ`
2. Import: `#import "../lib.typ": chapter`
3. Start with `#chapter[<标题>]`, then content
4. Add `#include "chapters/chapterN.typ"` to `thesis.typ`

### Modifying Page Layout
- `layouts/document.typ` - Main page setup (margins, headers, footers)
- `layouts/matter.typ` - Matter switching logic
- Margins and page size defined in `tongji-thesis` function

### Adjusting Typography
- `utils/typography.typ` - Font sizes, line spacing, baseline rhythm
- `utils/heading.typ` - Chapter/section heading styles
- `utils/caption.typ` - Figure/table caption formatting

### Word-to-Typst Line Spacing
Word fixed line spacing is a baseline-to-baseline target. The template fixes text edges with `top-edge: 0.7em` and `bottom-edge: -0.3em`, so one line box equals one font-size. Convert fixed Word line spacing with `Typst leading = Word line spacing - font size`.

For small fourth size text, body 20pt line spacing becomes `leading: 8pt`. Body paragraph `spacing` is also `8pt` only to keep cross-paragraph baselines on the same 20pt rhythm; it is not extra paragraph before/after spacing. The visual glyph gap from one body line's bottom to the next line's top is about 8pt. Heading spacing is calibrated against `同济大学研究生学位论文写作参考示例.pdf`: mainmatter chapter pages use `top-margin: 2.868cm` and `header-ascent: 0.338cm` so untitled continuation-page header-rule-to-body-top spacing matches the 8pt visual glyph gap; abstract, contents, and backmatter pages use `top-margin: 3.459cm` and `header-ascent: 0.929cm`, with English abstract using `top-margin: 3.385cm` and `header-ascent: 0.855cm` for its font metrics. When a level-1 or level-2 heading appears directly below the header rule at the top of a page, its glyph top sits 24pt below the header rule. Chapter opening pages insert 16.3pt before the level-1 chapter heading; page-top level-2 heading blocks insert 16.2pt internally because Typst collapses block above-spacing at page top. The header text-to-rule gap is calibrated with the header block spacing in `layouts/document.typ`. Footer page-number height is also calibrated: main/backmatter use `footer-descent: 0.63cm`, while frontmatter uses `footer-descent: 0.69cm`. Chapter heading after-spacing, first-level section heading spacing, first body line, and backmatter title-to-content gaps are verified against the school reference with PDF bounding boxes. Keep chapter body content in the same flow after the chapter heading. Directory entries are independent blocks, so keep `par.spacing: 0pt`; use `par.leading` for wrapped lines inside one entry and the entry block gap for adjacent entries. For small fourth size directory text with an 18pt target rhythm, the entry gap is `18pt - 12pt = 6pt`.

## Bibliography Engine

The template renders BibTeX/BibLaTeX references through the project-local `vendor/gb7714-bilingual` engine instead of the legacy CSL asset. `metadata.typ` exports `bibliography-standard-version` (`"2025"` by default, switchable to `"2015"`), and every Typst entry point must pass that value to `init-gb7714.with(read(...), style: "numeric", version: bibliography-standard-version, show-url: false, show-doi: false)` before using `#references(...)`. The `references(bib: ...)` argument only switches to bibliography-list rendering; the actual BibTeX source comes from `init-gb7714`. Keep `references.bib` entries language-tagged with `language = {zh-CN}` or `language = {en-US}` to preserve per-entry punctuation and bilingual terms. Online/webpage references should use `@online` with `url`, `urldate`, and either `date` or `year`; the webpage renderer always prints the URL as the GB/T 7714 access path, while non-webpage references still obey `show-url: false`. Electronic books/articles/reports should set `medium = {OL}` explicitly. See `docs/gb-t-7714-2025.md` for the 2025 migration rules.

## Development Workflow

1. **Quick iteration**: Use `./scripts/compile-chapter.sh chapterN` for single-chapter preview
2. **Full verification**: Run `./scripts/build.sh` to compile complete thesis
3. **Before commit**: Ensure both full build and chapter preview compile successfully
