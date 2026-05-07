// Tongji University graduate thesis template helpers for Typst 0.14+.
// The rules are based on the 2025-10 graduate thesis writing guide.

#import "@preview/pointless-size:0.1.2": zh
#import "@preview/itemize:0.2.0" as el

#let fonts = (
  song: ("Times New Roman", "STSong", "Songti SC", "FZQingKeBenYueSongS"),
  hei: ( "Hei", "STHeiti", "PingFang SC", "Microsoft YaHei"),
  hei-cn: ("Hei", "STHeiti", "PingFang SC", "Microsoft YaHei"),
  fang: ("Times New Roman", "STFangsong", "Songti SC"),
  li: ("Libian SC", "Baoli SC", "Kaiti SC", "STKaiti"),
  kai: ("Times New Roman", "Kaiti SC", "STKaiti", "KaiTi"),
  en: ("Times New Roman", "Times", "Libertinus Serif"),
  arial: ("Arial", "Helvetica"),
)

#let size = (
  xiaoer: zh(-2),
  er: zh(2),
  san: zh(3),
  xiaosan: zh(-3),
  si: zh(4),
  xiaosi: zh(-4),
  wu: zh(5),
)

#let _fixed-leading(font-size, line-height) = line-height - font-size
#let bibliography-style = "gb-7714-2015-numeric"

#let rhythm = (
  body-indent: (amount: 2em, all: true),
  no-indent: 0pt,
  // Word fixed line height maps to Typst as `leading = line height - font size`.
  body-leading: _fixed-leading(size.xiaosi, 20pt),
  toc-leading: _fixed-leading(size.xiaosi, 18pt),
  compact-leading: _fixed-leading(size.wu, 16pt),
  cover-leading: 0pt,
  statement-leading: _fixed-leading(size.si, 18pt),
  single-leading: 0.65em,
  body-spacing: 0.65em,
  compact-spacing: 0pt,
  statement-spacing: 0pt,
  no-spacing: 0pt,
)

#let _get(info, key, default: "") = {
  info.at(key, default: default)
}

#let _thesis-kind(info) = {
  let degree = _get(info, "degree", default: "硕士")
  if degree == "博士" {
    "博士学位论文"
  } else {
    "硕士学位论文"
  }
}

#let _degree-type(info) = {
  let degree-type = _get(info, "degree_type", default: "学术学位")
  if degree-type == "" {
    none
  } else {
    [（#degree-type）]
  }
}

#let _joined(values, sep: "，") = {
  if values == none or values.len() == 0 {
    ""
  } else {
    values.join(sep)
  }
}

#let _chapter-state = state("chapter-number", 0)

#let _heading-numbering(..nums) = {
  let nums = nums.pos()
  if nums.len() == 1 {
    str(nums.at(0))
  } else {
    nums.map(n => str(n)).join(".")
  }
}

#let _format-heading-number(level, nums) = {
  if nums.len() == 0 {
    []
  } else if level == 1 {
    "第" + str(nums.at(0)) + "章"
  } else {
    nums.slice(0, calc.min(level, nums.len())).map(n => str(n)).join(".")
  }
}

#let _heading-number-text(number) = {
  text(font: fonts.hei-cn, cjk-latin-spacing: none)[#number]
}

#let _heading-text(it) = {
  let prefix = if it.numbering == none {
    none
  } else {
    context _format-heading-number(it.level, counter(heading).get())
  }

  if prefix == none {
    it.body
  } else {
    [#_heading-number-text(prefix)#h(0.3em)#it.body]
  }
}

#let _current-heading() = context {
  let headings = query(selector(heading.where(level: 1)).before(here()))
  if headings.len() == 0 {
    []
  } else {
    let h = headings.last()
    let nums = counter(heading).at(h.location())
    let number = _format-heading-number(1, nums)
    if h.numbering != none and number != [] {
      [#number #h.body]
    } else {
      h.body
    }
  }
}

