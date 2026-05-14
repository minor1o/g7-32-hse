#import "../component/title.typ": agreed-field, detailed-sign-field, per-line
#import "../utils.typ": fetch-field, sign-field, unbreak-name
#import "../constants.typ": is-hse

#let arguments(..args, year: auto) = {
  let args = args.named()

  args.insert("faculty", args.at("faculty", default: none))
  args.insert("program", args.at("program", default: none))
  args.insert("udk", args.at("udk", default: none))
  args.insert("thesis-type", args.at("thesis-type", default: "Выпускная квалификационная работа"))
  args.insert("thesis-subtype", args.at("thesis-subtype", default: none))
  args.insert("topic", args.at("topic", default: none))
  args.insert("qualification", args.at("qualification", default: none))

  args.insert("approved-by", fetch-field(
    args.at("approved-by", default: none),
    ("name*", "position*", "year", "day", "month"),
    default: (year: auto),
    hint: "согласования",
  ))

  args.insert("agreed-by", fetch-field(
    args.at("agreed-by", default: none),
    ("name*", "position*", "year", "day", "month"),
    default: (year: auto),
    hint: "утверждения",
  ))

  args.insert("co-approved-by", fetch-field(
    args.at("co-approved-by", default: none),
    ("name*", "position*", "year", "day", "month"),
    default: (year: auto),
    hint: "согласования (соруководитель)",
  ))

  args.insert("performer", fetch-field(
    args.at("performer", default: (:)),
    ("group*", "name*", "date", "year", "day", "month"),
    default: (year: auto),
    hint: "студента",
  ))

  if args.approved-by.year == auto {
    args.approved-by.year = year
  }
  if args.co-approved-by.year == auto {
    args.co-approved-by.year = year
  }
  if args.agreed-by.year == auto {
    args.agreed-by.year = year
  }
  if args.performer.year == auto {
    args.performer.year = year
  }

  args.insert("year", year)
  args.insert("city", args.at("city", default: none))
  return args
}

#let template(
  faculty: none,
  program: none,
  udk: none,
  thesis-type: none,
  thesis-subtype: none,
  topic: none,
  qualification: none,
  approved-by: (name: none, position: none, year: auto),
  co-approved-by: (name: none, position: none, year: auto),
  agreed-by: (name: none, position: none, year: auto),
  performer: (group: none, name: none, date: none),
  city: none,
  year: none,
  ..args,
) = {
  is-hse.update(true)
  set text(size: 14pt)

  align(center)[
    #text(weight: "bold")[ПРАВИТЕЛЬСТВО РОССИЙСКОЙ ФЕДЕРАЦИИ] \
    #text(weight: "bold")[ФЕДЕРАЛЬНОЕ ГОСУДАРСТВЕННОЕ АВТОНОМНОЕ] \
    #text(weight: "bold")[ОБРАЗОВАТЕЛЬНОЕ УЧРЕЖДЕНИЕ ВЫСШЕГО ОБРАЗОВАНИЯ] \
    #text(weight: "bold")[НАЦИОНАЛЬНЫЙ ИССЛЕДОВАТЕЛЬСКИЙ УНИВЕРСИТЕТ] \
    #text(weight: "bold")[«ВЫСШАЯ ШКОЛА ЭКОНОМИКИ»]
  ]

  v(1cm)

  align(center)[
    #faculty \
    #program
  ]

  v(10fr)

  if udk != none {
    block(width: 100%, align(left)[УДК #udk])
    v(5pt)
  }

  if agreed-by.name != none [
    #grid(
      columns: (1fr, 1fr),
      [], agreed-field(agreed-by),
    )
  ]

  v(10fr)

  align(center)[
    #text(weight: "bold")[#thesis-type] \
    #if thesis-subtype != none [#thesis-subtype \ ]
    на тему 
    #text(weight: "bold")[#topic] \
    по направлению подготовки #unbreak-name(qualification) 

  ]
  
  v(10fr)
  
  grid(
    columns: (1fr, 1fr),
    align: top,
    gutter: 10pt,
    stack(
      spacing: 1em,
      if approved-by.name != none {
        detailed-sign-field(
          "Научный руководитель",
          approved-by.name,
          if approved-by.position != "Научный руководитель" { approved-by.position } else { none },
          approved-by.year,
          day: approved-by.at("day", default: none),
          month: approved-by.at("month", default: none),
        )
      },
      if co-approved-by.at("name", default: none) != none {
        detailed-sign-field(
          "Соруководитель",
          co-approved-by.name,
          if co-approved-by.position not in ("Научный соруководитель", "Cоруководитель") {
            co-approved-by.position
          } else { none },
          co-approved-by.year,
          day: co-approved-by.at("day", default: none),
          month: co-approved-by.at("month", default: none),
        )
      },
    ),
    stack(
      detailed-sign-field(
        "ВЫПОЛНИЛ",
        performer.name,
        [студент группы #performer.group \ образовательной программы \ #unbreak-name(qualification)],
        if performer.year != none { int(performer.year) } else { none },
        day: performer.at("day", default: none),
        month: performer.at("month", default: none),
      ),
    ),
  )

  v(1fr)
}
