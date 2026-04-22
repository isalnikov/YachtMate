import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'app.dart';
import 'bootstrap/sqlite_mobile.dart';
import 'core/logging/app_logger.dart';
import 'core/logging/global_error_logging.dart' show RiverpodErrorObserver, installGlobalErrorLogging;
import 'core/providers.dart';
import 'data/local/open_database.dart';

void main() {
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    installGlobalErrorLogging(AppLogger('global'));
    AppLogger('bootstrap').info('Global error logging installed');

    await configureSqliteForMobile();

    final prefs = await SharedPreferences.getInstance();
    final db = await openAppDatabase();
    final sessionId = const Uuid().v4();

    runApp(
      ProviderScope(
        observers: [RiverpodErrorObserver(AppLogger('riverpod'))],
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
  }, (Object error, StackTrace stack) {
    final log = AppLogger('zone');
    log.error('uncaught_in_zone', {
      'error': error.toString(),
      'stack': stack.toString().length > 32000
          ? '${stack.toString().substring(0, 32000)}…'
          : stack.toString(),
    });
  });
}
