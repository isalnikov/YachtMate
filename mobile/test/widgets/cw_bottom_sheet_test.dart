import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/widgets/cw_bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget host({required void Function(BuildContext context) onOpen}) {
    return MaterialApp(
      theme: CwTheme.material(),
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: ElevatedButton(
                onPressed: () => onOpen(context),
                child: const Text('Open sheet'),
              ),
            ),
          );
        },
      ),
    );
  }

  group('showCwBottomSheet', () {
    testWidgets('shows title, drag handle, and close button', (tester) async {
      await tester.pumpWidget(
        host(
          onOpen: (context) => showCwBottomSheet(
            context: context,
            title: 'Map Layers',
            child: const Text('Sheet body'),
          ),
        ),
      );

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Map Layers'), findsOneWidget);
      expect(find.text('Sheet body'), findsOneWidget);
      expect(find.byKey(const Key('cw_bottom_sheet_drag_handle')), findsOneWidget);
      expect(find.byKey(const Key('cw_bottom_sheet_close')), findsOneWidget);
      expect(find.byIcon(Icons.close), findsOneWidget);
    });

    testWidgets('close button dismisses the sheet', (tester) async {
      await tester.pumpWidget(
        host(
          onOpen: (context) => showCwBottomSheet(
            context: context,
            title: 'Map Layers',
            child: const Text('Sheet body'),
          ),
        ),
      );

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();
      expect(find.byType(CwBottomSheet), findsOneWidget);

      await tester.tap(find.byKey(const Key('cw_bottom_sheet_close')));
      await tester.pumpAndSettle();

      expect(find.byType(CwBottomSheet), findsNothing);
    });

    testWidgets('sheet height does not exceed 50% of screen', (tester) async {
      tester.view.physicalSize = const Size(390, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        host(
          onOpen: (context) => showCwBottomSheet(
            context: context,
            title: 'Map Layers',
            child: const Text('Sheet body'),
          ),
        ),
      );

      await tester.tap(find.text('Open sheet'));
      await tester.pumpAndSettle();

      final sheetBox = tester.renderObject<RenderBox>(
        find.byType(CwBottomSheet),
      );
      expect(sheetBox.size.height, lessThanOrEqualTo(800 * 0.5 + 1));
    });
  });
}
