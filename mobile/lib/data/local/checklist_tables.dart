import 'package:drift/drift.dart';

/// Экземпляр чек-листа (прогресс по шаблону Фаза 7.4).
@DataClassName('ChecklistInstanceRow')
class ChecklistInstances extends Table {
  TextColumn get id => text()();

  TextColumn get templateKey => text()();

  /// [{\"id\":\"a\",\"label\":\"...\",\"done\":false}, ...]
  TextColumn get itemsJson => text()();

  IntColumn get updatedAtMs => integer()();

  BoolColumn get completed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>>? get primaryKey => {id};
}
