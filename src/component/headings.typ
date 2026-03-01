#import "../constants.typ": default-heading-margin, is-hse

#let structural-heading-titles = (
  performers: [Список исполнителей],
  abstract: [Реферат],
  abstract-en: [Abstract],
  contents: [Содержание],
  terms: [Термины и определения],
  abbreviations: [Перечень сокращений и обозначений],
  intro: [Введение],
  conclusion: [Заключение],
  references: [Список использованных источников],
)

#let structure-heading-style = it => {
  align(center)[#upper(it)]
}

#let structure-heading(body) = {
  structure-heading-style(heading(numbering: none)[#body])
}

#let headings(text-size, indent, add-pagebreaks) = body => {
  show heading: set text(size: text-size)
  set heading(numbering: "1.1")

  show heading: it => {
    if it.body not in structural-heading-titles.values() {
      pad(it, left: indent)
    } else {
      it
    }
  }

  show heading.where(level: 1): it => {
    if add-pagebreaks {
      pagebreak(weak: true)
    }
    it
  }

  let structural-heading = structural-heading-titles
    .values()
    .fold(selector, (acc, i) => acc.or(heading.where(body: i, level: 1)))

  show structural-heading: set heading(numbering: none)
  show structural-heading: it => {
    if add-pagebreaks {
      pagebreak(weak: true)
    }
    structure-heading-style(it)
  }

  show heading: set block(..default-heading-margin)

  body
}

#let abbreviations(body) = {
  structure-heading(structural-heading-titles.abbreviations)
  context [В настоящем отчете о #if is-hse.get() [ВКР] else [НИР] применяют следующие сокращения и обозначения]

  set par(first-line-indent: 0pt)
  show std.terms: set std.terms(separator: [ — ], hanging-indent: 0pt, indent: 0pt)
  body
}

#let terms(body) = {
  structure-heading(structural-heading-titles.terms)
  context [В настоящем отчете о #if is-hse.get() [ВКР] else [НИР] применяют следующие термины с соответствующими определениями]

  set par(first-line-indent: 0pt)
  show std.terms: set std.terms(separator: [ — ], hanging-indent: 0pt, indent: 0pt)
  body
}
