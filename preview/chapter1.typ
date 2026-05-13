#import "../lib.typ": tongji-thesis, mainmatter, references
#import "../metadata.typ": thesis-info

#show: body => tongji-thesis(info: thesis-info)[#body]

#mainmatter[
  #include "../chapters/chapter1.typ"
]

#references(bib: "references.bib")
