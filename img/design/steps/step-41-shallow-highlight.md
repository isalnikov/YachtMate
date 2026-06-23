# Step 41 — Shallow Highlight

| | |
|---|---|
| **requires** | step-39 |
| **phase** | H |
| **est. files** | 4 |

## Goal

Shallow highlight: tint depth grid cells < vessel draft + clearance.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `shallow_highlight_layer.dart`
- `navigation_layers_depth_grid.dart hook`

## OUT OF SCOPE

- New bathymetry provider

## Tasks

- [ ] Use vesselPrefsProvider draft
- [ ] Yellow tint from CwPalette.depthShallow
- [ ] Toggle from layer sheet

## Acceptance Criteria

- [ ] Shallow toggle visible on demo depth layer

---

## AGENT PROMPT

```
Step 41 Captain Wrongel: Implement shallow water highlight from prefs + vessel draft.
Requires step-39. Run flutter test.
```
