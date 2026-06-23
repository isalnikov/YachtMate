# Step 06 — Feedback: Sheets, Dialogs, Empty States

| | |
|---|---|
| **requires** | step-01–04 |
| **phase** | A |
| **est. files** | 6 |

## Goal

`CwBottomSheet`, `CwDialog`, `CwSnackBar`, `CwEmptyState`, `CwErrorState`, `CwLoadingSkeleton`.

## Контекст

- `mobile/lib/features/map/map_layer_sheet.dart`
- `img/design/screenshot-findings.md` — Navionics Map Options sheet

## IN SCOPE

- `mobile/lib/widgets/cw_bottom_sheet.dart` — showCwBottomSheet()
- `mobile/lib/widgets/cw_empty_state.dart`
- `mobile/lib/widgets/cw_error_state.dart`
- `mobile/lib/widgets/cw_loading_skeleton.dart`
- Рефактор `map_layer_sheet.dart` на CwBottomSheet wrapper

## OUT OF SCOPE

- Map layer grid content (step-10)

## Tasks

- [ ] Sheet: drag handle, title, close X, maxHeight 50%
- [ ] EmptyState: icon + title + CTA button
- [ ] Skeleton: shimmer для list cards
- [ ] CwDialog: confirm/danger variants

## Acceptance Criteria

- [ ] map_layer_sheet использует единый wrapper

---

## AGENT PROMPT

```
Step 06: CwBottomSheet, CwEmptyState, CwErrorState, CwLoadingSkeleton, CwDialog.
Рефактор map_layer_sheet на showCwBottomSheet. Widget tests. flutter test.
```
