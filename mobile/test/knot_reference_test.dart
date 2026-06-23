import 'dart:io';

import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/repositories/knot_reference_repository.dart';
import 'package:captain_wrongel/domain/reference/knot_entry.dart';
import 'package:captain_wrongel/features/reference/knot_favorites_preferences.dart';
import 'package:captain_wrongel/features/reference/widgets/knot_category_chips.dart';
import 'package:captain_wrongel/features/reference/widgets/knot_step_list.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test('parseKnotsCatalogJson parses titles and steps by language', () {
    const raw = r'''
{
  "version": 1,
  "knots": [
    {
      "id": "bowline",
      "category": "loops",
      "difficulty": "easy",
      "useCases": { "en": "Loop", "ru": "Петля" },
      "titles": { "en": "Bowline", "ru": "Булинь" },
      "steps": { "en": ["a", "b"], "ru": ["а", "б"] }
    }
  ]
}''';
    final one = parseKnotsCatalogJson(raw);
    expect(one, hasLength(1));
    final k = one.single;
    expect(k.id, 'bowline');
    expect(k.difficulty, 'easy');
    expect(k.useCaseForLang('en'), 'Loop');
    expect(k.titleForLang('en'), 'Bowline');
    expect(k.titleForLang('de'), 'Bowline');
    expect(k.stepsForLang('ru'), hasLength(2));
  });

  test('bundled knots_demo.json has six entries with metadata', () {
    final file = File('assets/reference/knots_demo.json');
    final raw = file.readAsStringSync();
    final list = parseKnotsCatalogJson(raw);
    expect(list, hasLength(6));
    expect(list.any((k) => k.id == 'bowline'), isTrue);
    expect(list.every((k) => k.useCaseForLang('en').isNotEmpty), isTrue);
  });

  test('KnotEntry.fromJson requires en fallback in model', () {
    final k = KnotEntry.fromJson({
      'id': 'x',
      'category': 'loops',
      'titles': {'en': 'E'},
      'steps': {
        'en': ['1'],
      },
    });
    expect(k.titleForLang('es'), 'E');
    expect(k.difficulty, 'easy');
    expect(k.useCaseForLang('en'), '');
  });

  test('KnotFavoritesNotifier persists favorite ids', () async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);

    final notifier = container.read(knotFavoritesProvider.notifier);
    expect(container.read(knotFavoritesProvider), isEmpty);

    await notifier.toggle('bowline');
    expect(container.read(knotFavoritesProvider), {'bowline'});
    expect(prefs.getStringList(kKnotFavoritesKey), ['bowline']);

    await notifier.toggle('bowline');
    expect(container.read(knotFavoritesProvider), isEmpty);
    expect(prefs.getStringList(kKnotFavoritesKey), isEmpty);
  });

  group('knot widgets', () {
    Widget wrap(Widget child) {
      return ProviderScope(
        child: MaterialApp(
          theme: CwTheme.material(),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('KnotCategoryChips renders all and category labels', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          KnotCategoryChips(
            selected: null,
            categories: const ['loops', 'bends'],
            onSelected: (_) {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Loops'), findsOneWidget);
      expect(find.text('Bends'), findsOneWidget);
    });

    testWidgets('KnotStepList renders numbered steps without chevron', (
      tester,
    ) async {
      await tester.pumpWidget(
        wrap(
          const KnotStepList(
            heading: 'Steps',
            steps: ['First step', 'Second step'],
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('First step'), findsOneWidget);
      expect(find.text('Second step'), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsNothing);
      expect(find.text('1'), findsOneWidget);
      expect(find.text('2'), findsOneWidget);
    });
  });
}
