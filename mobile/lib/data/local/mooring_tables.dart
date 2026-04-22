import 'package:drift/drift.dart';

/// Марина или якорная стоянка (Фаза 6).
@DataClassName('MooringPlaceRow')
class MooringPlaces extends Table {
  TextColumn get id => text()();

  TextColumn get kind => text()();

  TextColumn get name => text()();

  RealColumn get lat => real()();

  RealColumn get lon => real()();

  TextColumn get vhf => text().nullable()();

  TextColumn get phone => text().nullable()();

  TextColumn get email => text().nullable()();

  TextColumn get websiteUrl => text().nullable()();

  /// Партнёрское бронирование или веб-форма (deeplink).
  TextColumn get bookingUrl => text().nullable()();

  /// JSON: electricity, water, wifi, showers — флаги для карточки.
  TextColumn get servicesJson => text().nullable()();

  TextColumn get notes => text().nullable()();

  /// Версия строки каталога для merge при импорте пакетов (новее побеждает).
  IntColumn get sourceUpdatedAtMs => integer().nullable()();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}

/// Черновик отзыва в офлайн-очереди (синхронизация — позже).
@DataClassName('MooringReviewDraftRow')
class MooringReviewDrafts extends Table {
  TextColumn get id => text()();

  TextColumn get placeId => text()();

  IntColumn get stars => integer()();

  TextColumn get comment => text().nullable()();

  IntColumn get createdAtMs => integer()();

  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
