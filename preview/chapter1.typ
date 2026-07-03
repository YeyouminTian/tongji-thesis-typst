#import "../vendor/gb7714-bilingual/lib.typ": init-gb7714
#import "../lib.typ": tongji-thesis, mainmatter, references
#import "../metadata.typ": bibliography-standard-version, thesis-info

#show: init-gb7714.with(read("../references.bib"), style: "numeric", version: bibliography-standard-version, show-url: false, show-doi: false)
#show: body => tongji-thesis(info: thesis-info)[#body]

#mainmatter[
  #include "../chapters/chapter1.typ"
]

#references(bib: "references.bib")
