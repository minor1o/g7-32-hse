#import "headings.typ": structural-heading-titles

#let get-count(kind) = {
  assert(
    kind in (page, image, table, ref, "appendix", "chapter"),
    message: "Невозможно определить количество этих элементов",
  )
  let target-counter = none
  if kind == page {
    target-counter = counter(page)
  } else if kind == "appendix" {
    target-counter = counter("appendix")
  } else if kind == image {
    target-counter = counter("image")
  } else if kind == table {
    target-counter = counter("table")
  } else if kind == "chapter" {
    return query(heading.where(level: 1)).filter(it => it.numbering != none).len()
  }

  if kind == ref {
    return query(selector(ref)).filter(it => it.element == none).map(it => it.target).dedup().len()
  } else {
    return target-counter.final().first()
  }
}

#let russian-plural(count, one, few, many) = {
  let rem10 = calc.rem(count, 10)
  let rem100 = calc.rem(count, 100)
  if rem10 == 1 and rem100 != 11 { one } else if rem10 >= 2 and rem10 <= 4 and (rem100 < 10 or rem100 >= 20) {
    few
  } else { many }
}

#let abstract(
  lang: "ru",
  count: true,
  ..keywords,
  body,
) = {
  let (title, prefix, keywords-label, items) = if lang == "en" {
    (
      [Abstract],
      "The paper contains",
      "Key words:",
      (
        page: ("sheet", "sheets", "sheets"),
        chapter: ("chapter", "chapters", "chapters"),
        image: ("illustration", "illustrations", "illustrations"),
        ref: ("source", "sources", "sources"),
        table: ("table", "tables", "tables"),
        appendix: ("appendix", "appendixes", "appendixes"),
      ),
    )
  } else {
    (
      structural-heading-titles.abstract,
      "Выпускная квалификационная работа содержит",
      "Ключевые слова:",
      (
        page: ("с.", "с.", "с."),
        chapter: ("главу", "главы", "глав"),
        image: ("иллюстрацию", "иллюстрации", "иллюстраций"),
        ref: ("источник", "источника", "источников"),
        table: ("таблицу", "таблицы", "таблиц"),
        appendix: ("приложение", "приложения", "приложений"),
      ),
    )
  }

  [
    #heading(title, numbering: none, outlined: false) <abstract>
    #context if count {
      let stats = ()
      let p = get-count(page)
      stats.push([#p #russian-plural(p, ..items.page)])

      let ch = get-count("chapter")
      if ch > 0 { stats.push([#ch #russian-plural(ch, ..items.chapter)]) }

      let img = get-count(image)
      if img > 0 { stats.push([#img #russian-plural(img, ..items.image)]) }

      let r = get-count(ref)
      if r > 0 { stats.push([#r #russian-plural(r, ..items.ref)]) }

      let t = get-count(table)
      if t > 0 { stats.push([#t #russian-plural(t, ..items.table)]) }

      let app = get-count("appendix")
      if app > 0 { stats.push([#app #russian-plural(app, ..items.appendix)]) }

      let separator = if lang == "en" { " and " } else { " и " }
      [#prefix #stats.join(", ", last: separator).]
    }

    #{
      set par(first-line-indent: 0pt)
      [#strong(keywords-label) #upper(keywords.pos().join(", "))]
    }

    #v(1em)

    #text(body)
  ]
}
