#import "document.typ": page-style
#import "../utils/typography.typ": fonts, size, rhythm
#import "../utils/metadata.typ": get

#let statement-title(title) = {
  block(width: 100%, above: 0pt, below: 16pt, breakable: false)[
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.no-spacing)
    #align(center)[
      #text(font: fonts.hei, size: size.xiaoer, stroke: 0.4pt)[#title]
    ]
  ]
}

#let statement-body(body) = {
  set text(font: fonts.song + fonts.en, size: size.si)
  set par(
    first-line-indent: rhythm.body-indent,
    leading: rhythm.statement-leading,
    spacing: rhythm.statement-spacing,
    justify: true,
  )
  body
}

#let declaration-title(title) = {
  block(width: 100%, above: 0pt, below: 15pt, breakable: false)[
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.single-leading, spacing: rhythm.no-spacing, justify: false)
    #align(center)[
      #text(font: fonts.hei, size: size.xiaoer, stroke: 0.4pt)[#title]
    ]
  ]
}

#let declaration-body(body) = {
  set text(font: fonts.song + fonts.en, size: size.si)
  set par(
    first-line-indent: rhythm.body-indent,
    leading: rhythm.declaration-leading,
    spacing: rhythm.no-spacing,
    justify: true,
  )
  body
}

#let signature-blank(width: 4em) = {
  box(width: width, height: 0.85em, baseline: -0.08em, stroke: (bottom: 0.6pt + black))[]
}

#let declaration-statements(info) = {
  pagebreak()
  page-style(numbering: "1", header: none)[
    #declaration-title[同济大学学位论文原创性声明]
    #v(0.5fr)
    #declaration-body[
      本人郑重声明：所呈交的学位论文#underline(evade: false, stroke: 1pt, offset: 3pt)[#text(weight: "bold", size: 1.1em)[《#get(info, "title")》]]，是本人在导师指导下，独立进行研究工作所取得的成果。除文中已经注明引用的内容外，本学位论文的研究成果不包含任何他人创作的、已公开发表或者没有公开发表的作品的内容。对本论文所涉及的研究工作做出贡献的其他个人和集体，均已在文中以明确方式标明。本学位论文原创性声明的法律责任由本人承担。
    ]


    #v(1fr)
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.declaration-leading, spacing: rhythm.no-spacing, justify: false)
    #align(right)[#text(font: fonts.song, size: size.si, weight: "bold")[学位论文作者签名：#h(9em)]]
    #v(1em)
    #align(right)[#text(font: fonts.song, size: size.si, weight: "bold")[日期：#h(2em)年#h(2em)月#h(2em)日]]


    #v(2em)
    #line(length: 100%, stroke: (paint: black, thickness: 0.35pt))
    #v(0.42cm)
    #v(1fr)

    #declaration-title[同济大学学位论文版权使用授权书]
    #v(0.5fr)
    #declaration-body[
      本人完全了解同济大学关于收集、保存、使用学位论文的规定，同意如下各项内容：
      按照学校要求提交学位论文的印刷本和电子版；学校有权保存论文的印刷本和电子版，
      并采用影印、缩印、扫描、数字化或其它手段保存论文；学校有权提供目录检索以及提供
      本论文全文或部分的阅览服务；学校有权按有关规定向国家有关部门或机构送交论文的
      复印件和电子版；允许论文被查阅和借阅。学校有权将本论文的全部或部分内容授权编入
      有关数据库出版传播。
    ]


    #v(2em)
    #set par(first-line-indent: rhythm.no-indent, leading: rhythm.declaration-leading, spacing: rhythm.no-spacing, justify: false)
    #pad(left: 2em)[
      #set text(font: fonts.song, size: size.si, weight: "bold")
      本学位论文属于（在以下方框内打”√”）：
      #v(rhythm.declaration-leading)
      □ 保密，在 #box(width: 3em, stroke: (bottom: 0.5pt)) 年解密后适用本授权书。
      #v(rhythm.declaration-leading)
      □ 不保密。
    ]

    #v(0.58cm)
    #v(1fr)
    #grid(
      columns: (1fr, 1fr),
      rows: auto,
      column-gutter: 3em,
      row-gutter: rhythm.declaration-leading,
      text(font: fonts.song, size: size.si, weight: "bold")[学位论文作者签名：],
      text(font: fonts.song, size: size.si, weight: "bold")[指导教师签名：],

      text(font: fonts.song, size: size.si, weight: "bold")[日期：#h(2em)年#h(2em)月#h(2em)日],
      text(font: fonts.song, size: size.si, weight: "bold")[日期：#h(2em)年#h(2em)月#h(2em)日],
    )
  ]
}

#let originality-statement(info) = {
  pagebreak()
  page-style(numbering: "1", header: none)[
    #statement-title[同济大学学位论文原创性声明]
    #statement-body[
      本人郑重声明：所呈交的学位论文#underline(evade: false, stroke: 1pt, offset: 3pt)[#text(weight: "bold", size: 1em)[《#get(info, "title")》]]，是本人在导师指导下，
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
  page-style(numbering: "1", header: none)[
    #statement-title[同济大学学位论文版权使用授权书]
    #statement-body[
      本人完全了解同济大学关于收集、保存、使用学位论文的规定，同意如下各项内容：按照学校要求提交学位论文的印刷本和电子版；学校有权保存论文的印刷本和电子版，并采用影印、缩印、扫描、数字化或其它手段保存论文；学校有权提供目录检索以及提供本论文全文或部分的阅览服务；学校有权按有关规定向国家有关部门或机构送交论文的复印件和电子版；允许论文被查阅和借阅。学校有权将本论文的全部或部分内容授权编入有关数据库出版传播。

      #text(weight: "bold")[#h(2em)本学位论文属于（在以下方框内打"√"）：]

      #text(weight: "bold")[#h(2em)□ 保密，在#underline(offset: 2pt)[#h(4em)]年解密后适用本授权书。]

      #text(weight: "bold")[#h(2em)□ 不保密。]
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