#let _page-style(numbering: none, header: _current-heading(), header-font: fonts.song, body) = {
  set page(
    paper: "a4",
    margin: (
      top: 2.54cm,
      bottom: 2.54cm,
      left: 3.17cm,
      right: 3.17cm,
    ),
    header-ascent: 0.54cm,
    footer-descent: 1.04cm,
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
  set document(title: _get(info, "title"), author: _get(info, "author"))
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
  set heading(numbering: _heading-numbering)
  show: el.default-enum-list
  show heading.where(level: 1): it => {
    block(above: 24pt, below: 18pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
      #align(center)[
        #text(font: fonts.hei-cn, size: size.san, weight: "bold", cjk-latin-spacing: none)[
          #_heading-text(it)
        ]
      ]
    ]
  }

  show heading.where(level: 2): it => {
    block(above: 24pt, below: 6pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
      #text(font: fonts.hei-cn, size: size.xiaosan, cjk-latin-spacing: none)[#_heading-text(it)]
    ]
  }

  show heading.where(level: 3): it => {
    block(above: 12pt, below: 6pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
      #text(font: fonts.hei-cn, size: size.si, cjk-latin-spacing: none)[#_heading-text(it)]
    ]
  }

  show heading.where(level: 4): it => {
    block(above: 12pt, below: 6pt, breakable: false, width: 100%)[
      #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
      #text(font: fonts.hei-cn, size: size.xiaosi, cjk-latin-spacing: none)[#_heading-text(it)]
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

#let _spread-label(label) = {
  let slots = if label == "姓名" {
    ("姓", "", "", "", "", "名", "：")
  } else if label == "学号" {
    ("学", "", "", "", "", "号", "：")
  } else if label == "学院" {
    ("学", "", "", "", "", "院", "：")
  } else if label == "学科门类" {
    ("学", "", "科", "门", "", "类", "：")
  } else if label == "一级学科" {
    ("一", "", "级", "学", "", "科", "：")
  } else if label == "二级学科" {
    ("二", "", "级", "学", "", "科", "：")
  } else if label == "研究方向" {
    ("研", "", "究", "方", "", "向", "：")
  } else if label == "指导教师" {
    ("指", "", "导", "教", "", "师", "：")
  } else if label == "联合培养单位" {
    ("联", "合", "培", "养", "单", "位", "：")
  } else {
    (label, "", "", "", "", "", "：")
  }

  box(width: 7em)[
    #grid(
      columns: (1em, 1em, 1em, 1em, 1em, 1em, 1em),
      column-gutter: 0pt,
      align: center,
      ..slots.map(cell => text(font: fonts.fang, size: size.san)[#cell])
    )
  ]
}

#let _metadata-row(label, value) = {
  (
    _spread-label(label),
    align(left)[#text(font: fonts.fang, size: size.san)[#value]],
  )
}

#let _cover-strong(font, size, body) = {
  text(font: font, size: size, weight: "bold", fill: black, stroke: 0.18pt + black)[#body]
}

#let _logo(info) = {
  let logo = _get(info, "logo", default: none)
  if logo == none {
    box(width: 10cm, height: 2.6cm, stroke: 0.5pt + gray)[
      #align(center + horizon)[
        #text(font: fonts.hei, size: size.san)[同济大学]
      ]
    ]
  } else {
    image(logo, width: 10cm, height: 2.6cm, fit: "contain")
  }
}

#let _vertical-text(value, font: fonts.fang, size: size.si, weight: "bold") = {
  let chars = str(value).clusters()
  grid(
    columns: (1em,),
    row-gutter: 2pt,
    align: center,
    ..chars.map(char => text(font: font, size: size, weight: weight)[#char])
  )
}

#let thesis-spine(info) = {
  set page(paper: "a4", margin: 0cm)
  [
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
    #align(center + horizon)[
      #rect(width: 1.2cm, height: 27.5cm, stroke: 0.8pt + black)[
        #grid(
          columns: (100%,),
          rows: (5cm, auto, 1fr, auto, 1fr, auto, 5cm),
          align: center + horizon,
          [],
          _vertical-text(_get(info, "title", default: "中文论文题目")),
          [],
          _vertical-text(_get(info, "author", default: "姓名")),
          [],
          _vertical-text("同济大学"),
          [],
        )
      ]
    ]
  ]
  pagebreak()
}

