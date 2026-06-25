#import "../layouts/document.typ": page-style
#import "../utils/typography.typ": fonts, size, rhythm
#import "../utils/metadata.typ": get, thesis-kind, degree-type
#import "../utils/text.typ": spread-label, cover-strong, vertical-text

#let metadata-line(label, value) = {
  block(width: 100%)[
    #spread-label(label)#text(font: fonts.fang, size: size.san)[#value]
  ]
}

#let logo(info) = {
  let logo = get(info, "logo", default: none)
  if logo == none {
    box(width: 10cm, height: 2.6cm, stroke: 0.5pt + gray)[
      #align(center + horizon)[
        #text(font: fonts.hei, size: size.san)[同济大学]
      ]
    ]
  } else {
    image("../" + logo, width: 10cm, height: 2.6cm, fit: "contain")
  }
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
          vertical-text(get(info, "title", default: "中文论文题目")),
          [],
          vertical-text(get(info, "author", default: "姓名")),
          [],
          vertical-text("同济大学"),
          [],
        )
      ]
    ]
  ]
  pagebreak()
}

#let chinese-cover(info) = {
  page-style(numbering: none, header: none)[
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.cover-leading, spacing: rhythm.no-spacing, justify: false)

    #v(0.1cm)
    #align(center)[#logo(info)]

    #v(8pt)
    #align(center)[
      #cover-strong(fonts.li, size.er, thesis-kind(info))
      #linebreak()
      #if degree-type(info) != none {
        cover-strong(fonts.li, size.san, degree-type(info))
      }
    ]

    #v(1.15cm)
    #align(center)[
      #block(width: 13.8cm)[
        #align(center)[
          #par(leading: 11pt)[
            #text(font: fonts.hei, size: size.er, stroke: 0.4pt)[
              #get(info, "title", default: "中文论文题目")
            ]
          ]
        ]
      ]
    ]

    #v(4cm)
    #align(center)[
      #block(width: 15.8cm)[
        #pad(left: 8.5em)[
          #grid(
            columns: (100%,),
            rows: auto,
            row-gutter: 0.42cm,
            align: left + horizon,
            metadata-line("姓名", get(info, "author")),
            metadata-line("学号", get(info, "student_id")),
            metadata-line("学院", get(info, "school")),
            metadata-line("学科门类", get(info, "discipline_category")),
            metadata-line("一级学科", get(info, "first_level_discipline")),
            metadata-line("二级学科", get(info, "second_level_discipline")),
            metadata-line("研究方向", get(info, "research_direction")),
            metadata-line("指导教师", get(info, "supervisor")),
            metadata-line("联合培养单位", get(info, "joint_training")),
          )
        ]
      ]
    ]

    #v(1fr)
    #align(center)[
      #text(font: fonts.song, size: size.san)[
        #get(info, "date_zh", default: "二〇二六年五月")
      ]
    ]
  ]
  pagebreak()
}

#let english-cover(info) = {
  page-style(numbering: none, header: none)[
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.cover-leading, spacing: rhythm.no-spacing, justify: false)

    #v(0.1cm)
    #align(center)[#logo(info)]

    #v(0.55cm)
    #align(center)[
      #text(font: fonts.en, size: size.si)[
        #if get(info, "degree", default: "硕士") == "博士" [
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
        the degree of #get(info, "degree_en", default: "Master")
      ]
    ]

    #v(1.55cm)
    #align(center)[
      #block(width: 14.2cm)[
        #align(center)[
          #par(leading: 11pt)[
            #text(font: fonts.arial, size: size.xiaoer, weight: "bold")[
              #get(info, "title_en", default: "English Thesis Title")
            ]
          ]
        ]
      ]
    ]

    #v(4.49cm)
    #align(left)[
      #move(dx: 2.95cm)[
        #grid(
          columns: (5.8cm, 8.6cm),
          rows: auto,
          column-gutter: 0.2cm,
          row-gutter: 0.536cm,
          align: left,
          text(font: fonts.en, size: size.san)[Candidate:],
          text(font: fonts.en, size: size.san)[#get(info, "author_en")],
          text(font: fonts.en, size: size.san)[Student Number:],
          text(font: fonts.en, size: size.san)[#get(info, "student_id")],
          text(font: fonts.en, size: size.san)[School/Department:],
          text(font: fonts.en, size: size.san)[#get(info, "school_en")],
          text(font: fonts.en, size: size.san)[Categories:],
          text(font: fonts.en, size: size.san)[#get(info, "discipline_category_en")],
          text(font: fonts.en, size: size.san)[First-level Discipline:],
          text(font: fonts.en, size: size.san)[#get(info, "first_level_discipline_en")],
          text(font: fonts.en, size: size.san)[Second-level Discipline:],
          text(font: fonts.en, size: size.san)[#get(info, "second_level_discipline_en")],
          text(font: fonts.en, size: size.san)[Research Fields:],
          text(font: fonts.en, size: size.san)[#get(info, "research_direction_en")],
          text(font: fonts.en, size: size.san)[Supervisor:],
          text(font: fonts.en, size: size.san)[#get(info, "supervisor_en")],
        )
      ]
    ]

    #v(1fr)
    #align(center)[
      #text(font: fonts.en, size: size.san)[
        #get(info, "date_en", default: "May 2026")
      ]
    ]
  ]
  pagebreak()
}
