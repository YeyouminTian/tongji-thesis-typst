// GB/T 7714 双语参考文献系统 - 报告渲染器

#import "../authors.typ": format-entry-authors
#import "../types.typ": render-type-id
#import "../versions/mod.typ": get-punctuation
#import "../core/utils.typ": append-pages, build-pub-info, render-base

/// 报告渲染
/// 格式：作者. 题名：报告编号[R]. 出版地：出版者，出版年：页码.
#let render-report(
  entry,
  lang,
  year-suffix: "",
  style: "numeric",
  version: "2025",
  config: (show-url: true, show-doi: true, show-accessed: true),
) = {
  let f = entry.fields

  let authors = format-entry-authors(
    entry.parsed_names,
    lang,
    style,
    version: version,
  )
  let title = f.at("title", default: "")
  let number = f.at("number", default: "")
  let year = str(f.at("year", default: "")) + year-suffix
  let date = f.at("date", default: year)
  let publisher = f.at("publisher", default: f.at("institution", default: ""))
  let address = f.at("address", default: f.at("location", default: ""))
  let pages = f.at("pages", default: "").replace("--", "-")
  let url = f.at("url", default: "")
  let mark = f.at("_resolved_mark", default: none)
  let medium = f.at("_resolved_medium", default: none)

  let type-id = render-type-id(
    "report",
    has-url: url != "",
    version: version,
    mark: mark,
    medium: medium,
  )
  let punct = get-punctuation(version, lang)

  // 题名：报告编号[R]
  let title-part = title
  if number != "" {
    title-part += punct.colon + number
  }
  title-part += type-id

  render-base(
    entry,
    authors,
    year,
    punct,
    style,
    config,
    year-in-pub => {
      let parts = ()
      parts.push(title-part)

      // 2025 版以发布日期为核心；若条目带出版者信息，则兼容标准示例中的
      // “出版地：发布机构，日期”形式。2015 版维持原出版项顺序。
      let pub-info = if version == "2025" {
        if address != "" or publisher != "" {
          build-pub-info(
            address,
            publisher,
            date,
            punct,
            include-year: year-in-pub,
          )
        } else if year-in-pub {
          str(date)
        } else {
          ""
        }
      } else {
        build-pub-info(
          address,
          publisher,
          year,
          punct,
          include-year: year-in-pub,
        )
      }
      pub-info = append-pages(pub-info, pages, punct)
      if pub-info != "" {
        parts.push(pub-info)
      }
      parts
    },
  )
}
