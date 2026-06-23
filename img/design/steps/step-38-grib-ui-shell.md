# Step 38 — Grib Ui Shell

| | |
|---|---|
| **requires** | step-01–07 |
| **phase** | G |
| **est. files** | 4 |

## Goal

GRIB screen: file picker UI, download progress, list of imports (decoder step-44).

## Контекст

- `mobile/lib/features/` — целевой экран
- `docs/ui/` — HTML-референс
- `img/design/design-system-spec.md`

## IN SCOPE

- `grib_import_screen.dart`
- `widgets/grib_file_list.dart`
- `grib_ui_test.dart`

## OUT OF SCOPE

- GRIB decode

## Tasks

- [ ] CwCard per file
- [ ] Import CwButton
- [ ] Empty state with CTA

## Acceptance Criteria

- [ ] path stub still works until step-44

---

## AGENT PROMPT

```
Step 38 Captain Wrongel: GRIB import shell UI ready for decoder.
Requires step-01–07. Run flutter test.
```
