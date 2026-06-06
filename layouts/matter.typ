#import "document.typ": page-style
#import "../utils/heading.typ": chapter-state

#let frontmatter(body) = {
  counter(page).update(1)
  body
}

#let mainmatter(body) = {
  pagebreak(weak: true)
  counter(page).update(1)
  body
}

#let backmatter(body) = {
  pagebreak(weak: true)
  body
}

#let chapter(title, body, label: none) = {
  pagebreak(weak: true)
  // 先获取当前章节计数，然后+1作为新章节号
  context {
    let current-nums = counter(heading).get()
    let new-chapter = if current-nums.len() > 0 { current-nums.at(0) + 1 } else { 1 }
    chapter-state.update(new-chapter)
  }
  page-style(numbering: "1", top-margin: 2.868cm, header-ascent: 0.338cm, header: context {
    [第 #str(chapter-state.get()) 章#h(1em)#title]
  })[
    #v(16.3pt)
    #heading(level: 1)[#title]#if label != none { label }
    #v(8.9pt)
    #body
  ]
}
