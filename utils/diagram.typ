// 纯 Typst 图元绘制工具：流程图节点/箭头、柱状图、折线图。
// 不依赖任何外部绘图包（cetz/fletcher 等），保证仓库克隆后离线可编译。
#import "typography.typ": fonts, size

// —— 配色（浅色、打印友好）——
#let palette = (
  line: rgb("#33415c"),      // 主线条/坐标轴
  node: rgb("#eef2f8"),      // 流程节点填充
  node-alt: rgb("#fdeee8"),  // 强调节点填充
  accent: rgb("#3b6fb0"),    // 主色（柱、边框）
  accent2: rgb("#c0603f"),   // 次色（折线、数据点）
  grid: luma(210),           // 网格线
)

// 流程图节点：圆角矩形 + 居中文字
#let flow-node(body, width: 6.6cm, fill: palette.node) = box(
  width: width, inset: (x: 10pt, y: 7pt), radius: 4pt,
  fill: fill, stroke: 0.7pt + palette.accent,
)[
  #set text(font: fonts.song, size: size.wu)
  #align(center)[#body]
]

// 竖直向下箭头：线段 + 三角箭头（纯图元）
#let flow-arrow(width) = box(width: width, height: 16pt)[
  #place(top + center, line(length: 11pt, angle: 90deg, stroke: 0.9pt + palette.line))
  #place(top + center, dy: 9pt, polygon(fill: palette.line, (0pt, 5pt), (-3.2pt, 0pt), (3.2pt, 0pt)))
]

// 竖直流程：在相邻节点间自动插入箭头
#let vflow(nodes, width: 6.6cm) = {
  let items = ()
  for (i, n) in nodes.enumerate() {
    if i > 0 { items.push(flow-arrow(width)) }
    items.push(n)
  }
  align(center)[#stack(dir: ttb, spacing: 0pt, ..items)]
}

// 数据驱动柱状图：data 为 (标签, 数值) 数组，纯图元绘制
#let bar-chart(data, max-val: 1.0, width: 9.6cm, height: 5.2cm, accent: palette.accent) = {
  assert(data.len() > 0, message: "bar-chart requires at least one data point")
  assert(max-val > 0, message: "bar-chart max-val must be positive")
  let ml = 2.2em          // 左侧 y 轴刻度栏宽
  let mb = 1.5em          // 底部 x 轴标签栏高
  let pw = width - ml
  let ph = height - mb
  let n = data.len()
  let slot = pw / n
  let bw = slot * 0.5
  box(width: width, height: height, {
    // 横向网格线 + y 轴刻度
    for g in (0.25, 0.5, 0.75, 1.0) {
      place(left + bottom, dx: ml, dy: -mb - ph * g, line(length: pw, stroke: 0.4pt + palette.grid))
      place(left + bottom, dx: 0pt, dy: -mb - ph * g - 0.55em,
        box(width: ml - 4pt)[#align(right)[#text(font: fonts.en, size: 7.5pt)[#(calc.round(g * max-val * 100) / 100)]]])
    }
    // 坐标轴
    place(left + bottom, dx: ml, dy: -mb, line(length: pw, stroke: 0.9pt + palette.line))
    place(left + bottom, dx: ml, dy: -mb, line(length: ph, angle: -90deg, stroke: 0.9pt + palette.line))
    // 柱体 + 数值标签 + x 标签
    for (i, item) in data.enumerate() {
      let (lbl, v) = item
      let bh = ph * v / max-val
      place(left + bottom, dx: ml + i * slot + (slot - bw) / 2, dy: -mb,
        rect(width: bw, height: bh, fill: accent, stroke: none))
      place(left + bottom, dx: ml + i * slot, dy: -mb - bh - 0.95em,
        box(width: slot)[#align(center)[#text(font: fonts.en, size: 7.5pt)[#v]]])
      place(left + bottom, dx: ml + i * slot, dy: -0.1em,
        box(width: slot)[#align(center)[#text(font: fonts.song, size: 8pt)[#lbl]]])
    }
  })
}

// 数据驱动折线图：series 为 (标签, 数值) 数组，纯图元绘制
#let line-chart(series, max-val: 1.0, width: 9.6cm, height: 4.6cm, accent: palette.accent2) = {
  assert(series.len() >= 2, message: "line-chart requires at least two data points")
  assert(max-val > 0, message: "line-chart max-val must be positive")
  let ml = 2.2em
  let mb = 1.5em
  let pw = width - ml
  let ph = height - mb
  let n = series.len()
  let step = pw / (n - 1)
  let px(i) = ml + i * step
  let py(v) = -mb - ph * v / max-val
  box(width: width, height: height, {
    for g in (0.25, 0.5, 0.75, 1.0) {
      place(left + bottom, dx: ml, dy: -mb - ph * g, line(length: pw, stroke: 0.4pt + palette.grid))
    }
    place(left + bottom, dx: ml, dy: -mb, line(length: pw, stroke: 0.9pt + palette.line))
    place(left + bottom, dx: ml, dy: -mb, line(length: ph, angle: -90deg, stroke: 0.9pt + palette.line))
    // 折线段
    for i in range(n - 1) {
      let (l0, v0) = series.at(i)
      let (l1, v1) = series.at(i + 1)
      place(left + bottom, dx: px(i), dy: py(v0),
        line(start: (0pt, 0pt), end: (px(i + 1) - px(i), py(v1) - py(v0)), stroke: 1pt + accent))
    }
    // 数据点 + x 标签
    for (i, item) in series.enumerate() {
      let (lbl, v) = item
      place(left + bottom, dx: px(i) - 2pt, dy: py(v) + 2pt, circle(radius: 2pt, fill: accent, stroke: none))
      place(left + bottom, dx: px(i) - 0.6em, dy: -0.1em,
        box(width: 1.2em)[#align(center)[#text(font: fonts.en, size: 8pt)[#lbl]]])
    }
  })
}
