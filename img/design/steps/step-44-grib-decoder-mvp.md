# Step 44 — Grib Decoder Mvp

| | |
|---|---|
| **requires** | step-38 |
| **phase** | H |
| **est. files** | 5 |

## Goal

MVP GRIB2 parse: wind U/V at point, display in grib screen + optional map overlay hook.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `domain/grib/grib_decoder.dart`
- `grib_import_screen.dart wire decode`
- `grib_decoder_test.dart`

## OUT OF SCOPE

- Full GRIB animation
- Route optimization

## Tasks

- [ ] Parse single GRIB file wind
- [ ] Show grid metadata
- [ ] Store parsed cache in Drift

## Acceptance Criteria

- [ ] Import + parse test file passes

---

## AGENT PROMPT

```
Step 44 Captain Wrongel: GRIB decoder MVP per F10. Replace stub.
Requires step-38. Run flutter test.
```
