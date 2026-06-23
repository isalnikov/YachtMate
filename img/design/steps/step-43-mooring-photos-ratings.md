# Step 43 — Mooring Photos Ratings

| | |
|---|---|
| **requires** | step-17–18 |
| **phase** | H |
| **est. files** | 4 |

## Goal

MooringCard real image URLs from catalog; aggregate ratings from reviews.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `mooring_card.dart network images`
- `mooring_rating_aggregator.dart`

## OUT OF SCOPE

- Booking API
- Navily sync

## Tasks

- [ ] CachedNetworkImage or Image.network
- [ ] Placeholder on fail
- [ ] Rating from review drafts + seed

## Acceptance Criteria

- [ ] Cards show photos when URL in GeoJSON

---

## AGENT PROMPT

```
Step 43 Captain Wrongel: Mooring photos + computed ratings. F05.
Requires step-17–18. Run flutter test.
```
