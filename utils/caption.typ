#import "typography.typ": fonts, size, rhythm

#let figure-caption(title) = {
  block(width: 100%, above: 6pt, below: 12pt)[
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.no-spacing)
    #align(center)[
      #text(font: fonts.song, size: size.wu)[#title]
    ]
  ]
}

#let table-caption(title) = {
  block(width: 100%, above: 6pt, below: 6pt)[
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.no-spacing)
    #align(center)[
      #text(font: fonts.song, size: size.wu)[#title]
    ]
  ]
}
