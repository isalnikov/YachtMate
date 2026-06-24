import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/features/more/more_menu_screen.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('MoreMenuScreen navigates to Community', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CwTheme.material(),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: MoreMenuScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Community'), findsOneWidget);
    await tester.tap(find.text('Community'));
    await tester.pumpAndSettle();

    expect(find.text('Göcek D-Marin'), findsOneWidget);
  });
}
