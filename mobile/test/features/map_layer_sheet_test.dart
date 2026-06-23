import 'package:captain_wrongel/core/map_layer_preferences_controller.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/map/map_layer_kinds.dart';
import 'package:captain_wrongel/features/map/map_layer_sheet.dart';
import 'package:captain_wrongel/features/map/widgets/layer_thumbnail_grid.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_bottom_sheet.dart';
import 'package:captain_wrongel/widgets/cw_section_header.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> host({
    Map<String, Object> prefs = const {},
    void Function(BuildContext context)? onOpen,
  }) async {
    SharedPreferences.setMockInitialValues(prefs);
    final shared = await SharedPreferences.getInstance();
    final db = AppDatabase(NativeDatabase.memory());

    return ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWith((ref) => shared),
        databaseProvider.overrideWith((ref) {
          ref.onDispose(db.close);
          return db;
        }),
        sessionIdProvider.overrideWith((ref) => 'map-layer-sheet-test'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (onOpen != null) {
                      onOpen(context);
                    } else {
                      showMapLayerSheet(context);
                    }
                  },
                  child: const Text('Open layers'),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  group('MapLayerSheetContent', () {
    testWidgets('shows OVERLAYS, CHART, and SHALLOW sections', (tester) async {
      await tester.pumpWidget(await host());
      await tester.tap(find.text('Open layers'));
      await tester.pumpAndSettle();

      expect(find.byType(CwSectionHeader), findsNWidgets(3));
      expect(find.text('OVERLAYS'), findsOneWidget);
      expect(find.text('CHART'), findsOneWidget);
      expect(find.text('SHALLOW'), findsOneWidget);
    });

    testWidgets('renders overlay and chart thumbnail grids', (tester) async {
      await tester.pumpWidget(await host());
      await tester.tap(find.text('Open layers'));
      await tester.pumpAndSettle();

      expect(find.byType(LayerThumbnailGrid), findsNWidgets(2));
      expect(find.text('No Overlay'), findsOneWidget);
      expect(find.text('Relief Shading'), findsOneWidget);
      expect(find.text('Standard'), findsOneWidget);
      expect(find.text('Night'), findsOneWidget);
    });

    testWidgets('selecting overlay updates provider', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final shared = await SharedPreferences.getInstance();
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      late ProviderContainer container;
      await tester.pumpWidget(
        ProviderScope(
          parent: container = ProviderContainer(
            overrides: [
              sharedPreferencesProvider.overrideWith((ref) => shared),
              databaseProvider.overrideWith((ref) => db),
              sessionIdProvider.overrideWith((ref) => 'overlay-select'),
            ],
          ),
          child: MaterialApp(
            theme: CwTheme.material(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: MapLayerSheetContent(),
              ),
            ),
          ),
        ),
      );
      addTearDown(container.dispose);
      await tester.pumpAndSettle();

      expect(
        container.read(mapLayerPreferencesProvider).overlay,
        MapOverlayKind.none,
      );

      await tester.tap(find.byKey(const Key('layer_thumbnail_reliefShading')));
      await tester.pumpAndSettle();

      expect(
        container.read(mapLayerPreferencesProvider).overlay,
        MapOverlayKind.reliefShading,
      );
    });

    testWidgets('selecting chart style updates provider', (tester) async {
      SharedPreferences.setMockInitialValues({});
      final shared = await SharedPreferences.getInstance();
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      late ProviderContainer container;
      await tester.pumpWidget(
        ProviderScope(
          parent: container = ProviderContainer(
            overrides: [
              sharedPreferencesProvider.overrideWith((ref) => shared),
              databaseProvider.overrideWith((ref) => db),
              sessionIdProvider.overrideWith((ref) => 'chart-select'),
            ],
          ),
          child: MaterialApp(
            theme: CwTheme.material(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: MapLayerSheetContent(),
              ),
            ),
          ),
        ),
      );
      addTearDown(container.dispose);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('layer_thumbnail_night')));
      await tester.pumpAndSettle();

      expect(
        container.read(mapLayerPreferencesProvider).chartStyle,
        ChartStyleKind.night,
      );
    });

    testWidgets('shallow highlight toggle updates provider', (tester) async {
      tester.view.physicalSize = const Size(800, 1200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      SharedPreferences.setMockInitialValues({});
      final shared = await SharedPreferences.getInstance();
      final db = AppDatabase(NativeDatabase.memory());
      addTearDown(db.close);

      late ProviderContainer container;
      await tester.pumpWidget(
        ProviderScope(
          parent: container = ProviderContainer(
            overrides: [
              sharedPreferencesProvider.overrideWith((ref) => shared),
              databaseProvider.overrideWith((ref) => db),
              sessionIdProvider.overrideWith((ref) => 'shallow-toggle'),
            ],
          ),
          child: MaterialApp(
            theme: CwTheme.material(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: SingleChildScrollView(
                child: MapLayerSheetContent(),
              ),
            ),
          ),
        ),
      );
      addTearDown(container.dispose);
      await tester.pumpAndSettle();

      final switchFinder = find.byKey(const Key('map_layer_shallow_highlight'));
      expect(tester.widget<SwitchListTile>(switchFinder).value, false);

      await tester.tap(switchFinder);
      await tester.pumpAndSettle();

      expect(
        container.read(mapLayerPreferencesProvider).shallowHighlight,
        true,
      );
      expect(tester.widget<SwitchListTile>(switchFinder).value, true);
    });

    testWidgets('selected overlay shows teal border', (tester) async {
      await tester.pumpWidget(
        await host(
          prefs: {
            MapLayerPreferencesController.overlayPreferenceKey: 'satellite',
          },
        ),
      );
      await tester.tap(find.text('Open layers'));
      await tester.pumpAndSettle();

      final satelliteTile = tester.widget<InkWell>(
        find.ancestor(
          of: find.text('Satellite'),
          matching: find.byType(InkWell),
        ),
      );
      expect(satelliteTile, isNotNull);

      final borderFinder = find.descendant(
        of: find.byKey(const Key('layer_thumbnail_satellite')),
        matching: find.byType(DecoratedBox),
      );
      final decorated = tester.widget<DecoratedBox>(borderFinder.first);
      final border = decorated.decoration! as BoxDecoration;
      expect(border.border, isA<Border>());
      final side = (border.border as Border).top;
      expect(side.width, 2);
      expect(side.color, CwTheme.accentTeal);
    });
  });

  group('showMapLayerSheet', () {
    testWidgets('opens from host via CwBottomSheet', (tester) async {
      await tester.pumpWidget(await host());
      await tester.tap(find.text('Open layers'));
      await tester.pumpAndSettle();

      expect(find.byType(CwBottomSheet), findsOneWidget);
      expect(find.text('Map layers (demo)'), findsOneWidget);
    });
  });
}
