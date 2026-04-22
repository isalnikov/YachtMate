import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:uuid/uuid.dart';

import 'app.dart';
import 'core/providers.dart';
import 'data/local/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isAndroid) {
    await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
  }

  final prefs = await SharedPreferences.getInstance();
  final db = await openAppDatabase();
  final sessionId = const Uuid().v4();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) {
          ref.onDispose(db.close);
          return db;
        }),
        sessionIdProvider.overrideWith((ref) => sessionId),
      ],
      child: const CaptainWrongelApp(),
    ),
  );
}
