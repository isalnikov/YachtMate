# Step 02 — Typography & TextTheme

| | |
|---|---|
| **requires** | step-01 |
| **phase** | A |
| **est. files** | 3 |

## Goal

Единый `CwTypography` + кастомный `TextTheme` в `CwTheme`: display, h1, h2, body, caption, button, monoCoords.

## Контекст

- `mobile/lib/core/theme/cw_tokens.dart` (step-01)
- `mobile/lib/core/theme/cw_theme.dart`
- `img/design/design-system-spec.md` §3

## IN SCOPE

- `mobile/lib/core/theme/cw_typography.dart`
- Обновить `cw_theme.dart` — `textTheme: CwTypography.textTheme()`
- `mobile/test/core/cw_typography_test.dart`

## OUT OF SCOPE

- Glove mode scaling (уже в app.dart — только убедиться совместимость)
- Custom font files (опционально `fontFamily: 'monospace'` для coords)

## Tasks

- [ ] TextStyle для display(28), h1(22), h2(18), body(16), caption(13), button(16 w600)
- [ ] `monoCoords` с `fontFeatures: [FontFeature.tabularFigures()]`
- [ ] onSurface colors из CwColors
- [ ] Test: TextTheme имеет все стили

## Acceptance Criteria

- [ ] `CwTypography.coords(context, lat, lon)` helper форматирует DD°MM.mmm'

---

## AGENT PROMPT

```
Step 02 Captain Wrongel: Typography.
Создай cw_typography.dart, подключи TextTheme к CwTheme.
Добавь helper formatCoords. Тесты. flutter test.
Requires step-01 (CwTokens/CwColors).
Не трогай экраны кроме импортов если нужно.
```
