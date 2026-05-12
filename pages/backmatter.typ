#import "../layouts/document.typ": page-style
#import "../utils/typography.typ": fonts, size, rhythm, bibliography-style

#let references(items: (), bib: none, style: bibliography-style, full: false) = {
  page-style(numbering: "1", header: [参考文献])[
    #show heading.where(level: 1): it => {
      block(above: 24pt, below: 18pt, breakable: false, width: 100%)[
        #set par(first-line-indent: rhythm.no-indent, leading: rhythm.heading-leading, spacing: rhythm.no-spacing, justify: false)
        #align(center)[
          #text(font: fonts.hei-cn, size: size.san, weight: "bold", stroke: 0.2pt, cjk-latin-spacing: none)[#it.body]
        ]
      ]
    }
    #heading(numbering: none, outlined: true)[参考文献]
    #set text(font: fonts.song + fonts.en, size: size.wu)
    #set par(
      first-line-indent: rhythm.no-indent,
      hanging-indent: 2em,
      leading: rhythm.compact-leading,
      spacing: rhythm.compact-leading,
    )
    #set block(above: 0pt, below: 0pt, spacing: rhythm.compact-leading)
    #if bib != none {
      block(width: 100%, above: 0pt, below: 0pt, breakable: true)[
        #bibliography("../" + bib, title: none, style: style, full: full)
      ]
    } else {
      for (index, item) in items.enumerate() {
        item.at("label")
        h(0.8em)
        item.at("body")
        if index + 1 < items.len() {
          parbreak()
        }
      }
    }
  ]
}

#let appendix(title, body) = {
  pagebreak()
  page-style(numbering: "1", header: title)[
    #heading(numbering: none, outlined: true)[#title]
    #body
  ]
}

#let acknowledgements(body) = {
  pagebreak()
  page-style(numbering: "1", header: [致谢])[
    #heading(numbering: none, outlined: true)[致谢]
    #set text(font: fonts.fang, size: size.xiaosi)
    #set par(
      first-line-indent: rhythm.body-indent,
      leading: rhythm.body-leading,
      spacing: rhythm.body-spacing,
      justify: true,
    )
    #body
  ]
}

#let cv-and-publications(body) = {
  pagebreak()
  page-style(numbering: "1", header: [个人简历、在读期间发表的学术成果])[
    #heading(numbering: none, outlined: true)[个人简历、在读期间发表的学术成果]
    #set text(font: fonts.song + fonts.en, size: size.wu)
    #set par(
      first-line-indent: rhythm.no-indent,
      leading: rhythm.compact-leading,
      spacing: rhythm.compact-spacing,
      justify: true,
    )
    #body
  ]
}
