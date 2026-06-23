# Step 30 — Track Ui

| | |
|---|---|
| **requires** | step-01–07 |
| **phase** | G |
| **est. files** | 4 |

## Goal

Track screen: stats card, start/stop CwButton danger/safe, recording indicator.

## Контекст

- `mobile/lib/features/` — целевой экран
- `docs/ui/` — HTML-референс
- `img/design/design-system-spec.md`

## IN SCOPE

- `track_screen.dart`
- `widgets/track_stats_card.dart`
- `track_screen_test.dart`

## OUT OF SCOPE

- Map overlay logic

## Tasks

- [ ] Recording pulse indicator
- [ ] Point count + duration
- [ ] CwEmptyState when no trips

## Acceptance Criteria

- [ ] track tests pass

---

## AGENT PROMPT

```
Step 30 Captain Wrongel: Polish track_screen with Cw components.
Requires step-01–07. Run flutter test.
```
