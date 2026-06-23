import 'package:captain_wrongel/domain/tides/tide_demo_models.dart';
import 'package:captain_wrongel/domain/tides/tide_week_schedule.dart';
import 'package:captain_wrongel/features/tides/tides_screen.dart';
import 'package:captain_wrongel/features/tides/widgets/tide_curve_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:captain_wrongel/l10n/app_localizations.dart';

void main() {
  final anchorEvents = [
    TideEvent(
      timeUtc: DateTime.utc(2026, 4, 22, 3, 15),
      heightM: 3.4,
      isHigh: true,
    ),
    TideEvent(
      timeUtc: DateTime.utc(2026, 4, 22, 9, 40),
      heightM: 0.8,
      isHigh: false,
    ),
    TideEvent(
      timeUtc: DateTime.utc(2026, 4, 22, 15, 55),
      heightM: 3.1,
      isHigh: true,
    ),
    TideEvent(
      timeUtc: DateTime.utc(2026, 4, 22, 22, 10),
      heightM: 1.0,
      isHigh: false,
    ),
  ];

  test('buildTideWeekSchedule produces seven days', () {
    final week = buildTideWeekSchedule(anchorEvents);
    expect(week, hasLength(7));
    expect(week.first.highs, hasLength(2));
    expect(week.first.lows, hasLength(2));
    expect(
      week.last.dateLocal.difference(week.first.dateLocal).inDays,
      6,
    );
  });

  test('catmullRomSample interpolates between control points', () {
    expect(catmullRomSample(0, 1, 2, 3, 0), closeTo(1, 0.001));
    expect(catmullRomSample(0, 1, 2, 3, 1), closeTo(2, 0.001));
  });

  test('tideHeightAt returns event height at extrema', () {
    final atHigh = tideHeightAt(anchorEvents, anchorEvents.first.timeUtc);
    expect(atHigh, closeTo(3.4, 0.01));
  });

  testWidgets('TidesScreen renders demo station and sections', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const TidesScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Tides'), findsOneWidget);
    expect(find.text('Demo tide curve (illustrative)'), findsOneWidget);
    expect(find.text("Today's curve (demo)"), findsOneWidget);
    expect(find.text('7-day schedule (demo)'), findsOneWidget);
    expect(find.text('Moon phase'), findsOneWidget);
    expect(find.textContaining('Sunrise'), findsOneWidget);
    expect(find.byType(CustomPaint), findsWidgets);

    await tester.scrollUntilVisible(
      find.text('Day'),
      48,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Day'), findsOneWidget);
  });
}
