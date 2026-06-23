import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/data/repositories/audit_repository.dart';
import 'package:captain_wrongel/domain/coastal/shore_poi.dart';
import 'package:captain_wrongel/features/coastal/coastal_guide_screen.dart';
import 'package:captain_wrongel/features/coastal/widgets/coastal_category_chips.dart';
import 'package:captain_wrongel/features/coastal/widgets/shore_poi_card.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:captain_wrongel/widgets/cw_chip.dart';
import 'package:captain_wrongel/widgets/cw_search_bar.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _demoPois = <ShorePoi>[
  ShorePoi(
    id: 'beach_club_demo',
    category: 'beach',
    lat: 36.72,
    lon: 29.12,
    titles: {'en': 'Beach café (demo)', 'ru': 'Пляжное кафе (демо)'},
    bodies: {
      'en': 'Fresh water tap, showers. Demo POI only.',
      'ru': 'Кран с пресной водой, души. Только демо-точка.',
    },
  ),
  ShorePoi(
    id: 'fuel_ashore_demo',
    category: 'fuel',
    lat: 36.68,
    lon: 29.05,
    titles: {
      'en': 'Road diesel canister pickup (demo)',
      'ru': 'Забор канистры с соляркой (демо)',
    },
    bodies: {
      'en': 'Coordinate with marina office. Synthetic example.',
      'ru': 'Согласовать в офисе марины. Синтетический пример.',
    },
  ),
];

void main() {
  Future<Widget> host({Locale locale = const Locale('en')}) async {
    SharedPreferences.setMockInitialValues({});
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'step35'),
        auditRepositoryProvider.overrideWithValue(AuditRepository(db)),
        shorePoisProvider.overrideWith((ref) async => _demoPois),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: CoastalGuideScreen()),
      ),
    );
  }

  Future<void> mountCoastal(WidgetTester tester) async {
    await tester.pumpWidget(await host());
    await tester.pumpAndSettle();
  }

  group('CoastalGuideScreen', () {
    testWidgets('loads demo GeoJSON into CwCard list', (tester) async {
      await mountCoastal(tester);

      expect(find.byType(CwSearchBar), findsOneWidget);
      expect(find.byType(CoastalCategoryChips), findsOneWidget);
      expect(find.byType(ShorePoiCard), findsNWidgets(2));
      expect(find.byType(CwCard), findsNWidgets(2));
      expect(find.text('Beach café (demo)'), findsOneWidget);
      expect(find.text('Road diesel canister pickup (demo)'), findsOneWidget);
    });

    testWidgets('filters POIs by category chip', (tester) async {
      await mountCoastal(tester);

      await tester.tap(find.byKey(const Key('coastal_category_beach')));
      await tester.pumpAndSettle();

      expect(find.byType(ShorePoiCard), findsOneWidget);
      expect(find.text('Beach café (demo)'), findsOneWidget);
      expect(find.text('Road diesel canister pickup (demo)'), findsNothing);
    });

    testWidgets('filters POIs by search query', (tester) async {
      await mountCoastal(tester);

      await tester.enterText(find.byType(CwSearchBar), 'diesel');
      await tester.pumpAndSettle();

      expect(find.byType(ShorePoiCard), findsOneWidget);
      expect(find.text('Road diesel canister pickup (demo)'), findsOneWidget);
      expect(find.text('Beach café (demo)'), findsNothing);
    });

    testWidgets('expands card to show coordinates', (tester) async {
      await mountCoastal(tester);

      expect(find.textContaining('36.7200'), findsNothing);

      await tester.tap(find.byKey(const Key('shore_poi_beach_club_demo')));
      await tester.pumpAndSettle();

      expect(find.textContaining('36.7200'), findsOneWidget);
      expect(find.textContaining('29.1200'), findsOneWidget);
    });

    testWidgets('shows no-match message when filters exclude all', (tester) async {
      await mountCoastal(tester);

      await tester.enterText(find.byType(CwSearchBar), 'nonexistent poi');
      await tester.pumpAndSettle();

      expect(find.text('No POIs match your filters.'), findsOneWidget);
      expect(find.byType(ShorePoiCard), findsNothing);
    });

    testWidgets('category chips include All and demo types', (tester) async {
      await mountCoastal(tester);

      expect(find.byType(CwChip), findsNWidgets(3));
      expect(find.byKey(const Key('coastal_category_all')), findsOneWidget);
      expect(find.byKey(const Key('coastal_category_beach')), findsOneWidget);
      expect(find.byKey(const Key('coastal_category_fuel')), findsOneWidget);
    });
  });
}
