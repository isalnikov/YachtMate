import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/widgets/cw_button.dart';
import 'package:captain_wrongel/widgets/cw_button_sizes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: CwTheme.material(),
      home: Scaffold(body: Center(child: child)),
    );
  }

  group('CwButtonSize', () {
    test('md and lg match glove touch targets', () {
      expect(CwButtonSize.md.minHeight, 44);
      expect(CwButtonSize.lg.minHeight, 52);
      expect(CwButtonSize.fromGloveMode(false), CwButtonSize.md);
      expect(CwButtonSize.fromGloveMode(true), CwButtonSize.lg);
    });

    test('CwFabSize matches circular FAB spec', () {
      expect(CwFabSize.sm.diameter, 48);
      expect(CwFabSize.lg.diameter, 56);
    });
  });

  group('CwButton', () {
    testWidgets('tap invokes onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          CwButton(
            label: 'Save',
            expand: false,
            onPressed: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('disabled button ignores tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          CwButton(
            label: 'Save',
            expand: false,
            onPressed: null,
          ),
        ),
      );

      await tester.tap(find.text('Save'));
      await tester.pump();

      expect(tapped, isFalse);
    });

    testWidgets('loading shows progress indicator instead of label', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CwButton(
            label: 'Save',
            expand: false,
            loading: true,
            onPressed: _noop,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Save'), findsNothing);
    });

    testWidgets('semantics label is exposed', (tester) async {
      await tester.pumpWidget(
        wrap(
          CwButton(
            label: 'Save',
            semanticLabel: 'Save changes',
            expand: false,
            onPressed: () {},
          ),
        ),
      );

      expect(find.bySemanticsLabel('Save changes'), findsOneWidget);
    });

    testWidgets('enforces minimum height for md size', (tester) async {
      await tester.pumpWidget(
        wrap(
          CwButton(
            label: 'Save',
            size: CwButtonSize.md,
            expand: false,
            onPressed: () {},
          ),
        ),
      );

      final box = tester.getSize(find.byType(CwButton));
      expect(box.height, greaterThanOrEqualTo(44));
    });
  });

  group('CwIconButton', () {
    testWidgets('tap invokes onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          CwIconButton(
            icon: Icons.settings,
            semanticLabel: 'Settings',
            onPressed: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.settings));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('loading shows progress indicator', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CwIconButton(
            icon: Icons.settings,
            semanticLabel: 'Settings',
            loading: true,
            onPressed: _noop,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byIcon(Icons.settings), findsNothing);
    });
  });

  group('CwFab', () {
    testWidgets('tap invokes onPressed', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          CwFab(
            icon: Icons.add,
            semanticLabel: 'Add waypoint',
            onPressed: () => tapped = true,
          ),
        ),
      );

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('disabled FAB ignores tap', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          CwFab(
            icon: Icons.add,
            semanticLabel: 'Add waypoint',
            onPressed: () => tapped = true,
          ),
        ),
      );

      await tester.pumpWidget(
        wrap(
          CwFab(
            icon: Icons.add,
            semanticLabel: 'Add waypoint',
            onPressed: null,
          ),
        ),
      );

      await tester.tap(find.byType(CwFab));
      await tester.pump();

      expect(tapped, isFalse);
    });
  });
}

void _noop() {}
