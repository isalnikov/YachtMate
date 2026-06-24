import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/yacht/yacht_hub_screen.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('YachtHubScreen links reach child modules', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
          databaseProvider.overrideWith((ref) => db),
          sessionIdProvider.overrideWith((ref) => 'yacht-hub'),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: YachtHubScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Log entries'), findsOneWidget);
    expect(find.text('Trip spend'), findsOneWidget);

    await tester.tap(find.text('Log entries'));
    await tester.pumpAndSettle();
    expect(find.text("Ship's log"), findsOneWidget);
  });
}
