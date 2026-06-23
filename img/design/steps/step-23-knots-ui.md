# Step 23 — Knots Reference UI

| | |
|---|---|
| **requires** | step-04 |
| **phase** | E |
| **est. files** | 5 |

## Goal

Редизайн knots hub + detail: категории chips, step-by-step instructions, favorite toggle.

## Контекст

- `mobile/lib/features/reference/knots_hub_screen.dart`
- `mobile/lib/features/reference/knot_detail_screen.dart`
- `mobile/assets/reference/knots_demo.json`
- Knot Guide competitor patterns

## IN SCOPE

- `mobile/lib/features/reference/widgets/knot_category_chips.dart`
- `mobile/lib/features/reference/widgets/knot_step_list.dart`
- Refactor hub + detail screens

## OUT OF SCOPE

- 3D knot visualization
- SVG illustrations (use placeholder icons)

## Tasks

- [ ] Category filter chips horizontal
- [ ] Knot card: name, difficulty badge, use-case caption
- [ ] Detail: numbered steps CwListTile
- [ ] Favorite star icon (local pref)

## Acceptance Criteria

- [ ] All demo knots navigable
- [ ] Search filter in hub

---

## AGENT PROMPT

```
Step 23: Knots UI — category chips, step list, favorites.
Рефактор knots_hub + knot_detail. flutter test.
```
