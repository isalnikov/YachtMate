import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'app.dart';
import 'bootstrap/sqlite_mobile.dart';
import 'core/providers.dart';
import 'data/local/open_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureSqliteForMobile();

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
