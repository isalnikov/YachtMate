import 'package:captain_wrongel/core/anchor_watch_alert_settings_controller.dart';
import 'package:captain_wrongel/core/anchor_watch_controller.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/audit_repository.dart';
import 'package:captain_wrongel/domain/anchor/geo.dart';
import 'package:captain_wrongel/features/anchor/anchor_watch_sms.dart';
import 'package:captain_wrongel/features/anchor/anchor_watch_screen.dart';
import 'package:captain_wrongel/features/anchor/widgets/anchor_status_panel.dart';
import 'package:captain_wrongel/features/anchor/widgets/anchor_zone_map.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:captain_wrongel/core/providers.dart';

void main() {
  const anchorLat = 36.75;
  const anchorLon = 29.10;
  const sessionId = 'test-session';

  Future<AnchorWatchController> buildController({
    Map<String, Object> prefs = const {},
    AnchorWatchSmsLauncher? smsLauncher,
  }) async {
    SharedPreferences.setMockInitialValues({
      AnchorWatchController.latKey: anchorLat,
      AnchorWatchController.lonKey: anchorLon,
      AnchorWatchController.radiusKey: 40.0,
      AnchorWatchAlertSettings.smsTestModeKey: true,
      ...prefs,
    });
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final audit = AuditRepository(db);
    return AnchorWatchController(
      shared,
      audit,
      sessionId,
      smsLauncher: smsLauncher,
    );
  }

  test('haversineMeters is zero for identical points', () {
    expect(haversineMeters(1, 2, 1, 2), 0);
  });

  test('shouldLatchAnchorAlarm when outside radius', () {
    expect(
      shouldLatchAnchorAlarm(distanceM: 50, radiusM: 40, alarmLatched: false),
      isTrue,
    );
    expect(
      shouldLatchAnchorAlarm(distanceM: 30, radiusM: 40, alarmLatched: false),
      isFalse,
    );
    expect(
      shouldLatchAnchorAlarm(distanceM: 50, radiusM: 40, alarmLatched: true),
      isFalse,
    );
  });

  test('alarm latches on simulated drift beyond radius', () async {
    final c = await buildController();
    await c.arm();
    expect(c.state.alarmLatched, isFalse);

    // ~111 m north — well outside 40 m radius.
    await c.ingestPositionForTest(anchorLat + 0.001, anchorLon);

    expect(c.state.alarmLatched, isTrue);
    expect(c.state.isDrifting, isTrue);
    expect(c.state.lastDistanceM, greaterThan(40));
    expect(c.state.driftHistory, hasLength(1));
  });

  test('drift SMS skipped when anchor SMS test mode is on', () async {
    Uri? launched;
    final c = await buildController(
      prefs: {
        AnchorWatchAlertSettings.smsOnDriftKey: true,
        AnchorWatchAlertSettings.smsNumberKey: '+15550100',
        AnchorWatchAlertSettings.smsTestModeKey: true,
      },
      smsLauncher: (uri) async => launched = uri,
    );
    await c.arm();
    await c.ingestPositionForTest(anchorLat + 0.001, anchorLon);

    expect(c.state.alarmLatched, isTrue);
    expect(launched, isNull);
  });

  test('drift SMS launches when enabled and test mode off', () async {
    Uri? launched;
    final c = await buildController(
      prefs: {
        AnchorWatchAlertSettings.smsOnDriftKey: true,
        AnchorWatchAlertSettings.smsNumberKey: '+15550100',
        AnchorWatchAlertSettings.smsTestModeKey: false,
      },
      smsLauncher: (uri) async => launched = uri,
    );
    await c.arm();
    await c.ingestPositionForTest(anchorLat + 0.001, anchorLon);

    expect(c.state.alarmLatched, isTrue);
    expect(launched, isNotNull);
    expect(launched!.scheme, 'sms');
    expect(launched!.path, '+15550100');
    expect(launched!.queryParameters['body'], contains('Anchor drift alert'));
  });

  test('anchorCircleRing closes polygon ring', () {
    final ring = anchorCircleRing(
      anchorLat: anchorLat,
      anchorLon: anchorLon,
      radiusM: 40,
      segments: 8,
    );
    expect(ring.first, ring.last);
    expect(ring.length, greaterThan(3));
  });

  test('ingest inside zone does not latch alarm', () async {
    final c = await buildController();
    await c.arm();
    await c.ingestPositionForTest(anchorLat, anchorLon);

    expect(c.state.alarmLatched, isFalse);
    expect(c.state.isDrifting, isFalse);
  });

  testWidgets('AnchorStatusPanel shows IN ZONE when armed inside circle',
      (tester) async {
    const state = AnchorWatchState(
      armed: true,
      anchorLat: anchorLat,
      anchorLon: anchorLon,
      radiusM: 50,
      lastDistanceM: 12,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: AnchorStatusPanel(state: state)),
      ),
    );
    await tester.pump();

    expect(find.text('IN ZONE'), findsOneWidget);
    expect(find.textContaining('12.0 m'), findsOneWidget);
  });

  testWidgets('AnchorStatusPanel shows DRIFTING when outside circle',
      (tester) async {
    const state = AnchorWatchState(
      armed: true,
      anchorLat: anchorLat,
      anchorLon: anchorLon,
      radiusM: 40,
      lastDistanceM: 55,
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: AnchorStatusPanel(state: state)),
      ),
    );
    await tester.pump();

    expect(find.text('DRIFTING'), findsOneWidget);
  });

  testWidgets('AnchorWatchScreen shows zone map and arm/disarm CwButton',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      AnchorWatchController.latKey: anchorLat,
      AnchorWatchController.lonKey: anchorLon,
    });
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          auditRepositoryProvider.overrideWithValue(AuditRepository(db)),
          sessionIdProvider.overrideWithValue(sessionId),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AnchorWatchScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AnchorZoneMap), findsOneWidget);
    expect(find.text('Arm watch'), findsOneWidget);

    await tester.tap(find.text('Arm watch'));
    await tester.pumpAndSettle();

    expect(find.text('Disarm'), findsOneWidget);
    expect(find.text('● ARMED'), findsOneWidget);
  });

  testWidgets('AnchorWatchScreen shows map placeholder without anchor',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          auditRepositoryProvider.overrideWithValue(AuditRepository(db)),
          sessionIdProvider.overrideWithValue(sessionId),
        ],
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(body: AnchorWatchScreen()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Mark anchor position to show zone map'),
      findsOneWidget,
    );
    expect(find.text('Disarmed'), findsOneWidget);
  });
}
