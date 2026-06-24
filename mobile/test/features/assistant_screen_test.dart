import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/features/assistant/assistant_screen.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AssistantScreen canned weather intent replies', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: CwTheme.material(),
        locale: const Locale('en'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: AssistantScreen()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('offline deck assistant'), findsOneWidget);

    await tester.tap(find.text('Weather'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Weather tab'), findsOneWidget);
  });
}
