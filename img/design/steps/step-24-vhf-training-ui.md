# Step 24 — VHF Training UI

| | |
|---|---|
| **requires** | step-04, step-06 |
| **phase** | E |
| **est. files** | 6 |

## Goal

Полировка `vhf_training_screen.dart`: scenario picker, dialogue cards, record button, quiz mode tabs.

## Контекст

- `mobile/lib/features/training/vhf_training_screen.dart`
- `mobile/assets/training/colreg_quiz_demo.json`
- `plan/features/F12-maritime-training-radio-colreg.md`

## IN SCOPE

- `mobile/lib/features/training/widgets/vhf_scenario_card.dart`
- `mobile/lib/features/training/widgets/vhf_dialogue_bubble.dart`
- `mobile/lib/features/training/widgets/vhf_record_button.dart`
- Tab: Scenarios | COLREG Quiz

## OUT OF SCOPE

- AI pronunciation scoring
- Real radio TX

## Tasks

- [ ] Scenario cards with difficulty
- [ ] Chat-style dialogue bubbles (shore / you)
- [ ] Record FAB with pulse
- [ ] Quiz: question card + 4 options

## Acceptance Criteria

- [ ] Audio record/playback still works
- [ ] STT integration preserved

---

## AGENT PROMPT

```
Step 24: VHF training UI — scenario cards, dialogue bubbles, quiz tab.
Рефактор vhf_training_screen. Сохрани record/STT. flutter test.
```
