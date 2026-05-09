#import "@preview/itemize:0.2.0" as el
#import "../utils/typography.typ": fonts, size, rhythm, bibliography-style
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
    top-edge: "ascender",
    bottom-edge: "descender",
    cjk-latin-spacing: none,
  )
  set par(
    justify: true,
    first-line-indent: rhythm.body-indent,
    leading: rhythm.body-leading,
    spacing: rhythm.body-spacing,
  )
  set cite(style: bibliography-style)
  set heading(numbering: heading-numbering)
  show: el.default-enum-list
  show heading.where(level: 1): it => {
    block(above: 24pt, below: 18pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
      #align(center)[
        #text(font: fonts.hei-cn, size: size.san, stroke: 0.2pt, cjk-latin-spacing: none)[
          #heading-text(it)
        ]
      ]
    ]
  }

  show heading.where(level: 2): it => {
    block(above: 24pt, below: 6pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
      #text(font: fonts.hei-cn, size: size.xiaosan, cjk-latin-spacing: none)[#heading-text(it)]
    ]
  }

  show heading.where(level: 3): it => {
    block(above: 12pt, below: 6pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
      #text(font: fonts.hei-cn, size: size.si, cjk-latin-spacing: none)[#heading-text(it)]
    ]
  }

  show heading.where(level: 4): it => {
    block(above: 12pt, below: 6pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
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
