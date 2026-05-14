#import "../src/export.typ": abbreviations, abstract, gost, terms


#import "../src/component/title-templates.typ": templates

#show: gost.with(
  title-template: templates.hse-thesis,
  faculty: "Факультет компьютерных наук",
  program: "Образовательная программа «Программная инженерия»",
  udk: "004.8",
  approved-by: (
    name: "И.О. Фамилия",
    position: "Научный руководитель",
    year: 2026,
  ),
  co-approved-by: (
    name: "И.О. Фамилия",
    position: "Cоруководитель",
    year: 2026,
  ),
  agreed-by: (
    name: "Н.А. Павлочев",
    position: "Академический руководитель образовательной программы «Программная инженерия»,
старший преподаватель департамента программной инженерии",
    year: 2026,
  ),
  thesis-type: "Выпускная квалификационная работа",
  thesis-subtype: "(академическая)",
  topic: "Название Работы",
  qualification: "09.03.04 «Программная инженерия»",
  performer: (
    group: "БПИ2**",
    name: "И.О. Фамилия",
    year: 2026,
  ),
  city: "Москва",
  year: 2026,
)

#abstract("слово1", "слово2")[
  Текст реферата
]

#abstract(lang: "en", "keyword1", "keyword2")[
  Referat text
]

#outline()

#include "myterms.typ"




= Введение
Текст введения

= Основная часть
== Состояние научной области
Тест ссылки @lang2024comprehensive

#include "vllm_table.typ"

Как видно из @vllm-quant-methods, поддержка сильно зависит от архитектуры...

#figure(
  include "unsloth_benchmarks.typ",
  caption: [Сравнение производительности моделей в бенчмарке Aider Polyglot (без механизмов рассуждения)],
) <fig-aider-benchmarks>


== Основание и исходные данные для исследования

== Актуальность и новизна темы исследования

== Объект исследования

== Цель исследования

== Задачи исследования

== Методология проведения исследования

== Ожидаемые новые результаты исследования

== Предполагаемое внедрение результатов исследования

== Значимость исследования

= Основные теоретические результаты, разработанные модели, методы, алгоритмы

== Разница между плотными и разреженными трансформерами

#figure(
  [
    #set text(size: 8pt)
    #scale(85%, reflow: true, include "qwen3_dense_moe.typ")
  ],
  caption: [Сравнение архитектур Dense (Qwen3-8B) и MoE (Qwen3-30B-A3B)],
) <fig-qwen3-arch>

== Подходы квантизации классических трансформеров

== Подходы квантизации разреженных трансформеров

== Разница в подходах квантизации для плотных

== Использование метрики важности слоев
@fig-qwen3-8b-layers

#figure(
  [
    #set text(size: 8pt)
    #scale(80%, reflow: true, include "qwen3_8b_layers.typ")
  ],
  caption: [Важность слоев Qwen3-8B (LIM)],
) <fig-qwen3-8b-layers>

#figure(
  [
    #set text(size: 8pt)
    #scale(80%, reflow: true, include "qwen3_30b_a3b_layers.typ")
  ],
  caption: [Важность слоев Qwen3-30B-A3B (LIM)],
) <fig-qwen3-30b-layers>


== Целевая функция

== Алгоритм подбора параметров квантизации

#include "standing_high_description.typ"

#figure(
  [
    #scale(80%, reflow: true, include "standing_high_pseudo.typ")
    #v(2em)
  ],
  caption: [Алгоритм автоматического подбора параметров квантизации Standing High],
  kind: image,
  supplement: [Рисунок],
) <fig-standing-high>

= Выбор средств реализации и/или эксперимента, особенности реализации, результаты

= Анализ полученных результатов

= Заключение

#bibliography("references.bib", style: "gost.csl")
