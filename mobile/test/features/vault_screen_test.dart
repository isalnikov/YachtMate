import 'dart:typed_data';

import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/core/vault_prefs_controller.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/vault_repository.dart';
import 'package:captain_wrongel/domain/vault/vault_crypto.dart';
import 'package:captain_wrongel/features/vault/vault_screen.dart';
import 'package:captain_wrongel/features/vault/widgets/vault_pin_panel.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_badge.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:captain_wrongel/widgets/cw_empty_state.dart';
import 'package:captain_wrongel/widgets/cw_text_field.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const testSalt = 'vault-test-salt';
  const testPin = '4242';

  Future<Widget> host({
    required AppDatabase db,
    Map<String, Object> prefs = const {},
    bool unlocked = false,
    String? sessionPin,
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final shared = await SharedPreferences.getInstance();

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step31'),
        vaultSessionUnlockedProvider.overrideWith((ref) => unlocked),
        vaultSessionPinProvider.overrideWith((ref) => sessionPin),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: VaultScreen()),
      ),
    );
  }

  Future<AppDatabase> memoryDb() async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    return db;
  }

  Map<String, Object> prefsWithPin() => {
        VaultPrefsNotifier.saltKey: testSalt,
        VaultPrefsNotifier.pinHashKey: VaultCrypto.hashPin(testPin, testSalt),
      };

  group('VaultScreen', () {
    testWidgets('shows VaultPinPanel for PIN setup when no pin configured', (
      tester,
    ) async {
      final db = await memoryDb();
      await tester.pumpWidget(
        await host(db: db, prefs: {VaultPrefsNotifier.saltKey: testSalt}),
      );
      await tester.pumpAndSettle();

      expect(find.byType(VaultPinPanel), findsOneWidget);
      expect(find.text('Create vault PIN'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsWidgets);
      expect(find.byType(CwTextField), findsNWidgets(2));
    });

    testWidgets('shows unlock panel with masked PIN field when locked', (
      tester,
    ) async {
      final db = await memoryDb();
      await tester.pumpWidget(await host(db: db, prefs: prefsWithPin()));
      await tester.pumpAndSettle();

      expect(find.byType(VaultPinPanel), findsOneWidget);
      expect(find.text('Unlock vault'), findsOneWidget);
      expect(find.byType(CwTextField), findsOneWidget);

      await tester.enterText(find.byType(CwTextField), testPin);
      await tester.tap(find.text('Unlock'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_open_outlined), findsOneWidget);
      expect(find.byType(VaultPinPanel), findsNothing);
    });

    testWidgets('unlocked vault shows secondary import and empty state', (
      tester,
    ) async {
      final db = await memoryDb();
      await tester.pumpWidget(
        await host(
          db: db,
          prefs: prefsWithPin(),
          unlocked: true,
          sessionPin: testPin,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.lock_open_outlined), findsOneWidget);
      expect(find.widgetWithText(CwButton, 'Pick file'), findsOneWidget);
      expect(find.byType(CwEmptyState), findsOneWidget);
      expect(find.text('No encrypted files stored yet.'), findsOneWidget);
    });

    testWidgets('lists encrypted files in CwCard with badge', (tester) async {
      final db = await memoryDb();
      final repo = VaultRepository(db);
      await repo.saveEncrypted(
        displayName: 'passport.pdf',
        plainBytes: Uint8List.fromList([1, 2, 3]),
        pin: testPin,
        vaultSalt: testSalt,
      );

      await tester.pumpWidget(
        await host(
          db: db,
          prefs: prefsWithPin(),
          unlocked: true,
          sessionPin: testPin,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(CwCard), findsOneWidget);
      expect(find.text('passport.pdf'), findsOneWidget);
      expect(find.byType(CwBadge), findsOneWidget);
      expect(find.text('Encrypted'), findsOneWidget);
      expect(find.text('3 bytes'), findsOneWidget);
    });

    testWidgets('captain sees delete control on vault files', (tester) async {
      final db = await memoryDb();
      final repo = VaultRepository(db);
      await repo.saveEncrypted(
        displayName: 'license.pdf',
        plainBytes: Uint8List.fromList([9]),
        pin: testPin,
        vaultSalt: testSalt,
      );

      await tester.pumpWidget(
        await host(
          db: db,
          prefs: prefsWithPin(),
          unlocked: true,
          sessionPin: testPin,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_outline), findsOneWidget);
    });

    testWidgets('crew role hides delete control on vault files', (tester) async {
      final db = await memoryDb();
      final repo = VaultRepository(db);
      await repo.saveEncrypted(
        displayName: 'crew-doc.pdf',
        plainBytes: Uint8List.fromList([5]),
        pin: testPin,
        vaultSalt: testSalt,
      );

      await tester.pumpWidget(
        await host(
          db: db,
          prefs: {...prefsWithPin(), 'crew_role': 'crew'},
          unlocked: true,
          sessionPin: testPin,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_outline), findsNothing);
    });
  });
}