#let chinese-cover(info) = {
  _page-style(numbering: none, header: none)[
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.cover-leading, spacing: rhythm.no-spacing, justify: false)

    #v(0.1cm)
    #align(center)[#_logo(info)]

    #v(8pt)
    #align(center)[
      #_cover-strong(fonts.li, size.er, _thesis-kind(info))
      #linebreak()
      #if _degree-type(info) != none {
        _cover-strong(fonts.li, size.san, _degree-type(info))
      }
    ]

    #v(1.15cm)
    #align(center)[
      #block(width: 13.8cm)[
        #align(center)[
          #text(font: fonts.hei, size: size.er, weight: "bold")[
            #_get(info, "title", default: "中文论文题目")
          ]
        ]
      ]
    ]

    #v(2.2cm)
    #pad(left: 4.5em)[
      #grid(
        columns: (7em, 8.5cm),
        rows: auto,
        column-gutter: 0.5em,
        row-gutter: 0.34cm,
        align: horizon,
        ..(
          _metadata-row("姓名", _get(info, "author")),
          _metadata-row("学号", _get(info, "student_id")),
          _metadata-row("学院", _get(info, "school")),
          _metadata-row("学科门类", _get(info, "discipline_category")),
          _metadata-row("一级学科", _get(info, "first_level_discipline")),
          _metadata-row("二级学科", _get(info, "second_level_discipline")),
          _metadata-row("研究方向", _get(info, "research_direction")),
          _metadata-row("指导教师", _get(info, "supervisor")),
          _metadata-row("联合培养单位", _get(info, "joint_training")),
        ).flatten()
      )
    ]

    #v(1fr)
    #align(center)[
      #text(font: fonts.song, size: size.san)[
        #_get(info, "date_zh", default: "二〇二六年五月")
      ]
    ]
  ]
  pagebreak()
}

#let english-cover(info) = {
  _page-style(numbering: none, header: none)[
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.cover-leading, spacing: rhythm.no-spacing, justify: false)

    #v(0.1cm)
    #align(center)[#_logo(info)]

    #v(0.55cm)
    #align(center)[
      #text(font: fonts.en, size: size.si)[
        #if _get(info, "degree", default: "硕士") == "博士" [
          A dissertation submitted to
        ] else [
          A thesis submitted to
        ]
      ]
      #linebreak()
      #text(font: fonts.en, size: size.si)[
        Tongji University in partial fulfillment of the requirements for
      ]
      #linebreak()
      #text(font: fonts.en, size: size.si)[
        the degree of #_get(info, "degree_en", default: "Master")
      ]
    ]

    #v(1.55cm)
    #align(center)[
      #block(width: 14.2cm)[
        #align(center)[
          #text(font: fonts.arial, size: size.xiaoer, weight: "bold")[
            #_get(info, "title_en", default: "English Thesis Title")
          ]
        ]
      ]
    ]

    #v(2.15cm)
    #align(center)[
      #grid(
        columns: (5.8cm, 8.6cm),
        rows: auto,
        column-gutter: 0.2cm,
        row-gutter: 0.31cm,
        align: left,
        text(font: fonts.en, size: size.san)[Candidate:],
        text(font: fonts.en, size: size.san)[#_get(info, "author_en")],
        text(font: fonts.en, size: size.san)[Student Number:],
        text(font: fonts.en, size: size.san)[#_get(info, "student_id")],
        text(font: fonts.en, size: size.san)[School/Department:],
        text(font: fonts.en, size: size.san)[#_get(info, "school_en")],
        text(font: fonts.en, size: size.san)[Categories:],
        text(font: fonts.en, size: size.san)[#_get(info, "discipline_category_en")],
        text(font: fonts.en, size: size.san)[First-level Discipline:],
        text(font: fonts.en, size: size.san)[#_get(info, "first_level_discipline_en")],
        text(font: fonts.en, size: size.san)[Second-level Discipline:],
        text(font: fonts.en, size: size.san)[#_get(info, "second_level_discipline_en")],
        text(font: fonts.en, size: size.san)[Research Fields:],
        text(font: fonts.en, size: size.san)[#_get(info, "research_direction_en")],
        text(font: fonts.en, size: size.san)[Supervisor:],
        text(font: fonts.en, size: size.san)[#_get(info, "supervisor_en")],
      )
    ]

    #v(1fr)
    #align(center)[
      #text(font: fonts.en, size: size.san)[
        #_get(info, "date_en", default: "May 2026")
      ]
    ]
  ]
  pagebreak()
}

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

#let chapter(title, body) = {
  pagebreak(weak: true)
  // 先获取当前章节计数，然后+1作为新章节号
  context {
    let current-nums = counter(heading).get()
    let new-chapter = if current-nums.len() > 0 { current-nums.at(0) + 1 } else { 1 }
    _chapter-state.update(new-chapter)
  }
  _page-style(numbering: "1", header: context {
    [第 #str(_chapter-state.get()) 章#h(1em)#title]
  })[
    #heading(level: 1)[#title]
    #block(width: 100%)[#body]
  ]
}

#let abstract-cn(keywords: (), body) = {
  _page-style(numbering: "I", header: [摘要])[
    #heading(numbering: none, outlined: true)[摘要]
    #set par(
      justify: true,
      first-line-indent: rhythm.body-indent,
      leading: rhythm.body-leading,
      spacing: rhythm.body-spacing,
    )
    #block(width: 100%)[#body]
    #parbreak()
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.body-leading, spacing: rhythm.no-spacing)
    #text(font: fonts.song, size: size.xiaosi, weight: "bold")[关键词：]
    #text(font: fonts.song, size: size.xiaosi)[#_joined(keywords)]
    #pagebreak()
  ]
}

