# ADR 0001 — Мобильный стек Captain Wrongel

**Статус:** принято  
**Дата:** 2026-04-22  

## Контекст

Нужен offline-first навигатор с картами, SQLite, NMEA/AIS и долгосрочной эволюцией модулей M1–M14.

## Решение

- **Flutter** (Dart): один код на iOS/Android, зрелая экосистема карт и платформенных API.
- **Drift** для SQLite и миграций (включая **`user_action_audit`**).
- **Riverpod** для состояния и DI.
- **MapLibre** — на Фазе 1 (интеграция после bootstrap).

## Последствия

- CI: `flutter analyze`, `flutter test --coverage`, порог покрытия для domain/data при росте кодовой базы.
- Генерация кода Drift: `dart run build_runner build` при изменении схемы.

## Альтернативы

- React Native — менее единообразный доступ к MapLibre и нативным потокам NMEA.
- KMP только Android — отвергнуто из‑за требования iOS в продуктовой спецификации.
