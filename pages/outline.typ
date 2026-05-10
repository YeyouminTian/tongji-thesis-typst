#import "../layouts/document.typ": page-style
#import "../utils/typography.typ": fonts, size, rhythm
#import "../utils/heading.typ": format-heading-number

#let outline(depth: 3) = context {
  let elements = query(heading.where(outlined: true))
  let first-numbered-index = none

  for (idx, el) in elements.enumerate() {
    if first-numbered-index == none and el.numbering != none {
      first-numbered-index = idx
    }
  }

  for (idx, el) in elements.enumerate() {
    if depth != none and el.level > depth {
      continue
    }

    let indent = if el.level == 1 {
      0pt
    } else if el.level == 2 {
      2em
    } else if el.level == 3 {
      4em
    } else {
      0pt
    }

    let is-frontmatter = first-numbered-index == none or idx < first-numbered-index
    let page-number = counter(page).at(el.location()).first()
    let page-label = if is-frontmatter {
      numbering("I", page-number)
    } else {
      numbering("1", page-number)
    }
    let nums = counter(heading).at(el.location())
    let heading-number = if el.numbering != none {
      format-heading-number(el.level, nums)
    } else {
      []
    }

    block(width: 100%, above: 0pt, below: 0pt)[
      #set text(font: fonts.song + fonts.en, size: size.xiaosi, top-edge: 0.7em, bottom-edge: -0.3em)
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.toc-leading, spacing: rhythm.no-spacing, justify: false)
      #h(indent)
      #if heading-number != [] {
        link(el.location(), [ ] + heading-number + [ ])
      }
      #link(el.location(), el.body)
      #box(width: 1fr, inset: (x: 0.25em), repeat([.], gap: 0.15em))
      #link(el.location(), page-label)
    ]
  }
}

#let table-of-contents() = {
  page-style(numbering: "I", header: [目录])[
    #heading(numbering: none, outlined: false)[目录]
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.toc-leading, spacing: rhythm.no-spacing, justify: false)
    #outline(depth: 3)
    #pagebreak()
  ]
}
