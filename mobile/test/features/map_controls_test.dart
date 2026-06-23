import 'package:captain_wrongel/core/accessibility_preferences_controller.dart';
import 'package:captain_wrongel/core/providers.dart';
import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/map/widgets/map_compass_button.dart';
import 'package:captain_wrongel/features/map/widgets/map_controls_overlay.dart';
import 'package:captain_wrongel/features/map/widgets/map_zoom_buttons.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_button_sizes.dart';
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<Widget> wrap(
    Widget child, {
    Map<String, Object> prefs = const {},
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
        sessionIdProvider.overrideWith((ref) => 'map-controls-test'),
      ],
      child: MaterialApp(
        theme: CwTheme.material(),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Stack(
            children: [child],
          ),
        ),
      ),
    );
  }

  group('MapZoomButtons', () {
    testWidgets('invokes zoom callbacks', (tester) async {
      var zoomIn = false;
      var zoomOut = false;

      await tester.pumpWidget(
        await wrap(
          MapZoomButtons(
            zoomInLabel: 'Zoom in',
            zoomOutLabel: 'Zoom out',
            onZoomIn: () => zoomIn = true,
            onZoomOut: () => zoomOut = true,
          ),
        ),
      );

      await tester.tap(find.bySemanticsLabel('Zoom in'));
      await tester.pump();
      expect(zoomIn, isTrue);

      await tester.tap(find.bySemanticsLabel('Zoom out'));
      await tester.pump();
      expect(zoomOut, isTrue);
    });

    testWidgets('uses 48dp FAB touch targets', (tester) async {
      await tester.pumpWidget(
        await wrap(
          MapZoomButtons(
            zoomInLabel: 'Zoom in',
            zoomOutLabel: 'Zoom out',
            onZoomIn: () {},
            onZoomOut: () {},
          ),
        ),
      );

      final fab = tester.getSize(find.bySemanticsLabel('Zoom in'));
      expect(fab.width, 48);
      expect(fab.height, 48);
    });
  });

  group('MapCompassButton', () {
    testWidgets('toggles via callback', (tester) async {
      var toggled = false;

      await tester.pumpWidget(
        await wrap(
          MapCompassButton(
            headingUp: false,
            mapBearing: 45,
            northUpLabel: 'North up',
            headingUpLabel: 'Heading up',
            onToggle: () => toggled = true,
          ),
        ),
      );

      await tester.tap(find.byType(MapCompassButton));
      await tester.pump();
      expect(toggled, isTrue);
    });

    testWidgets('shows heading-up semantics when active', (tester) async {
      await tester.pumpWidget(
        await wrap(
          const MapCompassButton(
            headingUp: true,
            mapBearing: 0,
            northUpLabel: 'North up',
            headingUpLabel: 'Heading up',
            onToggle: _noop,
          ),
        ),
      );

      expect(find.bySemanticsLabel('Heading up'), findsOneWidget);
      expect(find.byIcon(Icons.navigation), findsOneWidget);
    });
  });

  group('MapControlsOverlay', () {
    testWidgets('renders zoom, compass, layers, and follow GPS', (tester) async {
      await tester.pumpWidget(
        await wrap(
          MapControlsOverlay(
            enabled: true,
            headingUp: false,
            mapBearing: 0,
            followGps: false,
            onZoomIn: () {},
            onZoomOut: () {},
            onCompassToggle: () {},
            onLayers: () {},
            onFollowGpsToggle: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(MapZoomButtons), findsOneWidget);
      expect(find.byType(MapCompassButton), findsOneWidget);
      expect(find.byIcon(Icons.layers_outlined), findsOneWidget);
      expect(find.byIcon(Icons.gps_not_fixed), findsOneWidget);
      expect(find.byType(CwFab), findsNWidgets(5));
    });

    testWidgets('follow GPS active shows gps_fixed icon', (tester) async {
      await tester.pumpWidget(
        await wrap(
          MapControlsOverlay(
            enabled: true,
            headingUp: false,
            mapBearing: 0,
            followGps: true,
            onZoomIn: () {},
            onZoomOut: () {},
            onCompassToggle: () {},
            onLayers: () {},
            onFollowGpsToggle: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.gps_fixed), findsOneWidget);
      expect(find.bySemanticsLabel('Following GPS — tap to stop'), findsOneWidget);
    });

    testWidgets('layers button opens callback', (tester) async {
      var layersOpened = false;

      await tester.pumpWidget(
        await wrap(
          MapControlsOverlay(
            enabled: true,
            headingUp: false,
            mapBearing: 0,
            followGps: false,
            onZoomIn: () {},
            onZoomOut: () {},
            onCompassToggle: () {},
            onLayers: () => layersOpened = true,
            onFollowGpsToggle: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.bySemanticsLabel('Map layers'));
      await tester.pump();
      expect(layersOpened, isTrue);
    });

    testWidgets('positions overlay 12dp from the right edge', (tester) async {
      await tester.pumpWidget(
        await wrap(
          MapControlsOverlay(
            enabled: true,
            headingUp: false,
            mapBearing: 0,
            followGps: false,
            onZoomIn: () {},
            onZoomOut: () {},
            onCompassToggle: () {},
            onLayers: () {},
            onFollowGpsToggle: () {},
          ),
        ),
      );
      await tester.pumpAndSettle();

      final positioned = tester.widget<Positioned>(
        find.byWidgetPredicate(
          (widget) => widget is Positioned && widget.right == 12,
        ),
      );
      expect(positioned.right, 12);
    });

    testWidgets('glove mode uses 56dp FABs', (tester) async {
      await tester.pumpWidget(
        await wrap(
          MapControlsOverlay(
            enabled: true,
            headingUp: false,
            mapBearing: 0,
            followGps: false,
            onZoomIn: () {},
            onZoomOut: () {},
            onCompassToggle: () {},
            onLayers: () {},
            onFollowGpsToggle: () {},
          ),
          prefs: {
            AccessibilityPreferencesController.glovePreferenceKey: true,
          },
        ),
      );
      await tester.pumpAndSettle();

      final fab = tester.getSize(find.bySemanticsLabel('Zoom in'));
      expect(fab.width, CwFabSize.lg.diameter);
      expect(fab.height, CwFabSize.lg.diameter);
    });
  });
}

void _noop() {}
