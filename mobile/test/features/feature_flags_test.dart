import 'package:captain_wrongel/core/feature_flags.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/paywall/paywall_placeholder_sheet.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('gated feature shows paywall sheet', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
          databaseProvider.overrideWith((ref) => db),
          sessionIdProvider.overrideWith((ref) => 'paywall-test'),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () => showPaywallPlaceholderSheet(
                    context,
                    PremiumFeature.gribImport,
                  ),
                  child: const Text('Gate'),
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(
      refOrFlags(prefs).canUse(PremiumFeature.gribImport),
      isFalse,
    );

    await tester.tap(find.text('Gate'));
    await tester.pumpAndSettle();

    expect(find.text('Captain Wrongel Premium'), findsOneWidget);
    expect(find.text('Notify me at launch'), findsOneWidget);
  });
}

FeatureFlags refOrFlags(SharedPreferences prefs) => FeatureFlags.read(prefs);
