// ignore_for_file: deprecated_member_use, experimental_member_use

import 'package:drift/web.dart';

import 'app_database.dart';

/// Браузер: sql.js + IndexedDB (см. `web/index.html` — загрузка initSqlJs).
Future<AppDatabase> openAppDatabase() async {
  final executor = WebDatabase.withStorage(
    DriftWebStorage.indexedDb('captain_wrongel_app'),
  );
  return AppDatabase(executor);
}
