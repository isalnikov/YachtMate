import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/mooring/mooring_detail_sheet.dart';
import 'package:captain_wrongel/features/mooring/mooring_map_navigation.dart';
import 'package:captain_wrongel/features/mooring/mooring_providers.dart';
import 'package:captain_wrongel/features/mooring/widgets/mooring_review_section.dart';
import 'package:captain_wrongel/features/mooring/widgets/mooring_service_chips.dart';
import 'package:captain_wrongel/features/shell/shell_tab_provider.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final place = MooringPlaceRow(
    id: 'fethiye_marina_demo',
    kind: 'marina',
    name: 'Fethiye Marina (demo catalog)',
    lat: 36.755,
    lon: 29.1045,
    vhf: '72',
    phone: '+90 252 xxx xxxx',
    email: 'harbourmaster@example.com',
    websiteUrl: 'https://www.openstreetmap.org',
    bookingUrl: null,
    servicesJson:
        '{"electricity": true, "water": true, "wifi": true, "fuel": true}',
    notes: 'Demo POI near Fethiye town.',
    sourceUpdatedAtMs: null,
  );

  Future<ProviderContainer> buildContainer() async {
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    return ProviderContainer(
      overrides: [
        databaseProvider.overrideWith((ref) => db),
        sessionIdProvider.overrideWith((ref) => 'mooring-detail-test'),
      ],
    );
  }

  Widget wrap(Widget child, ProviderContainer container) {
    return UncontrolledProviderScope(
      container: container,
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(body: child),
      ),
    );
  }

  testWidgets('detail sheet shows hero, service chips, and navigate CTA',
      (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await buildContainer();

    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => showMooringDetailSheet(
                  context: context,
                  place: place,
                ),
                child: const Text('Open'),
              ),
            );
          },
        ),
        container,
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mooring_detail_hero')), findsOneWidget);
    expect(find.text('Fethiye Marina (demo catalog)'), findsOneWidget);
    expect(find.byType(MooringServiceChips), findsOneWidget);
    expect(find.byKey(const Key('mooring_service_water')), findsOneWidget);
    expect(find.byKey(const Key('mooring_service_electricity')), findsOneWidget);
    expect(find.byKey(const Key('mooring_service_wifi')), findsOneWidget);
    expect(find.text('Water'), findsOneWidget);
    expect(find.text('Electricity'), findsOneWidget);
    expect(find.text('Wi‑Fi'), findsOneWidget);

    final scrollable = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(
      find.byKey(const Key('mooring_navigate_map')),
      120,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('mooring_navigate_map')), findsOneWidget);
    expect(find.text('Navigate here'), findsOneWidget);
  });

  testWidgets('navigate CTA switches to map tab and sets camera target',
      (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await buildContainer();

    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => showMooringDetailSheet(
                  context: context,
                  place: place,
                ),
                child: const Text('Open'),
              ),
            );
          },
        ),
        container,
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final scrollable = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(
      find.byKey(const Key('mooring_navigate_map')),
      120,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('mooring_navigate_map')));
    await tester.pumpAndSettle();

    expect(container.read(shellTabIndexProvider), 0);
    final target = container.read(mapCameraTargetProvider);
    expect(target, isNotNull);
    expect(target!.lat, place.lat);
    expect(target.lon, place.lon);
    expect(find.byType(MooringReviewSection), findsNothing);
  });

  testWidgets('review section queues draft and closes sheet', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = await buildContainer();

    await tester.pumpWidget(
      wrap(
        Builder(
          builder: (context) {
            return Center(
              child: ElevatedButton(
                onPressed: () => showMooringDetailSheet(
                  context: context,
                  place: place,
                ),
                child: const Text('Open'),
              ),
            );
          },
        ),
        container,
      ),
    );

    await tester.tap(find.text('Open'));
    await tester.pumpAndSettle();

    final scrollable = find.byType(Scrollable).last;
    await tester.scrollUntilVisible(
      find.byKey(const Key('mooring_review_comment')),
      120,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();

    await tester.enterText(
      find.byKey(const Key('mooring_review_comment')),
      'Great berth',
    );
    await tester.scrollUntilVisible(
      find.byKey(const Key('mooring_review_save')),
      120,
      scrollable: scrollable,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('mooring_review_save')));
    await tester.pumpAndSettle();

    final repo = container.read(mooringRepositoryProvider);
    final pending = await repo.pendingReviews();
    expect(pending, hasLength(1));
    expect(pending.single.placeId, place.id);
    expect(pending.single.stars, 4);
    expect(pending.single.comment, 'Great berth');
    expect(find.byType(MooringReviewSection), findsNothing);
  });

  test('service availability helper respects bool values', () {
    final services = parseMooringServicesJson(
      '{"water": true, "electricity": false, "wifi": true}',
    );
    expect(mooringServiceAvailable(services, 'water'), isTrue);
    expect(mooringServiceAvailable(services, 'electricity'), isFalse);
    expect(mooringServiceAvailable(services, 'wifi'), isTrue);
    expect(mooringServiceAvailable(services, 'fuel'), isFalse);
  });
}
