# Step 21 — SOS Emergency UI

| | |
|---|---|
| **requires** | step-03, step-06 |
| **phase** | D |
| **est. files** | 5 |

## Goal

Полировка `sos_screen.dart`: big red button, emergency type picker, timer, coords preview.

## Контекст

- `mobile/lib/features/distress/sos_screen.dart`
- `mobile/lib/domain/distress/sos_message_formatter.dart`
- `img/design/design-system-spec.md` — Emergency button

## IN SCOPE

- `mobile/lib/features/distress/widgets/sos_emergency_panel.dart`
- `mobile/lib/features/distress/widgets/sos_type_selector.dart`
- `mobile/lib/features/distress/widgets/sos_timer_display.dart`
- Refactor sos_screen

## OUT OF SCOPE

- Real SAR API
- SafeTrx shore monitoring

## Tasks

- [ ] SOS button: 120dp circle, pulsing animation (respect reduceMotion)
- [ ] Type chips: Medical, Fire, Sinking, Man overboard
- [ ] 2-step confirm preserved
- [ ] Timer after send
- [ ] Coords + time in message preview

## Acceptance Criteria

- [ ] Test mode still works
- [ ] Two-step gate cannot be skipped

---

## AGENT PROMPT

```
Step 21: SOS UI polish — emergency panel, type selector, timer.
Сохрани 2-step confirm и test mode. flutter test.
```
