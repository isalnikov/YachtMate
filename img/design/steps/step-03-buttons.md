# Step 03 — CwButton Family

| | |
|---|---|
| **requires** | step-01, step-02 |
| **phase** | A |
| **est. files** | 5 |

## Goal

Унифицированные кнопки: primary, secondary, tertiary, icon, danger. Размеры sm/md/lg/xl (glove). States: default, pressed, disabled, loading.

## Контекст

- `mobile/lib/core/theme/cw_tokens.dart`
- `mobile/lib/app.dart` — glove mode button sizes
- `img/design/screenshot-findings.md` — Navionics circular FABs

## IN SCOPE

- `mobile/lib/widgets/cw_button.dart` — CwButton, CwIconButton, CwFab
- `mobile/lib/widgets/cw_button_sizes.dart` — enum CwButtonSize
- `mobile/test/widgets/cw_button_test.dart`
- Заменить 2–3 `ElevatedButton` в `settings_screen.dart` как proof-of-use

## OUT OF SCOPE

- Полная миграция всех экранов
- Map FABs (step-09)

## Tasks

- [ ] CwButton.variant: primary|secondary|tertiary|danger
- [ ] Min height: md=44, lg=52 (glove)
- [ ] Loading: CircularProgressIndicator вместо label
- [ ] CwFab: circular 48/56dp, teal fill
- [ ] Widget tests: tap, disabled, loading

## Acceptance Criteria

- [ ] Semantics label на всех кнопках
- [ ] HapticFeedback.lightImpact on press

---

## AGENT PROMPT

```
Step 03: Создай CwButton, CwIconButton, CwFab в mobile/lib/widgets/.
Используй CwTokens/CwTypography. Размеры sm/md/lg/xl.
Замени несколько кнопок в settings_screen как пример. Widget tests. flutter test.
```
