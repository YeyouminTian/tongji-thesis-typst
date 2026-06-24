#import "typography.typ": fonts

#let chapter-state = state("chapter-number", 0)
#let appendix-supplement = [附录]

#let heading-numbering(..nums) = {
  let nums = nums.pos()
  if nums.len() == 1 {
    str(nums.at(0))
  } else if nums.len() == 4 {
    // 四级标题使用 (1), (2), (3) 格式
    "(" + str(nums.at(3)) + ")"
  } else {
    nums.map(n => str(n)).join(".")
  }
}

#let appendix-number-text(nums) = {
  if nums.len() == 0 {
    []
  } else {
    [附录#numbering("A", nums.at(0))]
  }
}

#let is-appendix-heading(it) = it.level == 1 and it.supplement == appendix-supplement

#let format-heading-number(level, nums) = {
  if nums.len() == 0 {
    []
  } else if level == 1 {
    "第 " + str(nums.at(0)) + " 章"
  } else if level == 4 {
    // 四级标题使用 (1), (2), (3) 格式
    "(" + str(nums.at(3)) + ")"
  } else {
    nums.slice(0, calc.min(level, nums.len())).map(n => str(n)).join(".")
  }
}

#let heading-number-parts(level, nums) = {
  if nums.len() == 0 {
    (prefix: [], number: [], suffix: [])
  } else if level == 1 {
    (prefix: "第 ", number: str(nums.at(0)), suffix: " 章")
  } else if level == 4 {
    // 四级标题使用 (1), (2), (3) 格式
    (prefix: "(", number: str(nums.at(3)), suffix: ")")
  } else {
    (prefix: [], number: nums.slice(0, calc.min(level, nums.len())).map(n => str(n)).join("."), suffix: [])
  }
}

#let heading-number-run(number) = {
  text(font: fonts.hei-strict, size: 1.04em, baseline: 0.1em, cjk-latin-spacing: none)[#number]
}

#let heading-number-text(parts) = {
  [#text(font: fonts.hei-strict, cjk-latin-spacing: none)[#parts.prefix]#heading-number-run(parts.number)#text(font: fonts.hei-strict, cjk-latin-spacing: none)[#parts.suffix]]
}

#let heading-text(it) = {
  if it.numbering == none {
    if is-appendix-heading(it) {
      context {
        let nums = counter("appendix").at(it.location())
        [#appendix-number-text(nums)#h(0.3em)#it.body]
      }
    } else {
      it.body
    }
  } else {
    context {
      let parts = heading-number-parts(it.level, counter(heading).get())
      if it.level == 4 {
        // 四级标题使用宋体编号，与标题正文字体一致
        [#text(font: fonts.song, cjk-latin-spacing: none)[#parts.prefix#parts.number#parts.suffix]#h(0.3em)#it.body]
      } else {
        [#heading-number-text(parts)#h(0.3em)#it.body]
      }
    }
  }
}

#let current-heading() = context {
  let headings = query(selector(heading.where(level: 1)).before(here()))
  if headings.len() == 0 {
    []
  } else {
    let h = headings.last()
    if is-appendix-heading(h) {
      let nums = counter("appendix").at(h.location())
      let number = appendix-number-text(nums)
      if number != [] {
        [#number #h.body]
      } else {
        h.body
      }
    } else {
      let nums = counter(heading).at(h.location())
      let number = format-heading-number(1, nums)
      if h.numbering != none and number != [] {
        [#number #h.body]
      } else {
        h.body
      }
    }
  }
}
