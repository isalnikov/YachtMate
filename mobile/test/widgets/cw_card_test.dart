import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/core/theme/cw_theme_extensions.dart';
import 'package:captain_wrongel/core/theme/cw_tokens.dart';
import 'package:captain_wrongel/widgets/cw_badge.dart';
import 'package:captain_wrongel/widgets/cw_card.dart';
import 'package:captain_wrongel/widgets/cw_chip.dart';
import 'package:captain_wrongel/widgets/cw_list_tile.dart';
import 'package:captain_wrongel/widgets/cw_section_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: CwTheme.material(),
      home: Scaffold(body: child),
    );
  }

  group('CwCard', () {
    testWidgets('uses panel background, zero elevation, md radius', (tester) async {
      await tester.pumpWidget(
        wrap(const CwCard(child: Text('Content'))),
      );

      final material = tester.widget<Material>(
        find.descendant(
          of: find.byType(CwCard),
          matching: find.byType(Material),
        ),
      );
      final colors = CwColors.light;

      expect(material.elevation, 0);
      expect(material.color, colors.panelBlue);

      final shape = material.shape as RoundedRectangleBorder;
      expect(shape.borderRadius, BorderRadius.circular(CwRadius.md));
      expect(
        shape.side.color,
        colors.accentTeal.withValues(alpha: 0.12),
      );
    });

    testWidgets('applies default m padding', (tester) async {
      await tester.pumpWidget(
        wrap(const CwCard(child: Text('Content'))),
      );

      final padding = tester.widget<Padding>(
        find.descendant(
          of: find.byType(CwCard),
          matching: find.byType(Padding),
        ).first,
      );

      expect(padding.padding, const EdgeInsets.all(CwSpacing.m));
    });

    testWidgets('onTap invokes callback', (tester) async {
      var tapped = false;
      await tester.pumpWidget(
        wrap(
          CwCard(
            onTap: () => tapped = true,
            child: const Text('Tap me'),
          ),
        ),
      );

      await tester.tap(find.text('Tap me'));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });

  group('CwListTile', () {
    testWidgets('renders title, subtitle, and trailing icon', (tester) async {
      await tester.pumpWidget(
        wrap(
          const CwListTile(
            title: 'Settings',
            subtitle: 'App preferences',
            leading: Icon(Icons.settings_outlined),
          ),
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('App preferences'), findsOneWidget);
      expect(find.byIcon(Icons.settings_outlined), findsOneWidget);
      expect(find.byIcon(Icons.chevron_right), findsOneWidget);
    });
  });

  group('CwChip', () {
    testWidgets('toggles selection on tap', (tester) async {
      var selected = false;
      await tester.pumpWidget(
        wrap(
          StatefulBuilder(
            builder: (context, setState) {
              return CwChip(
                label: 'Marina',
                selected: selected,
                onSelected: (value) => setState(() => selected = value),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Marina'));
      await tester.pump();

      expect(selected, isTrue);
    });
  });

  group('CwBadge', () {
    testWidgets('renders danger, safe, and info variants', (tester) async {
      await tester.pumpWidget(
        wrap(
          const Column(
            children: [
              CwBadge(label: 'SOS', variant: CwBadgeVariant.danger),
              CwBadge(label: 'OK', variant: CwBadgeVariant.safe),
              CwBadge(label: 'NEW', variant: CwBadgeVariant.info),
            ],
          ),
        ),
      );

      expect(find.text('SOS'), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
      expect(find.text('NEW'), findsOneWidget);
    });
  });

  group('CwSectionHeader', () {
    testWidgets('renders uppercase label', (tester) async {
      await tester.pumpWidget(
        wrap(const CwSectionHeader(label: 'Safety')),
      );

      expect(find.text('SAFETY'), findsOneWidget);
    });
  });
}
