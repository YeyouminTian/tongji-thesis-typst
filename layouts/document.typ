#import "@preview/itemize:0.2.0" as el
#import "@preview/i-figured:0.2.4" as i-figured
#import "../utils/typography.typ": fonts, size, rhythm
#import "../utils/metadata.typ": get
#import "../utils/heading.typ": current-heading, heading-numbering, heading-text

#let page-style(numbering: none, header: current-heading(), header-font: fonts.song, body) = {
  set page(
    paper: "a4",
    margin: (
      top: 2.54cm,
      bottom: 2.54cm,
      left: 3.17cm,
      right: 3.17cm,
    ),
    header-ascent: 0.54cm,
    footer-descent: 0.54cm,
    header: if header == none {
      none
    } else {
      block(width: 100%)[
        #align(center, text(font: header-font, size: size.wu)[#header])
        #v(2pt)
        #line(length: 100%, stroke: 0.5pt)
      ]
    },
    footer: if numbering == none {
      none
    } else {
      align(center, text(font: fonts.song, size: size.wu)[
        #context counter(page).display(numbering)
      ])
    },
  )

  body
}

#let tongji-thesis(info: (:), body) = {
  set document(title: get(info, "title"), author: get(info, "author"))
  set text(
    font: fonts.song + fonts.en,
    size: size.xiaosi,
    lang: "zh",
    region: "cn",
    top-edge: 0.7em,
    bottom-edge: -0.3em,
    cjk-latin-spacing: none,
  )
  set par(
    justify: true,
    first-line-indent: rhythm.body-indent,
    leading: rhythm.body-leading,
    spacing: rhythm.body-spacing,
  )
  set heading(numbering: heading-numbering)
  show: el.default-enum-list
  show heading: i-figured.reset-counters
  show math.equation.where(block: true): i-figured.show-equation
  set figure(gap: 6pt)
  show figure.where(kind: table): set figure(gap: 12pt)
  show figure.where(kind: table): set figure.caption(position: top)
  set figure.caption(separator: h(1em))

  let _auto-figure-kind(kind) = type(kind) == str and kind.starts-with("i-figured-")
  let _figure-kind-name(kind) = if type(kind) == str { kind } else { repr(kind) }
  let _caption-before = 6pt
  let _caption-after = 12pt

  show figure: it => {
    if _auto-figure-kind(it.kind) {
      it
    } else {
      let kind-name = _figure-kind-name(it.kind)
      block(
        width: 100%,
        above: rhythm.body-spacing + if kind-name == "table" { _caption-before } else { 0pt },
        below: rhythm.body-spacing + if kind-name == "table" { 0pt } else { _caption-after },
      )[
        #i-figured.show-figure(it)
      ]
    }
  }

  show figure.caption: it => {
    set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.no-spacing)
    align(center)[#text(font: fonts.song + fonts.en, size: size.wu)[#it]]
  }

  show heading.where(level: 1): it => {
    block(above: 24pt, below: 18pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.heading-leading, spacing: rhythm.no-spacing, justify: false)
      #align(center)[
        #text(font: fonts.hei-cn, size: size.san, stroke: 0.2pt, cjk-latin-spacing: none)[
          #heading-text(it)
        ]
      ]
    ]
  }

  show heading.where(level: 2): it => {
    block(above: 24pt, below: 18pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.heading-leading, spacing: rhythm.no-spacing, justify: false)
      #text(font: fonts.hei-cn, size: size.xiaosan, cjk-latin-spacing: none)[#heading-text(it)]
    ]
  }

  show heading.where(level: 3): it => {
    block(above: 24pt, below: 18pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.heading-leading, spacing: rhythm.no-spacing, justify: false)
      #text(font: fonts.hei-cn, size: size.si, cjk-latin-spacing: none)[#heading-text(it)]
    ]
  }

  show heading.where(level: 4): it => {
    block(above: 24pt, below: 18pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.heading-leading, spacing: rhythm.no-spacing, justify: false)
      #text(font: fonts.hei-cn, size: size.xiaosi, cjk-latin-spacing: none)[#heading-text(it)]
    ]
  }

  show table.cell: set text(size: size.wu)

  // 三线表格式：顶线1pt，表头下0.5pt，底线1pt
  set table(
    stroke: (_, y) => (
      top: if y == 0 { 1pt } else if y == 1 { 0.5pt } else { 0pt },
      bottom: if y == 0 { 0.5pt } else { 1pt },
    ),
  )

  body
}
