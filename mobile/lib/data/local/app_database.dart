import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'app_database.g.dart';

/// Logical DDL: [Подробный план реализации.md] §5.2 — `user_action_audit`.
class UserActionAudits extends Table {
  IntColumn get id => integer().autoIncrement()();

  IntColumn get t => integer()();

  TextColumn get sessionId => text()();

  TextColumn get module => text()();

  TextColumn get action => text()();

  TextColumn get severity => text().withDefault(const Constant('info'))();

  TextColumn get contextJson => text().nullable()();
}

@DriftDatabase(tables: [UserActionAudits])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.executor);

  @override
  int get schemaVersion => 1;
}

/// Opens [AppDatabase] on a SQLite file under application documents.
Future<AppDatabase> openAppDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'app.db'));
  final executor = LazyDatabase(() async {
    return NativeDatabase.createInBackground(file);
  });
  return AppDatabase(executor);
}
