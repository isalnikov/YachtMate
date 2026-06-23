# Step 59 — Accessibility Audit

| | |
|---|---|
| **requires** | step-01–28 |
| **phase** | J |
| **est. files** | 4 |

## Goal

WCAG 2.1 AA pass: semantics, contrast, focus order on primary flows.

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `test/accessibility_semantics_test.dart`
- `fix contrast issues`

## OUT OF SCOPE

- Full external audit

## Tasks

- [ ] All map controls Semantics
- [ ] TalkBack labels primary tabs
- [ ] Contrast test tokens

## Acceptance Criteria

- [ ] Semantics tests pass

---

## AGENT PROMPT

```
Step 59 Captain Wrongel: Accessibility audit primary flows.
Requires step-01–28. Run flutter test.
```
