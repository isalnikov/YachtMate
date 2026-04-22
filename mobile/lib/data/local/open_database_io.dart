import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'app_database.dart';

/// Нативный SQLite (Android/iOS/desktop/tests).
Future<AppDatabase> openAppDatabase() async {
  final dir = await getApplicationDocumentsDirectory();
  final file = File(p.join(dir.path, 'app.db'));
  final executor = LazyDatabase(() async {
    return NativeDatabase.createInBackground(file);
  });
  return AppDatabase(executor);
}
