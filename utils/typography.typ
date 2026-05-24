#import "@preview/pointless-size:0.1.2": zh

#let fonts = (
  song: ((name: "Times New Roman", covers: "latin-in-cjk"), "Source Han Serif SC", "Source Han Serif", "Noto Serif CJK SC", "SimSun", "Songti SC", "STSongti"),
  hei: ( (name: "Arial", covers: "latin-in-cjk"), "Source Han Sans SC", "Source Han Sans", "Noto Sans CJK SC", "SimHei", "Heiti SC", "STHeiti"),
  hei-cn: ((name: "Arial", covers: "latin-in-cjk"), "Source Han Sans SC", "Source Han Sans", "Noto Sans CJK SC", "SimHei", "Heiti SC", "STHeiti"),
  fang: ((name: "Times New Roman", covers: "latin-in-cjk"), "FangSong", "FangSong SC", "STFangSong", "FZFangSong-Z02S"),
  li: ("Libian SC", "Baoli SC", "Kaiti SC", "STKaiti"),
  kai: ((name: "Times New Roman", covers: "latin-in-cjk"), "KaiTi", "Kaiti SC", "STKaiti", "FZKai-Z03S"),
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

#let fixed-leading(font-size, line-height) = line-height - font-size
#let body-leading-value = fixed-leading(size.xiaosi, 20pt)

#let rhythm = (
  body-indent: (amount: 2em, all: true),
  no-indent: 0pt,
  // Word fixed line height maps to Typst as `leading = line height - font size`.
  body-leading: body-leading-value,                    // 正文行间距（20pt行高，小四号字）
  toc-leading: fixed-leading(size.xiaosi, 18pt),       // 目录行间距（18pt行高，小四号字）
  compact-leading: fixed-leading(size.wu, 16pt),       // 紧凑行间距（16pt行高，五号字）
  cover-leading: 0pt,                                  // 封面行间距（无额外间距）
  statement-leading: fixed-leading(size.si, 18pt),     // 普通声明页签名区行间距（18pt行高，四号字）
  declaration-leading: fixed-leading(size.si, 25pt),   // 原创性声明/版权授权书行间距（25pt行高，四号字）
  declaration-v-spacing: 0.20cm,                       // 声明页行与行之间的垂直间距
  heading-leading: 0.2em,                              // 标题单倍行距（学校Word模板约1.2倍行高）
  single-leading: 0.65em,                              // 普通单倍行距（Typst默认相对值）
  body-spacing: body-leading-value,                    // 跨段也保持20pt基线行距
  compact-spacing: 0pt,                                // 紧凑段落间距
  statement-spacing: 0pt,                              // 声明页段落间距
  no-spacing: 0pt,                                     // 无段落间距
)
