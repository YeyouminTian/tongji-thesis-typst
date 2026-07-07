#import "../lib.typ": chapter, palette, flow-node, vflow, bar-chart, line-chart

#chapter(label: <ch:figures>)[图、表与可视化][

本章演示图片、图题与交叉引用的通用写法，展示 Typst 直接以代码绘制矢量可视化的能力，并给出基础表格、进阶表格与程序化生成表格三类范例。

== 图与图题

图应使用 `#figure(...)` 包裹并配 `caption`，由模板自动生成章内编号（如“图 3-1”）；为图加上标签后，正文即可用 `@fig:标签` 自动引用，编号变动无需手工维护。

插入外部图片使用 `image(...)`，并以 `width` 控制显示宽度，如 @fig:sample。图片路径相对于当前 `.typ` 文件：本章位于 `chapters/`，示例图片位于仓库的 `assets/`，故写作 `../assets/...`；PNG、JPEG 等位图与 SVG 矢量图均受支持。

#figure(
  kind: image,
  image("../assets/tongji.svg", width: 70%),
  caption: [插入外部图片示例],
) <sample>

其写法为：

```typ
#figure(
  kind: image,
  image("../assets/tongji.svg", width: 70%),
  caption: [插入外部图片示例],
)
```

与外部图片不同，下面的技术路线流程图并非图片文件，而是由 Typst 图元（矩形、线段、多边形）直接绘制，见 @fig:route。这类图形是源码的一部分，可随数据或参数自动更新，省去了“改图—导出—替换”的往复。

#figure(
  kind: image,
  vflow((
    flow-node[① 数据准备],
    flow-node[② 特征提取与语义识别],
    flow-node[③ 结果构建],
    flow-node[④ 结果校验],
    flow-node(fill: palette.node-alt)[⑤ 综合解释与输出],
  )),
  caption: [技术路线流程图（Typst 原生图元绘制）],
) <route>

== 数据可视化

图表同样可由数据数组直接生成。@fig:acc 的柱状图与 @fig:conv 的折线图均只描述数据本身，坐标轴、网格与标签由绘图函数自动排布；修改数据即刻反映到图上，无需另开绘图软件。

#figure(
  kind: image,
  bar-chart((("数据1", 0.62), ("数据2", 0.74), ("数据3", 0.85), ("数据4", 0.91))),
  caption: [各阶段识别精度对比],
) <acc>

#figure(
  kind: image,
  line-chart((("R1", 0.55), ("R2", 0.68), ("R3", 0.79), ("R4", 0.83), ("R5", 0.90))),
  caption: [多轮迭代的收敛曲线],
) <conv>

以 @fig:acc 为例，其数据与调用只需一行数组：

```typ
#figure(
  kind: image,
  bar-chart((("数据1", 0.62), ("数据2", 0.74), ("数据3", 0.85), ("数据4", 0.91))),
  caption: [各阶段识别精度对比],
)
```

绘图函数 `bar-chart`、`line-chart`、`vflow` 定义在 `utils/diagram.typ`，仅使用 Typst 内置图元，不依赖任何外部绘图包。

== 基础表格

表格应使用 `#figure(table(...))` 包裹，由模板自动编号“表 3-1”并将表题置于表格上方。@tbl:basic 演示三列基础表格。

#figure(
  table(
    columns: (3cm, 4cm, 5cm),
    inset: 6pt,
    table.header([参数], [取值], [说明]),
    [纸张], [A4], [210 mm × 297 mm],
    [正文], [宋体小四], [固定行距 20 磅],
    [编号], [按章], [图、表、公式独立计数],
  ),
  caption: [基础三列表格],
) <basic>

== 进阶表格

去除竖线、仅保留顶／中／底三条横线，即为学术论文常用的“三线表”；表头可用 `table.cell(colspan: n)` 合并单元格。@tbl:adv 综合演示两者。

#figure(
  table(
    columns: (2.6cm, 2.6cm, 2.6cm, 2.6cm),
    stroke: none,
    inset: 6pt,
    table.hline(y: 0, stroke: 1pt),
    table.header(
      table.cell(colspan: 2)[输入], table.cell(colspan: 2)[输出],
    ),
    table.hline(y: 1, stroke: 0.5pt),
    [数据1], [数据2], [数据3], [置信度],
    table.hline(y: 2, stroke: 0.5pt),
    [是], [是], [C], [0.86],
    [是], [否], [R], [0.71],
    [否], [是], [G], [0.68],
    table.hline(stroke: 1pt),
  ),
  caption: [三线表与合并单元格],
) <adv>

== 程序化生成表格

当表格行较多且来自结构化数据时，可用数组配合循环批量生成，避免逐格重复书写。@tbl:codes 的表体即由代码数组经 `map` 展开得到。

#let code-table-data = (
  ("C", "商业服务业"), ("R", "居住"), ("M", "工业"),
  ("W", "仓储"), ("G", "绿地"), ("S", "交通设施"),
)
#figure(
  table(
    columns: (3cm, 6cm),
    inset: 6pt,
    table.header([代码], [用地类别]),
    ..code-table-data.map(((code, name)) => (code, name)).flatten(),
  ),
  caption: [由数组循环生成的用地代码表],
) <codes>
]
