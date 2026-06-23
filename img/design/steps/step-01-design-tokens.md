# Step 01 — Design Tokens & ThemeExtension

| | |
|---|---|
| **requires** | — |
| **phase** | A |
| **est. files** | 4 |
| **est. tokens** | ~80k read + ~60k write |

## Goal

Создать единый слой дизайн-токенов `CwTokens` + `ThemeExtension` для цветов, радиусов и marine-data palette. Подключить к `CwTheme.material()`.

## Контекст (прочитать)

- `mobile/lib/core/theme/cw_theme.dart`
- `docs/ui/styles.css`
- `img/design/design-system-spec.md` §2–4

## IN SCOPE

- `mobile/lib/core/theme/cw_tokens.dart` — константы цветов, spacing, radius
- `mobile/lib/core/theme/cw_theme_extensions.dart` — `CwColors extends ThemeExtension`
- Обновить `cw_theme.dart` — подключить extensions
- `mobile/test/core/cw_tokens_test.dart` — smoke test цветов

## OUT OF SCOPE

- Виджеты, экраны
- Night mode (step-26)
- Шрифты (step-02)

## Tasks

- [ ] `CwSpacing`: xs=4, s=8, m=16, l=24, xl=32, xxl=48
- [ ] `CwRadius`: sm=8, md=16, lg=24
- [ ] `CwColors`: deckBlue, panelBlue, accentTeal, accentOrange, danger, safe, windScale List<Color>
- [ ] `ThemeData.extensions: [CwColors.light]`
- [ ] Helper `context.cwColors` extension on BuildContext
- [ ] `flutter test test/core/cw_tokens_test.dart`

## Acceptance Criteria

- [ ] `Theme.of(context).extension<CwColors>()` не null
- [ ] Существующие экраны не сломаны (compile)
- [ ] Все тесты проходят

---

## AGENT PROMPT

```
Ты Flutter-разработчик Captain Wrongel (mobile/).

Задача: Step 01 — Design Tokens.
Создай cw_tokens.dart и cw_theme_extensions.dart по спецификации img/design/design-system-spec.md.
Подключи ThemeExtension к CwTheme. Добавь context extension cwColors.
Напиши unit test. Запусти flutter test.

НЕ меняй экраны. НЕ добавляй виджеты. Только theme layer.
Прочитай: cw_theme.dart, design-system-spec.md §2-4.
```
