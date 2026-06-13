#import "../vendor/gb7714-bilingual/lib.typ": gb7714-bibliography
#import "../layouts/document.typ": page-style
#import "../utils/typography.typ": fonts, size, rhythm

#let references(items: (), bib: none, full: false) = {
  page-style(numbering: "1", header: [参考文献], top-margin: 3.459cm, header-ascent: 0.929cm)[
    #show heading.where(level: 1): it => {
      block(above: 24pt, below: 0pt, breakable: false, width: 100%)[
        #set par(first-line-indent: rhythm.no-indent, leading: rhythm.heading-leading, spacing: rhythm.no-spacing, justify: false)
        #align(center)[
          #text(font: fonts.hei-cn, size: size.san, weight: "bold", stroke: 0.2pt, cjk-latin-spacing: none)[#it.body]
        ]
      ]
      v(15.8pt)
    }
    #heading(numbering: none, outlined: true)[参考文献]
    #v(12.7pt)
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
        #gb7714-bibliography(title: none, full: full)
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

#let appendix(title, body, label: none) = {
  pagebreak()
  counter("appendix").step()
  page-style(numbering: "1", header: title, top-margin: 3.459cm, header-ascent: 0.929cm)[
    #heading(numbering: none, outlined: true)[#title]#if label != none { label }
    #body
  ]
}

#let acknowledgements(body) = {
  pagebreak()
  page-style(numbering: "1", header: [致谢], top-margin: 3.459cm, header-ascent: 0.929cm)[
    #heading(numbering: none, outlined: true)[致谢]
    #v(15.2pt)
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
  page-style(numbering: "1", header: [个人简历、在读期间发表的学术成果], top-margin: 3.459cm, header-ascent: 0.929cm)[
    #heading(numbering: none, outlined: true)[个人简历、在读期间发表的学术成果]
    #v(13.1pt)
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
