#import "typography.typ": fonts

#let chapter-state = state("chapter-number", 0)

#let heading-numbering(..nums) = {
  let nums = nums.pos()
  if nums.len() == 1 {
    str(nums.at(0))
  } else {
    nums.map(n => str(n)).join(".")
  }
}

#let format-heading-number(level, nums) = {
  if nums.len() == 0 {
    []
  } else if level == 1 {
    "第" + str(nums.at(0)) + "章"
  } else {
    nums.slice(0, calc.min(level, nums.len())).map(n => str(n)).join(".")
  }
}

#let heading-number-text(number) = {
  text(font: fonts.hei-cn, cjk-latin-spacing: none)[#number]
}

#let heading-text(it) = {
  let prefix = if it.numbering == none {
    none
  } else {
    context format-heading-number(it.level, counter(heading).get())
  }

  if prefix == none {
    it.body
  } else {
    [#heading-number-text(prefix)#h(0.3em)#it.body]
  }
}

#let current-heading() = context {
  let headings = query(selector(heading.where(level: 1)).before(here()))
  if headings.len() == 0 {
    []
  } else {
    let h = headings.last()
    let nums = counter(heading).at(h.location())
    let number = format-heading-number(1, nums)
    if h.numbering != none and number != [] {
      [#number #h.body]
    } else {
      h.body
    }
  }
}
