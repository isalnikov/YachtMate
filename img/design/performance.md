# UI Performance Budget — Captain Wrongel

Phase J (step 60). Targets mid-range Android/iOS devices at 60 Hz display.

## Frame budget

| Surface | Target | Notes |
|---------|--------|-------|
| Map tab (idle) | ≤ 16 ms/frame | Overlays isolated with `RepaintBoundary` |
| Map wind particles | ~30 fps | Ticker pauses in eco mode and when `MediaQuery.disableAnimations` |
| Shell tab switch | ≤ 1 frame jank | `KeyedSubtree` per tab body |
| More menu scroll | smooth 60 fps | `ListView(cacheExtent: 480)` |

## Repaint boundaries

- `MapControlsOverlay` — map chrome (zoom, compass, layers)
- `MapWindParticlesLayer` — animated wind streaks
- Map status pill / GPS indicator (existing)

## Dev tooling

- `devPerformanceOverlay` preference toggles Flutter `showPerformanceOverlay` in `CaptainWrongelApp`.
- Use profile mode + DevTools Timeline for regression checks after map/layer changes.

## List / scroll

- Long settings and More menus: `cacheExtent` tuned to ~3 screens to reduce rebuild churn without excessive memory.

## Out of scope (this doc)

- Backend / API latency
- GRIB decode throughput
- MapLibre tile fetch and offline pack size

## Regression gate

`flutter test` must pass with no new framework errors on disclaimer → shell flows.
