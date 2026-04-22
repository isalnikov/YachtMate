# Captain Wrongel — Flutter app

Фаза 0: shell с нижней навигацией (пять вкладок), тема палубы, RU/EN, **Drift** + **`user_action_audit`**, **AppLogger**, Riverpod.

## Требования

- Flutter stable (локально или через [flutter-action](https://github.com/subosito/flutter-action) в CI).
- На **Linux** для юнит-тестов нужен системный SQLite: обычно уже есть как `libsqlite3.so.0`. Тестовый конфиг пробует типичные пути; при ошибке FFI установите пакет `libsqlite3-0` / `sqlite` для вашего дистрибутива.

## Команды

```bash
cd mobile
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # после смены Drift-схемы
flutter analyze
flutter test
flutter test --coverage
```

Покрытие (порог ≥90 % для `lib/domain/**` и `lib/data/**` при росте кодовой базы):

```bash
flutter test --coverage
lcov --remove coverage/lcov.info ... -o coverage/filtered.info   # см. coverage_exclusions.yaml
genhtml coverage/filtered.info -o coverage/html
```

## Структура (ориентир)

| Каталог | Назначение |
|---------|------------|
| `lib/core/` | тема, логирование, провайдеры |
| `lib/data/` | Drift, репозитории |
| `lib/features/` | экраны по фичам |
| `lib/l10n/` | ARB → генерируемые локализации |
