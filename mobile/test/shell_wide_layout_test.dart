import 'package:captain_wrongel/app.dart';
import 'package:captain_wrongel/core/disclaimer_gate.dart';
import 'package:captain_wrongel/core/onboarding_prefs.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/domain/tides/tide_demo_models.dart';
import 'package:captain_wrongel/domain/weather/weather_forecast_view.dart';
import 'package:captain_wrongel/core/locale_controller.dart';
import 'package:captain_wrongel/features/mooring/mooring_providers.dart';
import 'package:captain_wrongel/features/weather/weather_providers.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:captain_wrongel/widgets/cw_split_view.dart';

final _demoMooringPlace = MooringPlaceRow(
  id: 'demo_marina',
  kind: 'marina',
  name: 'Fethiye Marina',
  lat: 36.755,
  lon: 29.1045,
  vhf: '72',
  phone: null,
  email: null,
  websiteUrl: null,
  bookingUrl: null,
  servicesJson: '{"depthM":3}',
  notes: null,
  sourceUpdatedAtMs: null,
);

final _testForecast = WeatherForecastBundle(
  fetchedAtUtc: DateTime.utc(2026, 4, 22, 12),
  isStale: false,
  hourly: [
    HourlyWeatherPoint(
      timeUtc: DateTime.utc(2026, 4, 22, 12),
      temperatureC: 18,
      precipitationMm: 0,
      pressureHpa: 1013,
      windSpeedKn: 12,
      windDirectionDeg: 270,
      waveHeightM: 0.5,
    ),
    HourlyWeatherPoint(
      timeUtc: DateTime.utc(2026, 4, 22, 13),
      temperatureC: 19,
      precipitationMm: 0.2,
      pressureHpa: 1012,
      windSpeedKn: 14,
      windDirectionDeg: 280,
    ),
  ],
);

final _testTide = TideDemoStation(
  stationName: 'Test Harbor',
  note: 'Demo tides',
  events: const [],
);

Future<void> _pumpShell(
  WidgetTester tester, {
  required Size size,
  List<Override> extraOverrides = const [],
}) async {
  SharedPreferences.setMockInitialValues({
    kDisclaimerV1AcceptedKey: true,
    kOnboardingCompleteKey: true,
    LocaleController.localePreferenceKey: 'en',
  });
  final prefs = await SharedPreferences.getInstance();
  final db = AppDatabase(NativeDatabase.memory());
  addTearDown(db.close);

  await tester.binding.setSurfaceSize(size);
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => prefs),
        databaseProvider.overrideWith((ref) {
          ref.onDispose(db.close);
          return db;
        }),
        sessionIdProvider.overrideWith((ref) => 'wide-shell-test'),
        weatherForecastProvider.overrideWith((ref) async => _testForecast),
        tideDemoProvider.overrideWith((ref) async => _testTide),
        mooringPlacesProvider.overrideWith((ref) async => [_demoMooringPlace]),
        mooringPendingReviewsProvider.overrideWith((ref) async => []),
        ...extraOverrides,
      ],
      child: const CaptainWrongelApp(),
    ),
  );

  await tester.pumpAndSettle(const Duration(seconds: 5));
  expect(tester.takeException(), isNull);
}

Future<void> _selectRailTab(WidgetTester tester, IconData icon) async {
  final rail = find.byType(NavigationRail);
  expect(rail, findsOneWidget);
  await tester.tap(
    find.descendant(of: rail, matching: find.byIcon(icon)),
  );
  await tester.pump();
  await tester.pump(const Duration(seconds: 2));
  expect(tester.takeException(), isNull);
}

/// Regression: wide window (≥900px) uses extended [NavigationRail], which must
/// use [NavigationRailLabelType.none], not .all (Material assert).
void main() {
  testWidgets('Shell at 1200px builds without NavigationRail assert',
      (tester) async {
    await _pumpShell(tester, size: const Size(1200, 800));
  });

  testWidgets('Mooring tab shows CwSplitView at 1200px', (tester) async {
    await _pumpShell(tester, size: const Size(1200, 800));
    await _selectRailTab(tester, Icons.anchor_outlined);
    await tester.pump(const Duration(seconds: 2));

    expect(find.text('Marinas & anchorages'), findsOneWidget);
    expect(find.byKey(const Key('cw_split_view')), findsOneWidget);
    expect(find.byKey(const Key('cw_split_view_master')), findsOneWidget);
    expect(find.byKey(const Key('cw_split_view_detail')), findsOneWidget);
  });

  testWidgets('Route tab shows CwSplitView at 1200px', (tester) async {
    await _pumpShell(tester, size: const Size(1200, 800));
    await _selectRailTab(tester, Icons.route_outlined);

    expect(find.byKey(const Key('cw_split_view')), findsOneWidget);
  });

  testWidgets('Weather tab shows CwSplitView at 1200px', (tester) async {
    await _pumpShell(tester, size: const Size(1200, 800));
    await _selectRailTab(tester, Icons.air_outlined);

    expect(find.byKey(const Key('cw_split_view')), findsOneWidget);
  });

  testWidgets('Phone mooring tab does not use CwSplitView at 400px',
      (tester) async {
    await _pumpShell(tester, size: const Size(400, 800));

    await tester.tap(find.text('Mooring'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 3));

    expect(find.text('Marinas & anchorages'), findsOneWidget);
    expect(find.text('List'), findsOneWidget);
    expect(find.byKey(const Key('cw_split_view')), findsNothing);
  });

  testWidgets('CwSplitView uses 60/40 flex at 800px', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CwSplitView(
            master: const ColoredBox(color: Colors.red),
            detail: const ColoredBox(color: Colors.blue),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final master = tester.getSize(find.byKey(const Key('cw_split_view_master')));
    final detail = tester.getSize(find.byKey(const Key('cw_split_view_detail')));

    expect(master.width, closeTo(800 * 0.6, 2));
    expect(detail.width, closeTo(800 * 0.4, 2));
  });
}
