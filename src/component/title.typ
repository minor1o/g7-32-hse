#import "../utils.typ": fetch-field, unbreak-name
#import "performers.typ": performers-page

#let detailed-sign-field(title, name, position, year, day: none, month: none) = {
  assert(
    type(name) in (str, content),
    message: "Некорректный тип поля name в detailed-sign-field, должен быть строкой или контентом",
  )
  assert(
    type(position) in (str, content),
    message: "Некорректный тип поля position в detailed-sign-field, должен быть строкой или контентом",
  )
  assert(
    type(year) in (int, type(none)),
    message: "Некорректный тип поля year в detailed-sign-field, должен быть целым числом",
  )
  let year-cell = []
  let line-end = 7
  if year != none {
    year-cell = table.cell(align: right)[#year г.]
    line-end = 6
  }

  let day-val = if day != none { [#day] } else { [] }
  let month-val = if month != none { [#month] } else { [] }

  // @typstyle off
  box(width: 85%)[
  #table(
    stroke: none,
    align: left,
    inset: (x: 0%, y: 2pt),
    columns: (1fr, auto),
    table.cell(colspan: 2)[#upper(title)],
    table.cell(colspan: 2)[#position],

    // Row 3: Signature line and Name
    table.cell(stroke: (bottom: 0.5pt))[#h(1fr)],
    table.cell(align: right, inset: (left: 10pt))[#if type(name) == str { unbreak-name(name) } else { name }],

    // Row 5: Date line
    table.cell(colspan: 2, inset: (top: 5pt))[
      #table(
        stroke: none,
        columns: (12pt, 25pt, 12pt, 5pt, 55pt, 5pt, auto),
        align: (center, center, center, center, center, center, right),
        inset: (x: 0pt, y: 2pt),
        [«],
        table.cell(stroke: (bottom: 0.5pt))[#day-val],
        [»],
        [],
        table.cell(stroke: (bottom: 0.5pt))[#month-val],
        [],
        [#year-cell]
      )
    ]
  )
  ]
}

#let align-function = align

#let per-line(align: center, indent: 1fr, force-indent: false, ..values) = {
  let result = ()
  for value in values.pos() {
    let rule = false
    if type(value) in (array, dictionary) {
      let data = fetch-field(
        value,
        ("value*", "when-rule", "when-present", "rule"),
        default: (when-present: "always", when-rule: "always", rule: array.all),
        hint: "линии",
      )
      assert(
        not (data.when-rule != "always" and data.when-present != "always"),
        message: "Должно быть выбрано только одно правило пояивления when-rule или when-present",
      )
      if data.when-rule != "always" {
        rule = data.when-rule
      }
      if data.when-present != "always" {
        rule = (data.rule)((data.when-present,).flatten(), elem => elem != none)
      }
      if data.when-rule == "always" and data.when-present == "always" {
        rule = true
      }
      value = data.value
    } else {
      rule = value != none
    }
    if rule {
      result.push(value)
    }
  }

  if result != () {
    align-function(align)[
      #grid[#for elem in result { [#elem \ ] }]
    ]
  }
  if force-indent or result != () {
    v(indent)
  }
}

#let if-present(rule: array.all, indent: v(1fr), ..targets, body) = {
  assert(
    rule in (array.all, array.any),
    message: "Правило сравнения указано неверно, должно быть array.all или array.any",
  )
  let check = (target => target != none)
  if rule(targets.pos(), check) {
    body
    indent
  }
}

#let approved-field(approved-by) = {
  if approved-by.name != none [
    #detailed-sign-field(
      "согласовано",
      approved-by.name,
      approved-by.position,
      approved-by.year,
      day: approved-by.at("day", default: none),
      month: approved-by.at("month", default: none),
    )
  ]
}

#let agreed-field(agreed-by) = {
  if agreed-by.name != none [
    #detailed-sign-field(
      "утверждаю",
      agreed-by.name,
      agreed-by.position,
      agreed-by.year,
      day: agreed-by.at("day", default: none),
      month: agreed-by.at("month", default: none),
    )
  ]
}

#let approved-and-agreed-fields(approved-by, agreed-by) = {
  if-present(rule: array.any, approved-by.name, agreed-by.name)[
    #grid(
      columns: (1fr, 1fr),
      align: (left, left),
      gutter: 10pt,
      approved-field(approved-by), agreed-field(agreed-by),
    )
  ]
}
