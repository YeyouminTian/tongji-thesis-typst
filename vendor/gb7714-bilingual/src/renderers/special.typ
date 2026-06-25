// GB/T 7714—2025 新增/独立文献类型渲染器

#import "../authors.typ": format-entry-authors
#import "../types.typ": render-type-id
#import "../versions/mod.typ": get-punctuation
#import "../core/utils.typ": (
  append-access-info, append-pages, build-author-year, build-pub-info,
  format-accessed-date, smart-join,
)

#let _field(f, names, default: "") = {
  for name in names {
    let value = f.at(name, default: "")
    if value != "" {
      return value
    }
  }
  default
}

#let _date-year(date, fallback: "") = {
  let value = str(date)
  if value.len() >= 4 {
    value.slice(0, 4)
  } else {
    fallback
  }
}

#let _without-accessed(config) = (
  show-url: config.show-url,
  show-doi: config.show-doi,
  show-accessed: false,
)

#let render-archive(
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
  let punct = get-punctuation(version, lang)
  let title = f.at("title", default: "")
  let number = _field(f, ("number", "archive-number"))
  let address = _field(f, ("address", "location"))
  let collector = _field(
    f,
    ("publisher", "organization", "institution", "archive"),
  )
  let date = _field(f, ("date", "year"))
  let year = (
    _date-year(date, fallback: str(f.at("year", default: ""))) + year-suffix
  )
  let pages = f.at("pages", default: "").replace("--", "-")
  let mark = f.at("_resolved_mark", default: none)
  let medium = f.at("_resolved_medium", default: none)
  let type-id = render-type-id(
    "archive",
    version: version,
    mark: mark,
    medium: medium,
  )

  let parts = ()
  let year-in-pub = true
  if style == "author-date" {
    let ay = build-author-year(authors, year, punct)
    if ay.author-part != none {
      parts.push(ay.author-part)
    }
    year-in-pub = ay.year-in-pub
  } else if authors != "" {
    parts.push(authors)
  }

  let title-part = title
  if number != "" {
    title-part += punct.colon + number
  }
  parts.push(title-part + type-id)

  let pub-info = build-pub-info(
    address,
    collector,
    date,
    punct,
    include-year: year-in-pub or date != year,
  )
  let pub-info = append-pages(pub-info, pages, punct)
  if pub-info != "" {
    parts.push(pub-info)
  }

  append-access-info(
    smart-join(parts),
    entry,
    config: config,
    version: version,
  )
}

#let render-map(
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
  let punct = get-punctuation(version, lang)
  let title = f.at("title", default: "")
  let scale = f.at("scale", default: "")
  let edition = f.at("edition", default: "")
  let address = _field(f, ("address", "location"))
  let publisher = _field(f, ("publisher", "organization", "institution"))
  let year = str(f.at("year", default: "")) + year-suffix
  let dimensions = _field(f, ("dimensions", "size"))
  let mark = f.at("_resolved_mark", default: none)
  let medium = f.at("_resolved_medium", default: none)
  let type-id = render-type-id(
    "map",
    version: version,
    mark: mark,
    medium: medium,
  )

  let parts = ()
  let year-in-pub = true
  if style == "author-date" {
    let ay = build-author-year(authors, year, punct)
    if ay.author-part != none {
      parts.push(ay.author-part)
    }
    year-in-pub = ay.year-in-pub
  } else if authors != "" {
    parts.push(authors)
  }

  let title-part = title
  if scale != "" {
    title-part += punct.comma + scale
  }
  parts.push(title-part + type-id)
  if edition != "" {
    parts.push(str(edition))
  }

  let pub-info = build-pub-info(
    address,
    publisher,
    year,
    punct,
    include-year: year-in-pub,
  )
  if pub-info != "" {
    parts.push(pub-info)
  }
  if dimensions != "" {
    parts.push(str(dimensions))
  }

  append-access-info(
    smart-join(parts),
    entry,
    config: config,
    version: version,
  )
}

#let _render-timed-online(
  entry,
  lang,
  entry-type,
  style,
  version,
  config,
  year-suffix,
) = {
  let f = entry.fields
  let authors = format-entry-authors(
    entry.parsed_names,
    lang,
    style,
    version: version,
  )
  let punct = get-punctuation(version, lang)
  let title = f.at("title", default: "")
  let version-text = _field(f, ("version", "edition"))
  let platform = _field(
    f,
    ("publisher", "organization", "institution", "archiveprefix", "journal"),
  )
  let date = _field(f, ("date", "year"))
  let year = (
    _date-year(date, fallback: str(f.at("year", default: ""))) + year-suffix
  )
  let accessed = if config.show-accessed {
    format-accessed-date(entry)
  } else {
    ""
  }
  let mark = f.at("_resolved_mark", default: none)
  let explicit-medium = f.at("_resolved_medium", default: none)
  let medium = if explicit-medium != none {
    explicit-medium
  } else {
    "OL"
  }
  let type-id = render-type-id(
    entry-type,
    version: version,
    mark: mark,
    medium: medium,
  )

  let parts = ()
  if style == "author-date" {
    let ay = build-author-year(authors, year, punct)
    if ay.author-part != none {
      parts.push(ay.author-part)
    }
  } else if authors != "" {
    parts.push(authors)
  }

  parts.push(title + type-id)
  if version-text != "" {
    parts.push(str(version-text))
  }

  let platform-date = platform
  if date != "" and not (style == "author-date" and str(date) == year) {
    let date-sep = if platform != "" and lang != "zh" { " " } else { "" }
    platform-date += date-sep + punct.lparen + str(date) + punct.rparen
  }
  platform-date += accessed
  if platform-date != "" {
    parts.push(platform-date)
  }

  append-access-info(
    smart-join(parts),
    entry,
    config: _without-accessed(config),
    version: version,
  )
}

#let render-dataset(
  entry,
  lang,
  year-suffix: "",
  style: "numeric",
  version: "2025",
  config: (show-url: true, show-doi: true, show-accessed: true),
) = {
  _render-timed-online(
    entry,
    lang,
    "dataset",
    style,
    version,
    config,
    year-suffix,
  )
}

#let render-preprint(
  entry,
  lang,
  year-suffix: "",
  style: "numeric",
  version: "2025",
  config: (show-url: true, show-doi: true, show-accessed: true),
) = {
  _render-timed-online(
    entry,
    lang,
    "preprint",
    style,
    version,
    config,
    year-suffix,
  )
}
