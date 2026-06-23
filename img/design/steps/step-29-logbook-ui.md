# Step 29 — Logbook Ui

| | |
|---|---|
| **requires** | step-01–07 |
| **phase** | G |
| **est. files** | 4 |

## Goal

Миграция logbook_screen на CwCard/CwListTile/CwEmptyState; CwAppBar; секции по категориям.

## Контекст

- `mobile/lib/features/` — целевой экран
- `docs/ui/` — HTML-референс
- `img/design/design-system-spec.md`

## IN SCOPE

- `mobile/lib/features/logbook/logbook_screen.dart`
- `widgets/logbook_entry_card.dart`
- `test/features/logbook_screen_test.dart`

## OUT OF SCOPE

- CRUD logic
- Drift schema

## Tasks

- [ ] CwCard per entry with category badge
- [ ] FAB add entry via CwButton
- [ ] Empty state
- [ ] Delete guard for crew role preserved

## Acceptance Criteria

- [ ] flutter test passes
- [ ] logbook CRUD works

---

## AGENT PROMPT

```
Step 29 Captain Wrongel: Refactor logbook_screen to design system. docs/ui/yacht.html reference.
Requires step-01–07. Run flutter test.
```
