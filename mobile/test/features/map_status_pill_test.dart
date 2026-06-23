import 'package:captain_wrongel/core/energy_profile_controller.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/core/theme/cw_tokens.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/map/map_gps_status_provider.dart';
import 'package:captain_wrongel/features/map/widgets/gps_fix_indicator.dart';
import 'package:captain_wrongel/features/map/widgets/map_status_pill.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> wrap(
    Widget child, {
    MapGpsStatus status = const MapGpsStatus(
      fixStatus: GpsFixStatus.fix,
      accuracyM: 12,
      sogKnots: 4.2,
    ),
    EnergyProfile energyProfile = EnergyProfile.passage,
    Map<String, Object> prefs = const {},
  }) async {
    SharedPreferences.setMockInitialValues({
      EnergyProfileController.preferenceKey: energyProfile.encoded,
      ...prefs,
    });
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) {
          ref.onDispose(db.close);
          return db;
        }),
        sessionIdProvider.overrideWith((ref) => 'map-status-pill-test'),
        mapGpsStatusProvider.overrideWith((ref) {
          final notifier = MapGpsStatusNotifier(ref, start: false);
          notifier.applyTestFix(
            fixStatus: status.fixStatus,
            accuracyM: status.accuracyM,
            sogKnots: status.sogKnots,
          );
          return notifier;
        }),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: MediaQuery(
          data: const MediaQueryData(padding: EdgeInsets.only(top: 44)),
          child: Scaffold(
            body: Stack(
              children: [child],
            ),
          ),
        ),
      ),
    );
  }

  group('GpsFixIndicator', () {
    testWidgets('shows green dot for fix', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CwTheme.material(),
          home: const Scaffold(
            body: GpsFixIndicator(status: GpsFixStatus.fix),
          ),
        ),
      );

      final dot = tester.widget<Container>(
        find.byKey(const Key('gps_fix_indicator_fix')),
      );
      final decoration = dot.decoration! as BoxDecoration;
      expect(decoration.color, CwPalette.safe);
    });

    testWidgets('shows amber dot for searching', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CwTheme.material(),
          home: const Scaffold(
            body: GpsFixIndicator(status: GpsFixStatus.searching),
          ),
        ),
      );

      final dot = tester.widget<Container>(
        find.byKey(const Key('gps_fix_indicator_searching')),
      );
      final decoration = dot.decoration! as BoxDecoration;
      expect(decoration.color, CwPalette.accentOrange);
    });

    testWidgets('shows red dot for denied', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CwTheme.material(),
          home: const Scaffold(
            body: GpsFixIndicator(status: GpsFixStatus.denied),
          ),
        ),
      );

      final dot = tester.widget<Container>(
        find.byKey(const Key('gps_fix_indicator_denied')),
      );
      final decoration = dot.decoration! as BoxDecoration;
      expect(decoration.color, CwPalette.danger);
    });
  });

  group('MapStatusPillView', () {
    testWidgets('renders accuracy and SOG when fix is valid', (tester) async {
      await tester.pumpWidget(
        await wrap(
          const MapStatusPillView(
            status: MapGpsStatus(
              fixStatus: GpsFixStatus.fix,
              accuracyM: 8,
              sogKnots: 5.5,
            ),
            ecoMode: false,
          ),
        ),
      );

      expect(find.byKey(const Key('map_status_pill')), findsOneWidget);
      expect(find.text('±8 m'), findsOneWidget);
      expect(find.text('5.5 kn'), findsOneWidget);
      expect(find.byKey(const Key('map_status_eco')), findsNothing);
    });

    testWidgets('hides SOG when stationary', (tester) async {
      await tester.pumpWidget(
        await wrap(
          const MapStatusPillView(
            status: MapGpsStatus(
              fixStatus: GpsFixStatus.fix,
              accuracyM: 6,
            ),
            ecoMode: false,
          ),
        ),
      );

      expect(find.text('±6 m'), findsOneWidget);
      expect(find.byKey(const Key('map_status_sog')), findsNothing);
    });

    testWidgets('eco mode shows leaf icon', (tester) async {
      await tester.pumpWidget(
        await wrap(
          const MapStatusPillView(
            status: MapGpsStatus(
              fixStatus: GpsFixStatus.fix,
              accuracyM: 10,
            ),
            ecoMode: true,
          ),
        ),
      );

      expect(find.byKey(const Key('map_status_eco')), findsOneWidget);
      expect(find.byIcon(Icons.energy_savings_leaf_outlined), findsOneWidget);
    });

    testWidgets('pill is 32dp tall with horizontal padding', (tester) async {
      await tester.pumpWidget(
        await wrap(
          const MapStatusPillView(
            status: MapGpsStatus(fixStatus: GpsFixStatus.searching),
            ecoMode: false,
          ),
        ),
      );

      final pill = tester.getSize(find.byKey(const Key('map_status_pill')));
      expect(pill.height, kMapStatusPillHeight);

      final padding = tester.widget<Padding>(
        find.byKey(const Key('map_status_pill_padding')),
      );
      expect(padding.padding, const EdgeInsets.symmetric(horizontal: 12));
    });

    testWidgets('tap invokes callback', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        await wrap(
          MapStatusPillView(
            status: const MapGpsStatus(fixStatus: GpsFixStatus.fix),
            ecoMode: false,
            onTap: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('map_status_pill')));
      await tester.pump();
      expect(tapped, isTrue);
    });
  });

  group('MapStatusPill', () {
    testWidgets('positions at top center below safe area', (tester) async {
      await tester.pumpWidget(
        await wrap(const MapStatusPill()),
      );
      await tester.pump();

      final positioned = tester.widget<Positioned>(
        find.byWidgetPredicate(
          (w) => w is Positioned && w.top != null && w.left == 0 && w.right == 0,
        ),
      );
      expect(positioned.top, 44 + kMapStatusPillTopInset);
      expect(positioned.left, 0);
      expect(positioned.right, 0);
    });

    testWidgets('eco profile shows leaf via provider', (tester) async {
      await tester.pumpWidget(
        await wrap(
          const MapStatusPill(),
          energyProfile: EnergyProfile.eco,
          status: const MapGpsStatus(
            fixStatus: GpsFixStatus.fix,
            accuracyM: 5,
          ),
        ),
      );
      await tester.pump();

      expect(find.byKey(const Key('map_status_eco')), findsOneWidget);
    });
  });

  group('mapGpsLocationSettings', () {
    test('eco uses low accuracy and larger distance filter', () {
      final settings = mapGpsLocationSettings(EnergyProfile.eco);
      expect(settings.accuracy, LocationAccuracy.low);
      expect(settings.distanceFilter, 10);
    });

    test('sport uses high accuracy', () {
      final settings = mapGpsLocationSettings(EnergyProfile.sport);
      expect(settings.accuracy, LocationAccuracy.high);
    });
  });
}
