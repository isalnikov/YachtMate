# Step 48 — Offline Chart Manager

| | |
|---|---|
| **requires** | step-10 |
| **phase** | H |
| **est. files** | 4 |

## Goal

Settings UI: download/delete chart regions; show storage size; queue.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `offline_chart_manager_screen.dart`
- `chart_regions Drift table UI`

## OUT OF SCOPE

- Actual tile CDN billing
- ENC license

## Tasks

- [ ] List chart_regions table
- [ ] Download progress
- [ ] Delete region

## Acceptance Criteria

- [ ] Region list CRUD works with existing schema

---

## AGENT PROMPT

```
Step 48 Captain Wrongel: Offline chart region manager UI. F01.
Requires step-10. Run flutter test.
```
