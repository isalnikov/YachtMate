import 'dart:convert';
import 'dart:io';

import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/audit_repository.dart';
import 'package:captain_wrongel/domain/reference/medical_entry.dart';
import 'package:captain_wrongel/features/medical/medical_glossary_screen.dart';
import 'package:captain_wrongel/features/medical/widgets/medical_term_card.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:captain_wrongel/widgets/cw_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _demoMedicalEntries = parseMedicalCatalogJson(
  jsonDecode(r'''
{
  "version": 1,
  "entries": [
    {
      "id": "shock",
      "category": "critical",
      "titles": {
        "en": "Shock (hypoperfusion)",
        "ru": "Шок (гипоперфузия)"
      },
      "bodies": {
        "en": "Lay flat, keep warm, elevate legs ~20–30 cm if no spine injury; call help.",
        "ru": "Уложить горизонтально, укрыть, поднять ноги на 20–30 см при отсутствии травмы позвоночника; вызвать помощь."
      }
    },
    {
      "id": "hypothermia",
      "category": "environment",
      "titles": { "en": "Hypothermia", "ru": "Гипотермия" },
      "bodies": {
        "en": "Gradual rewarming; dry clothes; warm drinks if conscious; seek medical aid.",
        "ru": "Медленное согревание, сухая одежда, тёплые напитки при сознании; медицинская помощь."
      }
    }
  ]
}
''') as Map<String, dynamic>,
);

void main() {
  Future<Widget> host({
    Locale locale = const Locale('en'),
    String? localeCode,
  }) async {
    SharedPreferences.setMockInitialValues(
      localeCode != null ? {'localeCode': localeCode} : {},
    );
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step36'),
        auditRepositoryProvider.overrideWithValue(AuditRepository(db)),
        medicalEntriesProvider.overrideWith((ref) async => _demoMedicalEntries),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: MedicalGlossaryScreen()),
      ),
    );
  }

  group('medical glossary data', () {
    test('bundled medical_glossary_demo.json loads two entries', () {
      final file = File('assets/reference/medical_glossary_demo.json');
      final entries = parseMedicalCatalogJson(
        jsonDecode(file.readAsStringSync()) as Map<String, dynamic>,
      );
      expect(entries, hasLength(2));
      expect(entries.map((e) => e.id), containsAll(['shock', 'hypothermia']));
    });

    test('filterMedicalEntries matches title and body', () {
      final entries = [
        MedicalEntry(
          id: 'shock',
          category: 'critical',
          titles: const {'en': 'Shock'},
          bodies: const {'en': 'Lay flat'},
        ),
        MedicalEntry(
          id: 'hypothermia',
          category: 'environment',
          titles: const {'en': 'Hypothermia'},
          bodies: const {'en': 'Rewarm gradually'},
        ),
      ];

      expect(
        filterMedicalEntries(
          entries: entries,
          lang: 'en',
          query: 'rewarm',
          letter: null,
        ),
        hasLength(1),
      );
      expect(
        filterMedicalEntries(
          entries: entries,
          lang: 'en',
          query: '',
          letter: 'S',
        ).single.id,
        'shock',
      );
    });

    test('medicalIndexLetters collects sorted first letters', () {
      final entries = [
        MedicalEntry(
          id: 'shock',
          category: 'critical',
          titles: const {'en': 'Shock'},
          bodies: const {'en': ''},
        ),
        MedicalEntry(
          id: 'hypothermia',
          category: 'environment',
          titles: const {'en': 'Hypothermia'},
          bodies: const {'en': ''},
        ),
      ];

      expect(medicalIndexLetters(entries, 'en'), ['H', 'S']);
    });
  });

  group('MedicalGlossaryScreen', () {
    Future<void> pumpMedicalScreen(WidgetTester tester, Widget widget) async {
      await tester.pumpWidget(widget);
      await tester.pumpAndSettle();
    }

    testWidgets('loads demo json and shows CwCard term list', (tester) async {
      await pumpMedicalScreen(tester, await host());

      expect(find.byType(CwSearchBar), findsOneWidget);
      expect(find.byType(MedicalTermCard), findsNWidgets(2));
      expect(find.byType(CwCard), findsNWidgets(2));
      expect(find.text('Shock (hypoperfusion)'), findsOneWidget);
      expect(find.text('Hypothermia'), findsOneWidget);
      expect(find.textContaining('Educational snippets only'), findsOneWidget);
    });

    testWidgets('search filters glossary entries', (tester) async {
      await pumpMedicalScreen(tester, await host());

      await tester.enterText(
        find.descendant(
          of: find.byKey(const Key('medical_search_bar')),
          matching: find.byType(TextField),
        ),
        'rewarm',
      );
      await tester.pump();

      expect(find.byType(MedicalTermCard), findsOneWidget);
      expect(find.text('Hypothermia'), findsOneWidget);
      expect(find.text('Shock (hypoperfusion)'), findsNothing);
    });

    testWidgets('letter chips filter by first letter', (tester) async {
      await pumpMedicalScreen(tester, await host());

      expect(find.byKey(const Key('medical_letter_H')), findsOneWidget);
      expect(find.byKey(const Key('medical_letter_S')), findsOneWidget);

      await tester.tap(find.byKey(const Key('medical_letter_S')));
      await tester.pump();

      expect(find.byType(MedicalTermCard), findsOneWidget);
      expect(find.text('Shock (hypoperfusion)'), findsOneWidget);
    });

    testWidgets('localized titles follow app locale', (tester) async {
      await pumpMedicalScreen(
        tester,
        await host(locale: const Locale('ru'), localeCode: 'ru'),
      );

      expect(find.text('Шок (гипоперфузия)'), findsOneWidget);
      expect(find.text('Гипотермия'), findsOneWidget);
    });
  });
}
