# Step 17 — Mooring List & Filters

| | |
|---|---|
| **requires** | step-04, step-05 |
| **phase** | C |
| **est. files** | 6 |

## Goal

Navily-style mooring list: photo cards, filter chips, map/list toggle.

## Контекст

- `mobile/lib/features/mooring/mooring_screen.dart`
- `img/design/screenshot-findings.md` — Navily cards
- `docs/ui/mooring.html`

## IN SCOPE

- `mobile/lib/features/mooring/widgets/mooring_card.dart`
- `mobile/lib/features/mooring/widgets/mooring_filter_bar.dart`
- CwSegmentedControl Map/List
- Filter chips: Marina, Anchorage, Mooring buoy

## OUT OF SCOPE

- Detail sheet (step-18)
- Booking API

## Tasks

- [ ] MooringCard: 16:9 placeholder image, name, rating stars, depth chip
- [ ] Filter bar horizontal scroll
- [ ] List sort: distance / rating
- [ ] Empty state CwEmptyState

## Acceptance Criteria

- [ ] Mooring repository tests pass
- [ ] Search + filter work together

---

## AGENT PROMPT

```
Step 17: MooringCard, mooring_filter_bar, Map/List toggle.
Рефактор mooring_screen list mode. Navily-style cards. flutter test.
```
