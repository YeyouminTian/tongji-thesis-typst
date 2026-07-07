#import "../lib.typ": chapter, multicite

#chapter(label: <ch:formula>)[公式、文献与学术要素][

本章演示数学公式的排版与交叉引用、参考文献的多种引用方式，以及符号说明与附录的引用方法。

== 数学公式

行内公式直接嵌入文本，如 $y = f(x) + epsilon$、$R^2 = 0.91$。块级公式另起一行居中排版，并按章自动编号，正文用 `@eqt:标签` 引用。

Softmax 归一化可写作多行对齐推导，见 @eqt:softmax：

$ hat(y) &= arg max_(k) P(k | x) \
        &= arg max_(k) (exp(z_k)) / (sum_(j) exp(z_j)) $ <softmax>

矩阵与向量使用 `mat`、`vec` 排版，见 @eqt:matrix：

$ bold(W) = mat(w_11, w_12; w_21, w_22), quad bold(x) = vec(x_1, x_2) $ <matrix>

分段函数用 `cases` 排版，见 @eqt:relu：

$ op("ReLU")(t) = cases(t\, & t >= 0, 0\, & t < 0) $ <relu>

上述公式的编号（如式 (4-1)）与图、表保持一致的“章-序号”格式，增删公式时全文自动重排。

== 参考文献引用

正文以 `@键名` 引用文献，参考文献表由 GB/T 7714 数字格式自动生成，并按引用顺序编号。单篇引用示例：既有研究提出了顾及复杂空间语义的城市功能识别方法@chen2021；可解释性方法的综述见@Hassija2024InterpretingBlackBoxXAI。

多篇文献连续引用时用 `#multicite[...]` 合并：两篇显示为 #multicite[@chen2021 @liu2024]，三篇及以上自动压缩为区间 #multicite[@chen2021 @liu2024 @Hassija2024InterpretingBlackBoxXAI]。中英文文献的著者截断（“等”／“et al.”）由条目的 `language` 字段决定。写作规范可进一步参阅学校指南@tongji2025。

== 符号说明与附录

论文中反复出现的符号可在前置部分的“符号说明”集中列出，例如模型输出 $hat(y)$、权重矩阵 $bold(W)$、误差项 $epsilon$ 等，读者据此对照全文。附录用于安放调查问卷、补充图表或较长的推导材料；为附录加上标签后，正文用 `@app:标签` 引用会自动显示为“附录A”，如本模板后置部分的示例附录即以此方式命名。
]