#let abstract-en(keywords: (), body) = {
  _page-style(numbering: "I", header: [Abstract], header-font: fonts.en)[
    #show heading.where(level: 1): it => {
      block(above: 24pt, below: 18pt, breakable: false, width: 100%)[
        #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.single-leading, justify: false)
        #align(center)[
          #text(font: fonts.arial, size: size.san, weight: "bold", cjk-latin-spacing: none)[
            #_heading-text(it)
          ]
        ]
      ]
    }
    #heading(numbering: none, outlined: true)[Abstract]
    #set text(font: fonts.en, size: size.xiaosi, lang: "en")
    #set par(
      first-line-indent: rhythm.no-indent,
      leading: rhythm.body-leading,
      spacing: rhythm.body-spacing,
      justify: true,
    )
    #body
    #parbreak()
    #text(font: fonts.en, size: size.xiaosi, weight: "bold")[Key Words: ]
    #text(font: fonts.en, size: size.xiaosi)[#_joined(keywords, sep: ", ")]
    #pagebreak()
  ]
}

#let _outline(depth: 3) = context {
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
      _format-heading-number(el.level, nums)
    } else {
      []
    }

    block(width: 100%, above: 0pt, below: 0pt)[
      #h(indent)
      #if heading-number != [] {
        link(el.location(), heading-number)
        h(1em)
      }
      #link(el.location(), el.body)
      #box(width: 1fr, h(0.25em) + box(width: 1fr, repeat[·#h(1pt)]) + h(0.25em))
      #link(el.location(), page-label)
    ]
  }
}

#let table-of-contents() = {
  _page-style(numbering: "I", header: [目录])[
    #heading(numbering: none, outlined: false)[目录]
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.toc-leading, spacing: rhythm.no-spacing, justify: false)
    #_outline(depth: 3)
    #pagebreak()
  ]
}

#let symbols(entries: (), body: none) = {
  _page-style(numbering: "I", header: [符号说明])[
    #heading(numbering: none, outlined: true)[符号说明]
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

#let references(items: (), bib: none, style: bibliography-style, full: false) = {
  _page-style(numbering: "1", header: [参考文献])[
    #heading(numbering: none, outlined: true)[参考文献]
    #set text(font: fonts.song + fonts.en, size: size.wu)
    #set par(
      first-line-indent: rhythm.no-indent,
      hanging-indent: 2em,
      leading: rhythm.compact-leading,
      spacing: rhythm.compact-spacing,
    )
    #if bib != none {
      bibliography(bib, title: none, style: style, full: full)
    } else {
      for item in items {
        item.at("label")
        h(0.8em)
        item.at("body")
        parbreak()
      }
    }
  ]
}

