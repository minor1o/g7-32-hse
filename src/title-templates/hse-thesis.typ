#import "../component/title.typ": approved-and-agreed-fields, detailed-sign-field, per-line
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

  args.insert("performer", fetch-field(
    args.at("performer", default: (:)),
    ("group*", "name*", "date", "year", "day", "month"),
    default: (year: auto),
    hint: "студента",
  ))

  if args.approved-by.year == auto {
    args.approved-by.year = year
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

  v(1fr)

  if udk != none {
    block(width: 100%, align(left)[УДК #udk])
    v(0.5cm)
  }

  approved-and-agreed-fields(approved-by, agreed-by)

  v(1fr)

  align(center)[
    #text(weight: "bold")[#thesis-type] \
    #if thesis-subtype != none [#thesis-subtype \ ]
    на тему: #text(weight: "bold")[#topic] \
    по направлению подготовки #unbreak-name(qualification)
  ]

  v(1fr)

  grid(
    columns: (1fr, 1fr),
    [],
    detailed-sign-field(
      "ВЫПОЛНИЛ",
      performer.name,
      [студент группы #performer.group \ образовательной программы \ #unbreak-name(qualification)],
      if performer.year != none { int(performer.year) } else { none },
      day: performer.at("day", default: none),
      month: performer.at("month", default: none),
    ),
  )

  v(1fr)
}
