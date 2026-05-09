#let get(info, key, default: "") = {
  info.at(key, default: default)
}

#let thesis-kind(info) = {
  let degree = get(info, "degree", default: "硕士")
  if degree == "博士" {
    "博士学位论文"
  } else {
    "硕士学位论文"
  }
}

#let degree-type(info) = {
  let degree-type = get(info, "degree_type", default: "学术学位")
  if degree-type == "" {
    none
  } else {
    [（#degree-type）]
  }
}

#let joined(values, sep: "，") = {
  if values == none or values.len() == 0 {
    ""
  } else {
    values.join(sep)
  }
}
