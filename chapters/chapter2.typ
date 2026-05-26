#import "../lib.typ": chapter, multicite

#chapter[模板样式示例][

== 正文段落

正文采用宋体小四号，英文部分使用 Times New Roman，小四号，固定行距 20 磅，段前段后为 0。
段落首行缩进两个汉字符，并使用两端对齐。若段落中包含较高的数学表达式，可根据实际情况适当
调整局部行距。

== 表格示例

表格应使用 `figure` 包裹 `table`，由模板自动生成章内编号。@tbl:format-params 展示了
主要排版参数的写法，表序与表名之间自动保留一个字符宽度。

#figure(
  table(
    columns: (2.2cm, 4.2cm, 6.4cm),
    inset: 6pt,
    table.header(
      [项目],
      [要求],
      [说明],
    ),
    [纸张],
    [A4],
    [页面幅面为 210mm × 297mm。],
    [页边距],
    [上、下 2.54cm；左、右 3.17cm],
    [装订线为 0cm。],
    [正文],
    [宋体小四，20 磅行距],
    [英文使用 Times New Roman。],
  ),
  caption: [主要排版参数示例],
) <format-params>

== 表达式示例

表达式应另行起排，公式居中，序号右对齐，并按章编号。正式写作时可用@eqt:example-model
这样的自动引用减少手动维护成本。

$ y = f(x) + epsilon $ <example-model>

== 后续扩展

正式论文中图、表和公式数量较多时，应继续使用 `figure(...)`、`figure(table(...))` 和块级
数学公式标签，由模板统一维护编号和交叉引用。

== 参考文献引用示例

正文中可直接使用 Typst 的 `@key` 语法引用文献。单篇文献引用示例如下：城市功能识别研究可参考
既有空间语义识别方法@chen2021。多篇文献引用示例如下：两篇文献连续引用时显示为
#multicite[@chen2021 @liu2024]，三篇及以上连续引用时显示为
#multicite[@chen2021 @liu2024 @Hassija2024InterpretingBlackBoxXAI]。学校格式说明类文献也可同样引用@tongji2025。
]
