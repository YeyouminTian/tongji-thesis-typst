#import "../layouts/document.typ": page-style
#import "../utils/typography.typ": fonts, size, rhythm
#import "../utils/metadata.typ": joined
#import "../utils/heading.typ": heading-text

#let abstract-cn(keywords: (), body) = {
  page-style(numbering: "I", header: [摘要], top-margin: 3.459cm, header-ascent: 0.929cm, footer-descent: 0.69cm)[
    #heading(numbering: none, outlined: false)[摘要]
    #v(17pt)
    #set par(
      justify: true,
      first-line-indent: rhythm.body-indent,
      leading: rhythm.body-leading,
      spacing: rhythm.body-spacing,
    )
    #block(width: 100%)[#body]
    #parbreak()
    #set par(first-line-indent: rhythm.body-indent, leading: rhythm.body-leading, spacing: rhythm.no-spacing)
    #text(font: fonts.song, size: size.xiaosi, weight: "bold")[关键词：]
    #text(font: fonts.song, size: size.xiaosi)[#joined(keywords)]
    #pagebreak()
  ]
}

#let abstract-en(keywords: (), body) = {
  page-style(numbering: "I", header: [Abstract], header-font: fonts.en, top-margin: 3.385cm, header-ascent: 0.855cm, footer-descent: 0.69cm)[
    #show heading.where(level: 1): it => {
      block(above: 24pt, below: 0pt, breakable: false, width: 100%)[
        #set par(first-line-indent: rhythm.no-indent, leading: rhythm.heading-leading, spacing: rhythm.no-spacing, justify: false)
        #align(center)[
          #text(font: fonts.arial, size: size.san, weight: "bold", cjk-latin-spacing: none)[
            #heading-text(it)
          ]
        ]
      ]
    }
    #heading(numbering: none, outlined: false)[ABSTRACT]
    #v(28pt)
    #set text(font: fonts.en, size: size.xiaosi, lang: "en")
    #set par(
      first-line-indent: rhythm.body-indent,
      leading: rhythm.body-leading,
      spacing: rhythm.body-spacing,
      justify: true,
    )
    #body
    #parbreak()
    #text(font: fonts.en, size: size.xiaosi, weight: "bold")[Key Words: ]
    #text(font: fonts.en, size: size.xiaosi)[#joined(keywords, sep: ", ")]
    #pagebreak()
  ]
}
