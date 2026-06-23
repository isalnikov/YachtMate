import 'package:captain_wrongel/widgets/cw_split_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CwSplitView', () {
    testWidgets('shows only detail below breakpoint', (tester) async {
      await tester.binding.setSurfaceSize(const Size(600, 800));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CwSplitView(
              master: Text('master'),
              detail: Text('detail-only'),
            ),
          ),
        ),
      );

      expect(find.text('detail-only'), findsOneWidget);
      expect(find.text('master'), findsNothing);
      expect(find.byKey(const Key('cw_split_view')), findsNothing);
    });

    testWidgets('shows master and detail at tablet width', (tester) async {
      await tester.binding.setSurfaceSize(const Size(900, 600));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CwSplitView(
              master: Text('master-pane'),
              detail: Text('detail-pane'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('cw_split_view')), findsOneWidget);
      expect(find.text('master-pane'), findsOneWidget);
      expect(find.text('detail-pane'), findsOneWidget);
      expect(find.byType(VerticalDivider), findsOneWidget);
    });

    test('isSplitWidth respects 768 breakpoint', () {
      expect(CwSplitView.isSplitWidth(767), isFalse);
      expect(CwSplitView.isSplitWidth(768), isTrue);
      expect(CwSplitView.isSplitWidth(1024), isTrue);
    });
  });
}
