# Step 57 — Wind Particles

| | |
|---|---|
| **requires** | step-47 |
| **phase** | J |
| **est. files** | 4 |

## Goal

Animated wind particles on map or weather (Windy-style, GPU-friendly).

## Контекст

- См. `plan/features/` для доменной логики
- `img/design/screenshot-findings.md` где применимо

## IN SCOPE

- `map_wind_particles_layer.dart`
- `reduceMotion respect`

## OUT OF SCOPE

- Full ECMWF grid

## Tasks

- [ ] Particle field from wind vectors
- [ ] Pause in eco mode

## Acceptance Criteria

- [ ] Animation smooth 30fps on mid device

---

## AGENT PROMPT

```
Step 57 Captain Wrongel: Wind particle animation step-15 post-MVP.
Requires step-47. Run flutter test.
```
