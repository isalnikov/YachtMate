import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/core/theme/cw_typography.dart';
import 'package:captain_wrongel/features/map/widgets/map_peek_sheet.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({
    required double lat,
    required double lon,
    double? depthMeters,
    String? navAidLabel,
    Size screenSize = const Size(390, 844),
  }) {
    return MaterialApp(
      theme: CwTheme.material(),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: MediaQuery(
        data: MediaQueryData(size: screenSize),
        child: Scaffold(
          body: Stack(
            children: [
              MapPeekSheet(
                lat: lat,
                lon: lon,
                depthMeters: depthMeters,
                navAidLabel: navAidLabel,
              ),
            ],
          ),
        ),
      ),
    );
  }

  group('MapPeekSheet', () {
    testWidgets('renders mono coordinates and depth label', (tester) async {
      await tester.pumpWidget(
        host(lat: 41.20575, lon: 2.576117, depthMeters: 15),
      );
      await tester.pumpAndSettle();

      final coords = tester.widget<Text>(
        find.descendant(
          of: find.byKey(const Key('map_peek_coords')),
          matching: find.byType(Text),
        ),
      );
      expect(coords.data, "41°12.345' N 002°34.567' E");
      expect(coords.style?.fontFamily, 'monospace');

      expect(find.byKey(const Key('map_peek_depth')), findsOneWidget);
      expect(find.text('Depth: 15 m'), findsOneWidget);
    });

    testWidgets('shows depth unavailable when no contour', (tester) async {
      await tester.pumpWidget(host(lat: 0, lon: 0));
      await tester.pumpAndSettle();

      expect(
        find.text(
          'No contour within range — enable the layer or move closer.',
        ),
        findsOneWidget,
      );
    });

    testWidgets('tap coords copies formatted text to clipboard', (tester) async {
      String? copied;
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(SystemChannels.platform, (call) async {
        if (call.method == 'Clipboard.setData') {
          copied = call.arguments['text'] as String?;
        }
        return null;
      });
      addTearDown(
        () => TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
            .setMockMethodCallHandler(SystemChannels.platform, null),
      );

      await tester.pumpWidget(host(lat: 41.20575, lon: 2.576117));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('map_peek_coords')));
      await tester.pump();

      expect(copied, CwTypography.formatCoords(41.20575, 2.576117));
      expect(find.text('Coordinates copied'), findsOneWidget);
    });

    testWidgets('uses DraggableScrollableSheet with 0.15–0.5 range', (tester) async {
      await tester.pumpWidget(host(lat: 36.65, lon: 29.12));
      await tester.pumpAndSettle();

      final sheet = tester.widget<DraggableScrollableSheet>(
        find.byKey(const Key('map_peek_sheet')),
      );
      expect(sheet.minChildSize, kMapPeekSheetMinFraction);
      expect(sheet.maxChildSize, kMapPeekSheetMaxFraction);
      expect(sheet.snap, isTrue);
    });

    testWidgets('initial fraction clamps 120dp peek to min 0.15', (tester) async {
      const screenSize = Size(390, 844);
      await tester.pumpWidget(
        host(
          lat: 36.65,
          lon: 29.12,
          screenSize: screenSize,
        ),
      );
      await tester.pumpAndSettle();

      final sheet = tester.widget<DraggableScrollableSheet>(
        find.byKey(const Key('map_peek_sheet')),
      );
      // 120 / 844 ≈ 0.142 — below min, so sheet uses 0.15.
      expect(sheet.initialChildSize, kMapPeekSheetMinFraction);

      final context = tester.element(find.byType(MapPeekSheet));
      expect(
        mapPeekSheetInitialFraction(context),
        kMapPeekSheetMinFraction,
      );
    });

    testWidgets('shows drag handle', (tester) async {
      await tester.pumpWidget(host(lat: 36.65, lon: 29.12));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('map_peek_drag_handle')), findsOneWidget);
    });

    testWidgets('includes nav aid row when provided', (tester) async {
      await tester.pumpWidget(
        host(
          lat: 36.65,
          lon: 29.12,
          navAidLabel: 'Fethiye Light',
        ),
      );
      await tester.pumpAndSettle();

      expect(
        find.text('Fethiye Light', skipOffstage: false),
        findsOneWidget,
      );
      expect(
        find.text('Nearest mark', skipOffstage: false),
        findsOneWidget,
      );
    });
  });
}
