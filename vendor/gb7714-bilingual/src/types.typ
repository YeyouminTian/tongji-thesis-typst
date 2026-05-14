// GB/T 7714 双语参考文献系统 - 文献类型标识模块

#import "versions/mod.typ": get-type-map

/// 渲染文献类型标识 [J] [M] 等
/// - entry-type: BibTeX 条目类型
/// - has-url: 是否有 URL 或 DOI（仅网页类型默认转为在线载体）
/// - version: 标准版本 ("2015" | "2025")
/// - mark: 用户指定的类型标识（覆盖自动检测）
/// - medium: 用户指定的载体标识（覆盖自动检测）
#let render-type-id(
  entry-type,
  has-url: false,
  version: "2025",
  mark: none,
  medium: none,
) = {
  let type-map = get-type-map(version)

  // 类型标识：优先使用用户指定的 mark，否则从 type-map 查找
  let base = if mark != none {
    upper(mark)
  } else {
    type-map.at(lower(entry-type), default: "Z")
  }

  // 载体标识：只在用户显式指定 medium 时添加；普通文献不因 URL/DOI 自动变为在线文献。
  let carrier = if medium != none {
    upper(medium)
  } else {
    none
  }

  // 组合输出
  if base == "EB" {
    "[EB/OL]" // 网页默认就是在线
  } else if carrier != none {
    "[" + base + "/" + carrier + "]"
  } else {
    "[" + base + "]"
  }
}
