// GB/T 7714 双语参考文献系统 - 语言检测模块

/// 检测文献条目的语言
/// 优先级：language 字段 > langid 字段 > 正文汉字检测 > 默认英文
#let detect-language(entry) = {
  let fields = entry.at("fields", default: (:))

  // 1. 优先检查 language 字段
  let lang = fields.at("language", default: "")
  if lang != "" {
    let lang-lower = lower(lang)
    if "zh" in lang-lower or "chinese" in lang-lower or "中" in lang-lower {
      return "zh"
    }
    if "en" in lang-lower or "english" in lang-lower {
      return "en"
    }
  }

  // 2. 检查 langid 字段 (biblatex 风格)
  let langid = fields.at("langid", default: "")
  if langid != "" {
    if "zh" in lower(langid) or "chinese" in lower(langid) {
      return "zh"
    }
    if "en" in lower(langid) or "english" in lower(langid) {
      return "en"
    }
  }

  // 3. Fallback: 检测标题/作者是否含中文
  let title = fields.at("title", default: "")
  let author = fields.at("author", default: "")
  let text-to-check = title + author

  // 检测是否有至少两个连续汉字
  if text-to-check.find(regex("\p{Han}{2,}")) != none {
    return "zh"
  }

  // 默认为英文
  return "en"
}

/// 检测著者-出版年制参考文献表的文种分组。
/// GB/T 7714—2025 9.3.2 的顺序为：中文、日文、西文、俄文、其他文种。
#let detect-language-group(entry) = {
  let fields = entry.at("fields", default: (:))
  let declared = lower(
    fields.at("language", default: fields.at("langid", default: "")),
  )

  if (
    "zh" in declared
      or "chinese" in declared
      or "中文" in declared
      or "中" == declared
  ) {
    return "zh"
  }
  if (
    "ja" in declared
      or "japanese" in declared
      or "日文" in declared
      or "日语" in declared
  ) {
    return "ja"
  }
  if (
    "ru" in declared
      or "russian" in declared
      or "俄文" in declared
      or "俄语" in declared
  ) {
    return "ru"
  }
  if (
    "en" in declared
      or "english" in declared
      or "de" in declared
      or "german" in declared
      or "fr" in declared
      or "french" in declared
      or "es" in declared
      or "spanish" in declared
      or "western" in declared
      or "西文" in declared
  ) {
    return "western"
  }
  if declared != "" {
    return "other"
  }

  let title = fields.at("title", default: "")
  let author = fields.at("author", default: "")
  let text-to-check = title + author

  if text-to-check.find(regex("[ぁ-ゟ゠-ヿ]")) != none {
    return "ja"
  }
  if text-to-check.find(regex("\p{Cyrillic}")) != none {
    return "ru"
  }
  if text-to-check.find(regex("\p{Han}{2,}")) != none {
    return "zh"
  }
  if text-to-check.find(regex("[A-Za-z]")) != none {
    return "western"
  }
  "other"
}
