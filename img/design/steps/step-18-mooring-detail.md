# Step 18 — Mooring Detail Sheet

| | |
|---|---|
| **requires** | step-17, step-06 |
| **phase** | C |
| **est. files** | 5 |

## Goal

Редизайн `mooring_detail_sheet.dart`: hero photo, services chips, reviews, «Navigate» CTA.

## Контекст

- `mobile/lib/features/mooring/mooring_detail_sheet.dart`
- `plan/features/F05-marinas-anchorages-booking.md`

## IN SCOPE

- Refactor mooring_detail_sheet
- `mobile/lib/features/mooring/widgets/mooring_review_section.dart`
- Deep link to map with target coords

## OUT OF SCOPE

- In-app booking form
- Photo upload

## Tasks

- [ ] Draggable sheet 60% height
- [ ] Services: water, electricity, wifi chips
- [ ] Review draft UI preserved
- [ ] CwButton «Navigate» → switch to map tab + pan

## Acceptance Criteria

- [ ] Review sync tests pass

---

## AGENT PROMPT

```
Step 18: Mooring detail sheet redesign — hero, services chips, navigate CTA.
mooring_review_section. flutter test.
```
