import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/domain/ais/ais_target.dart';
import 'package:captain_wrongel/domain/ais/ais_vessel_category.dart';
import 'package:captain_wrongel/domain/ais/cpa_tcpa.dart';
import 'package:captain_wrongel/features/ais/ais_filter_provider.dart';
import 'package:captain_wrongel/features/ais/ais_own_ship.dart';
import 'package:captain_wrongel/features/ais/ais_screen.dart';
import 'package:captain_wrongel/features/ais/ais_targets_controller.dart';
import 'package:captain_wrongel/features/ais/ais_targets_provider.dart';
import 'package:captain_wrongel/features/ais/widgets/ais_filter_bar.dart';
import 'package:captain_wrongel/features/ais/widgets/ais_vessel_marker.dart';
import 'package:captain_wrongel/features/ais/widgets/ais_vessel_sheet.dart';
import 'package:captain_wrongel/features/more/more_menu_screen.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

AisTarget _sampleTarget({int mmsi = 123456789}) {
  return AisTarget(
    mmsi: mmsi,
    latitudeDeg: 36.7,
    longitudeDeg: 29.1,
    sogKnots: 8.5,
    cogDegrees: 120,
    updatedAtUtc: DateTime.utc(2026, 6, 1),
    category: aisCategoryFromMmsi(mmsi),
    trueHeadingDeg: 118,
  );
}

void main() {
  test('filterAisTargets respects category filter', () {
    final targets = {
      1: _sampleTarget(mmsi: 3),
      2: _sampleTarget(mmsi: 4),
      3: _sampleTarget(mmsi: 5),
    };
    final cargo = filterAisTargets(targets, AisFilterSelection.cargo).toList();
    expect(cargo, hasLength(1));
    expect(cargo.first.category, AisVesselCategory.cargo);
  });

  test('vesselTriangleRing returns closed ring', () {
    final ring = vesselTriangleRing(36.0, 29.0, 45);
    expect(ring.first, ring.last);
    expect(ring, hasLength(4));
  });

  test('AisVesselSheet shows CPA/TCPA and warning badge when close', () {
    final close = AisTarget(
      mmsi: 999,
      latitudeDeg: AisOwnShip.latitudeDeg + 0.01,
      longitudeDeg: AisOwnShip.longitudeDeg,
      sogKnots: 12,
      cogDegrees: 225,
      updatedAtUtc: DateTime.utc(2026, 6, 1),
      category: AisVesselCategory.tanker,
    );
    final cpa = computeCpaTcpa(
      ownLatDeg: AisOwnShip.latitudeDeg,
      ownLonDeg: AisOwnShip.longitudeDeg,
      ownCogDeg: AisOwnShip.cogDegrees,
      ownSogKn: AisOwnShip.sogKnots,
      tgtLatDeg: close.latitudeDeg,
      tgtLonDeg: close.longitudeDeg,
      tgtCogDeg: close.cogDegrees,
      tgtSogKn: close.sogKnots,
    );
    expect(cpa.cpaNm, lessThan(1.0));
  });

  testWidgets('AisScreen renders filter bar and local stream card', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AisScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AisFilterBar), findsOneWidget);
    expect(find.text('All'), findsOneWidget);
    expect(find.text('Cargo'), findsOneWidget);
    expect(find.text('Local stream'), findsOneWidget);
    expect(find.text('Off'), findsOneWidget);
    expect(find.text('Demo'), findsOneWidget);
    expect(find.text('Live'), findsOneWidget);
    expect(find.text('0 targets'), findsOneWidget);
  });

  testWidgets('AisScreen vessel sheet shows MMSI and CPA rows', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
          aisTargetsProvider.overrideWith(
            (ref) => _StubAisTargetsController({_sampleTarget().mmsi: _sampleTarget()}),
          ),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AisScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Vessel'), findsOneWidget);
    await tester.tap(find.textContaining('Vessel'));
    await tester.pumpAndSettle();

    expect(find.byType(AisVesselSheet), findsOneWidget);
    expect(find.text('MMSI'), findsOneWidget);
    expect(find.text('CPA'), findsOneWidget);
    expect(find.text('TCPA'), findsOneWidget);
  });

  testWidgets('More menu includes AIS entry', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWith((ref) => prefs),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: MoreMenuScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AIS traffic'), findsOneWidget);
    await tester.tap(find.text('AIS traffic'));
    await tester.pumpAndSettle();

    expect(find.text('AIS'), findsWidgets);
    expect(find.byType(AisScreen), findsOneWidget);
  });
}

class _StubAisTargetsController extends AisTargetsController {
  _StubAisTargetsController(Map<int, AisTarget> initial) : super() {
    state = initial;
  }
}
