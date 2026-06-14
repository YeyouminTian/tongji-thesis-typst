#import "typography.typ": fonts, size

#let spread-label(label) = {
  let chars = str(label).clusters()
  let label-body = if chars.len() <= 4 {
    // Spread characters across a fixed 6em width using inline `h(1fr)` gaps.
    // Keeping the content inline (rather than wrapping a block-level grid in a
    // box) preserves the text baseline, so the label sits on the same baseline
    // as the trailing colon and the value.
    box(width: 6em)[
      #for (index, char) in chars.enumerate() {
        if index > 0 { h(1fr) }
        text(font: fonts.fang, size: size.san)[#char]
      }
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
