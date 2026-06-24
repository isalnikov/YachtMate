import 'package:captain_wrongel/core/errors/cw_error_catalog.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('CwErrorCatalog messages resolve from l10n', (tester) async {
  late AppLocalizations l10n;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context)!;
            return const SizedBox();
          },
        ),
      ),
    );

    expect(CwErrorKind.network.message(l10n), contains('Network'));
    expect(CwErrorKind.gpsDenied.message(l10n), contains('permission'));
    expect(CwErrorKind.routingFailed.message(l10n), contains('Route'));
  });
}
