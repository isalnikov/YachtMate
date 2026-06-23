# Step 60 — Performance Ui

| | |
|---|---|
| **requires** | step-01–28 |
| **phase** | J |
| **est. files** | 4 |

## Goal

UI perf: skeleton everywhere, repaint boundaries on map overlays, jank test.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `RepaintBoundary on heavy widgets`
- `performance_overlay dev flag`

## OUT OF SCOPE

- Backend perf

## Tasks

- [ ] Map overlay isolated
- [ ] ListView cacheExtent tuned
- [ ] Document budget in design/performance.md

## Acceptance Criteria

- [ ] No regression flutter test

---

## AGENT PROMPT

```
Step 60 Captain Wrongel: UI performance budget and optimizations.
Requires step-01–28. Run flutter test.
```
