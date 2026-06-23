# Step 04 — Cards, Lists, Badges, Chips

| | |
|---|---|
| **requires** | step-01, step-02 |
| **phase** | A |
| **est. files** | 6 |

## Goal

`CwCard`, `CwListTile`, `CwBadge`, `CwChip`, `CwSectionHeader` — базовые data-display компоненты.

## Контекст

- `docs/ui/styles.css` — .card, .badge
- `mobile/lib/features/mooring/mooring_screen.dart` — текущие Card

## IN SCOPE

- `mobile/lib/widgets/cw_card.dart`
- `mobile/lib/widgets/cw_list_tile.dart`
- `mobile/lib/widgets/cw_chip.dart`
- `mobile/test/widgets/cw_card_test.dart`
- Рефактор `more_menu_screen.dart` — использовать CwCard для пунктов меню

## OUT OF SCOPE

- MooringCard специализированный (step-17)

## Tasks

- [ ] CwCard: elevation 0, border 1px teal 12%, radius md, padding m
- [ ] CwChip: selected/unselected, filter variant
- [ ] CwBadge: danger/safe/info variants
- [ ] CwListTile: two-line, trailing icon

## Acceptance Criteria

- [ ] More menu визуально согласован с docs/ui/more.html

---

## AGENT PROMPT

```
Step 04: CwCard, CwListTile, CwChip, CwBadge, CwSectionHeader.
Рефактор more_menu_screen на новые компоненты. Tests. flutter test.
```
