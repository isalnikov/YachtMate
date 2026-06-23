import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/compass/compass_astro_screen.dart';
import 'package:captain_wrongel/features/compass/widgets/compass_dial.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:captain_wrongel/widgets/cw_section_header.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const geolocatorChannel = MethodChannel('flutter.baseflow.com/geolocator');

  Future<Widget> host() async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step34'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: CompassAstroScreen()),
      ),
    );
  }

  void mockGpsPosition({
    double latitude = 43.2965,
    double longitude = 5.3698,
  }) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(geolocatorChannel, (call) async {
      if (call.method == 'getCurrentPosition') {
        return {
          'latitude': latitude,
          'longitude': longitude,
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'accuracy': 8.0,
          'altitude': 0.0,
          'heading': 0.0,
          'speed': 0.0,
          'speed_accuracy': 0.0,
          'altitude_accuracy': 0.0,
          'heading_accuracy': 0.0,
        };
      }
      if (call.method == 'checkPermission') {
        return LocationPermission.whileInUse.index;
      }
      return null;
    });
  }

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(geolocatorChannel, null);
  });

  group('CompassDial', () {
    testWidgets('renders 200dp dial with cardinal labels', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CwTheme.material(),
          home: const Scaffold(
            body: Center(child: CompassDial(headingDeg: 45)),
          ),
        ),
      );

      final dial = tester.getSize(find.byKey(const Key('compass_dial')));
      expect(dial.width, kCompassDialSize);
      expect(dial.height, kCompassDialSize);

      expect(find.text('45°'), findsOneWidget);
      expect(find.byType(CompassDial), findsOneWidget);
      expect(find.byType(CustomPaint), findsWidgets);
    });

    testWidgets('shows dash when heading is unknown', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: CwTheme.material(),
          home: const Scaffold(
            body: Center(child: CompassDial()),
          ),
        ),
      );

      expect(find.text('—'), findsOneWidget);
    });
  });

  group('CompassAstroScreen', () {
    testWidgets('shows disclaimer, dial, and GPS prompt without fix', (
      tester,
    ) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      expect(
        find.text(
          'Magnetic compass uses device sensors; solar times are approximate.',
        ),
        findsOneWidget,
      );
      expect(find.byKey(const Key('compass_dial')), findsOneWidget);
      expect(find.byType(CwSectionHeader), findsOneWidget);
      expect(
        find.text('Need a GPS fix to estimate sun times.'),
        findsOneWidget,
      );
      expect(find.byKey(const Key('compass_sunrise_card')), findsNothing);
    });

    testWidgets('shows sunrise and sunset CwCards when GPS resolves', (
      tester,
    ) async {
      mockGpsPosition();

      await tester.pumpWidget(await host());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('compass_sunrise_card')), findsOneWidget);
      expect(find.byKey(const Key('compass_sunset_card')), findsOneWidget);
      expect(find.byType(CwCard), findsNWidgets(2));
      expect(find.text('Sunrise'), findsOneWidget);
      expect(find.text('Sunset'), findsOneWidget);
      expect(find.text('Need a GPS fix to estimate sun times.'), findsNothing);
      expect(
        find.text('Device timezone; approximate formulas.'),
        findsOneWidget,
      );
    });

    testWidgets('shows compass heading label under dial', (tester) async {
      await tester.pumpWidget(await host());
      await tester.pumpAndSettle();

      expect(
        find.text('Heading (magnetic variation not applied)'),
        findsOneWidget,
      );
    });
  });
}
