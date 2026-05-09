#import "typography.typ": fonts, size

#let spread-label(label) = {
  let chars = str(label).clusters()
  let label-body = if chars.len() <= 4 {
    let columns = ()
    let cells = ()
    for (index, char) in chars.enumerate() {
      columns.push(auto)
      cells.push(text(font: fonts.fang, size: size.san)[#char])
      if index < chars.len() - 1 {
        columns.push(1fr)
        cells.push([])
      }
    }
    box(width: 6em)[
      #grid(
        columns: columns,
        column-gutter: 0pt,
        align: horizon,
        ..cells
      )
    ]
  } else {
    text(font: fonts.fang, size: size.san)[#label]
  }

  [#label-body#text(font: fonts.fang, size: size.san)[：]]
}

#let cover-strong(font, size, body) = {
  text(font: font, size: size, weight: "bold", fill: black, stroke: 0.18pt + black)[#body]
}

#let vertical-text(value, font: fonts.fang, size: size.si, weight: "bold") = {
  let chars = str(value).clusters()
  grid(
    columns: (1em,),
    row-gutter: 2pt,
    align: center,
    ..chars.map(char => text(font: font, size: size, weight: weight)[#char])
  )
}