#let _statement-title(title) = {
  block(width: 100%, above: 0pt, below: 16pt, breakable: false)[
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.no-spacing)
    #align(center)[
      #text(font: fonts.hei, size: size.xiaoer, weight: "bold")[#title]
    ]
  ]
}

#let _statement-body(body) = {
  set text(font: fonts.song + fonts.en, size: size.si)
  set par(
    first-line-indent: rhythm.body-indent,
    leading: rhythm.statement-leading,
    spacing: rhythm.statement-spacing,
    justify: true,
  )
  body
}

#let appendix(title, body) = {
  pagebreak()
  _page-style(numbering: "1", header: title)[
    #heading(numbering: none, outlined: true)[#title]
    #body
  ]
}

#let acknowledgements(body) = {
  pagebreak()
  _page-style(numbering: "1", header: [致谢])[
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
  _page-style(numbering: "1", header: [个人简历、在读期间发表的学术成果])[
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

#let originality-statement(info) = {
  pagebreak()
  _page-style(numbering: "1", header: [同济大学学位论文原创性声明])[
    #_statement-title[同济大学学位论文原创性声明]
    #_statement-body[
      本人郑重声明：所呈交的学位论文《#_get(info, "title")》，是本人在导师指导下，
      独立进行研究工作所取得的成果。除文中已经注明引用的内容外，本学位论文的研究成果
      不包含任何他人创作的、已公开发表或者没有公开发表的作品的内容。对本论文所涉及的
      研究工作做出贡献的其他个人和集体，均已在文中以明确方式标明。本学位论文原创性声明
      的法律责任由本人承担。
    ]

    #v(1.2cm)
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.statement-leading, spacing: rhythm.no-spacing)
    #align(right)[#text(font: fonts.song, size: size.si, weight: "bold")[学位论文作者签名：#h(6em)]]
    #v(0.4cm)
    #align(right)[#text(font: fonts.song, size: size.si, weight: "bold")[日期：#h(2em)年#h(2em)月#h(2em)日]]
  ]
}

#let copyright-authorization() = {
  pagebreak()
  _page-style(numbering: "1", header: [同济大学学位论文版权使用授权书])[
    #_statement-title[同济大学学位论文版权使用授权书]
    #_statement-body[
      本人完全了解同济大学关于收集、保存、使用学位论文的规定，同意如下各项内容：
      按照学校要求提交学位论文的印刷本和电子版；学校有权保存论文的印刷本和电子版，
      并采用影印、缩印、扫描、数字化或其它手段保存论文；学校有权提供目录检索以及提供
      本论文全文或部分的阅览服务；学校有权按有关规定向国家有关部门或机构送交论文的
      复印件和电子版；允许论文被查阅和借阅。学校有权将本论文的全部或部分内容授权编入
      有关数据库出版传播。

      #text(weight: "bold")[本学位论文属于（在以下方框内打“√”）：]

      #text(weight: "bold")[□ 保密，在\_\_\_\_\_年解密后适用本授权书。]

      #text(weight: "bold")[□ 不保密。]
    ]

    #v(1.1cm)
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.statement-leading, spacing: rhythm.no-spacing, justify: false)
    #grid(
      columns: (1fr, 1fr),
      rows: auto,
      column-gutter: 3em,
      row-gutter: 0.45cm,
      text(font: fonts.song, size: size.si, weight: "bold")[学位论文作者签名：],
      text(font: fonts.song, size: size.si, weight: "bold")[指导教师签名：],
      text(font: fonts.song, size: size.si, weight: "bold")[日期：#h(2em)年#h(2em)月#h(2em)日],
      text(font: fonts.song, size: size.si, weight: "bold")[日期：#h(2em)年#h(2em)月#h(2em)日],
    )
  ]
}
