#import "../layouts/document.typ": page-style
#import "../utils/typography.typ": fonts, size, rhythm

#let symbols(entries: (), body: none) = {
  page-style(numbering: "I", header: [符号说明])[
    #heading(numbering: none, outlined: false)[符号说明]
    #set text(font: fonts.song + fonts.en, size: size.wu)
    #set par(
      first-line-indent: rhythm.no-indent,
      leading: rhythm.compact-leading,
      spacing: rhythm.compact-spacing,
      justify: true,
    )
    #if body != none {
      body
      parbreak()
    }
    #if entries.len() > 0 {
      table(
        columns: (1fr, 4fr),
        stroke: 0.5pt + gray,
        inset: 6pt,
        table.header(
          [#text(font: fonts.hei)[符号]],
          [#text(font: fonts.hei)[说明]],
        ),
        ..entries.map(e => (e.at(0), e.at(1))).flatten()
      )
    }
    #pagebreak()
  ]
}
