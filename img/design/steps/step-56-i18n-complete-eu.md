# Step 56 — I18N Complete Eu

| | |
|---|---|
| **requires** | step-55 |
| **phase** | J |
| **est. files** | 6 |

## Goal

Fill DE/FR/ES/IT untranslated strings (grep English in arb).

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `app_de.arb`
- `app_fr.arb`
- `app_es.arb`
- `app_it.arb`

## OUT OF SCOPE

- New feature strings until translated

## Tasks

- [ ] Script or test: no English leftovers in non-en arbs for key screens

## Acceptance Criteria

- [ ] i18n completeness test

---

## AGENT PROMPT

```
Step 56 Captain Wrongel: Complete EU locale translations.
Requires step-55. Run flutter test.
```
