#import "vendor/gb7714-bilingual/lib.typ": init-gb7714
#import "lib.typ": *
#import "metadata.typ": thesis-info

#show: init-gb7714.with(read("references.bib"), style: "numeric", version: "2015", show-url: false, show-doi: false)
#show: body => tongji-thesis(info: thesis-info)[#body]

#chinese-cover(thesis-info)
#english-cover(thesis-info)
#thesis-spine(thesis-info)

#frontmatter[
  #abstract-cn(keywords: ("关键词1", "关键词2", "关键词3", "关键词4", "关键词5"))[
    摘要通常是一篇文章、论文、报告或其他文本的简短概括。它的目的是帮助读者了解
    文本的主要内容和结论，以便决定是否需要继续阅读原文。摘要通常包含文本的主题、
    目的、方法、结果和结论等方面的信息，并尽可能简洁明了地呈现。

    好的摘要应该能够概括文本的重点，同时避免使用不必要的细节和专业术语，以便
    广大读者能够轻松理解。在撰写摘要时，作者应该遵循文献的格式要求和撰写规范，
    同时结合文本的内容和目的，将摘要撰写得准确、简洁、易懂。

    本模板文件仅用于展示同济大学研究生学位论文 Typst 模板的排版结构。正式写作时，
    可将摘要替换为论文的研究目的、方法、结果和结论，并保持关键词为三至五个。
  ]

  #abstract-en(keywords: ("Keyword 1", "Keyword 2", "Keyword 3", "Keyword 4", "Keyword 5"))[
    An abstract is usually a short summary of an article, essay, report, or other text. Its purpose
    is to help the reader understand the main content and conclusions of the text so that he or she
    can decide whether to continue reading the original text. The abstract usually contains
    information about the topic, purpose, methods, results, and conclusions of the text.

    A good abstract should be able to summarize the main points of the text while avoiding
    unnecessary details and jargon so that it can be easily understood by a wide audience. When
    writing an abstract, authors should follow the formatting requirements and writing specifications
    of the literature, as well as combine the content and purpose of the text to write an accurate,
    concise, and easy-to-understand abstract.

    This template file is only for demonstrating the Typst template structure for Tongji University
    graduate thesis. When writing formally, replace the abstract with the research purpose, methods,
    results, and conclusions of the thesis, and keep three to five keywords.
  ]

  #table-of-contents()

  #symbols(entries: (
    ("POI", "Point of Interest，兴趣点数据"),
    ("MLLM", "Multimodal Large Language Model，多模态大语言模型"),
    ("LU", "Land Use，用地功能"),
  ))
]

#mainmatter[
  #include "chapters/chapter1.typ"
  #include "chapters/chapter2.typ"
]

#backmatter[
  #references(bib: "references.bib")

  #appendix[示例附录][
    附录内容可放置调查问卷、补充图表、模型参数、额外实验结果或正文中过长的说明材料。附录中的图、
    表和公式可按“图A1”“表A1”等方式编号。
  ]

  #acknowledgements[
    本文模板的创建参考了同济大学研究生学位论文写作参考指南和写作参考示例。正式论文中的致谢
    应内容实在、语言诚恳、篇幅适中。
  ]

  #cv-and-publications[
    #text(weight: "bold")[个人简历：]
    #linebreak()
    XX，男/女，XXXX年XX月生，XXXX年XX月入同济大学攻读硕士学位。

    #v(1em)
    #text(weight: "bold")[已发表论文：]
    #linebreak()
    [1] XX，XX. 城市用地功能识别方法研究[J]. 城市规划学刊，2026.
  ]

  #declaration-statements(thesis-info)
]
