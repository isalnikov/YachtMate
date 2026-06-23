import 'package:captain_wrongel/core/theme/cw_theme.dart';
import 'package:captain_wrongel/data/local/app_database.dart';
import 'package:captain_wrongel/features/mooring/widgets/mooring_card.dart';
import 'package:captain_wrongel/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Widget wrap(Widget child) {
    return MaterialApp(
      theme: CwTheme.material(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );
  }

  final place = MooringPlaceRow(
    id: 'demo_marina',
    kind: 'marina',
    name: 'Fethiye Marina',
    lat: 36.755,
    lon: 29.1045,
    vhf: '72',
    phone: null,
    email: null,
    websiteUrl: null,
    bookingUrl: null,
    servicesJson: '{"depthM":3}',
    notes: null,
    sourceUpdatedAtMs: null,
  );

  testWidgets('MooringCard shows name, rating, and depth chip', (tester) async {
    await tester.pumpWidget(
      wrap(
        MooringCard(
          place: place,
          distanceNm: 2.4,
          onTap: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Fethiye Marina'), findsOneWidget);
    expect(find.text('3 m'), findsOneWidget);
    expect(find.text('2.4 nm'), findsOneWidget);
    expect(find.byIcon(Icons.star_rounded), findsWidgets);
  });

  testWidgets('MooringCard tap invokes callback', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      wrap(
        MooringCard(
          place: place,
          onTap: () => tapped = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text('Fethiye Marina'));
    expect(tapped, isTrue);
  });
}
