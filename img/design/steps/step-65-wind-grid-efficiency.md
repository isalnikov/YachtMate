# Step 65 — Wind Grid Efficiency

| | |
|---|---|
| **requires** | step-62 |
| **phase** | L |
| **est. files** | 5 |

## Goal

Eco profile uses 1 wind cell; parallel fetch; map wind toggle on weather screen.

## Acceptance Criteria

- [ ] `loadWindGrid` eco => 1 cell
- [ ] Parallel `Future.wait` for grid cells
- [ ] Weather screen toggles map wind overlay
