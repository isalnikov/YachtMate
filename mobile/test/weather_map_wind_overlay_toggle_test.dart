import 'package:captain_wrongel/core/map_layer_preferences_controller.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/weather/widgets/weather_map_wind_overlay_toggle.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('weather map wind toggle updates map layer prefs', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    late ProviderContainer container;
    await tester.pumpWidget(
      ProviderScope(
        parent: container = ProviderContainer(
          overrides: [
            sharedPreferencesProvider.overrideWith((ref) => prefs),
            databaseProvider.overrideWith((ref) => db),
            sessionIdProvider.overrideWith((ref) => 'weather-wind-toggle'),
          ],
        ),
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const Scaffold(
            body: WeatherMapWindOverlayToggle(),
          ),
        ),
      ),
    );
    addTearDown(container.dispose);
    await tester.pumpAndSettle();

    expect(
      container.read(mapLayerPreferencesProvider).windOverlay,
      false,
    );

    await tester.tap(find.byType(SwitchListTile));
    await tester.pumpAndSettle();

    expect(
      container.read(mapLayerPreferencesProvider).windOverlay,
      true,
    );
  });
}
