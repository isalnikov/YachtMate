import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/core/voyage_monitor_controller.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/voyage/voyage_monitor_screen.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('VoyageMonitor start/stop persists', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
          databaseProvider.overrideWith((ref) => db),
          sessionIdProvider.overrideWith((ref) => 'voyage-test'),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: VoyageMonitorScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Not monitoring'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Alex Shore');
    await tester.enterText(find.byType(TextField).at(1), '+90 555 0100');
    await tester.tap(find.text('Start monitoring'));
    await tester.pumpAndSettle();

    expect(prefs.getBool(VoyageMonitorController.activeKey), isTrue);
    expect(find.text('Stop monitoring'), findsOneWidget);

    await tester.tap(find.text('Stop monitoring'));
    await tester.pumpAndSettle();

    expect(prefs.getBool(VoyageMonitorController.activeKey), isFalse);
  });
}
