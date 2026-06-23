import 'tide_demo_models.dart';

/// One calendar day of high/low water events (demo extrapolation).
class TideDaySchedule {
  const TideDaySchedule({
    required this.dateLocal,
    required this.highs,
    required this.lows,
  });

  final DateTime dateLocal;
  final List<TideEvent> highs;
  final List<TideEvent> lows;
}

/// Shifts bundled demo events into a 7-day illustrative schedule.
List<TideDaySchedule> buildTideWeekSchedule(List<TideEvent> anchorEvents) {
  if (anchorEvents.isEmpty) return const [];

  final sorted = [...anchorEvents]..sort((a, b) => a.timeUtc.compareTo(b.timeUtc));
  final firstLocal = sorted.first.timeUtc.toLocal();
  final anchorDay = DateTime(firstLocal.year, firstLocal.month, firstLocal.day);

  const lunarDelay = Duration(minutes: 50);
  const days = 7;

  final rows = <TideDaySchedule>[];
  for (var d = 0; d < days; d++) {
    final dayStart = anchorDay.add(Duration(days: d));
    final dayShift = lunarDelay * d;
    final highs = <TideEvent>[];
    final lows = <TideEvent>[];

    for (final e in sorted) {
      final local = e.timeUtc.toLocal();
      final timeOnDay = DateTime(
        dayStart.year,
        dayStart.month,
        dayStart.day,
        local.hour,
        local.minute,
        local.second,
      ).add(dayShift);
      final shifted = TideEvent(
        timeUtc: timeOnDay.toUtc(),
        heightM: e.heightM,
        isHigh: e.isHigh,
      );
      if (e.isHigh) {
        highs.add(shifted);
      } else {
        lows.add(shifted);
      }
    }

    highs.sort((a, b) => a.timeUtc.compareTo(b.timeUtc));
    lows.sort((a, b) => a.timeUtc.compareTo(b.timeUtc));
    rows.add(TideDaySchedule(dateLocal: dayStart, highs: highs, lows: lows));
  }
  return rows;
}

/// Events for the first chart day, extended one cycle for smooth ends.
List<TideEvent> chartEventsForDay(List<TideEvent> anchorEvents, DateTime dayLocal) {
  if (anchorEvents.isEmpty) return const [];

  final week = buildTideWeekSchedule(anchorEvents);
  if (week.isEmpty) return const [];

  final day = week.firstWhere(
    (r) =>
        r.dateLocal.year == dayLocal.year &&
        r.dateLocal.month == dayLocal.month &&
        r.dateLocal.day == dayLocal.day,
    orElse: () => week.first,
  );

  final events = [...day.highs, ...day.lows]
    ..sort((a, b) => a.timeUtc.compareTo(b.timeUtc));

  if (events.length < 2) return events;

  final first = events.first;
  final last = events.last;
  final period = last.timeUtc.difference(first.timeUtc);
  final before = TideEvent(
    timeUtc: first.timeUtc.subtract(period ~/ (events.length - 1)),
    heightM: last.isHigh == first.isHigh ? last.heightM : first.heightM,
    isHigh: !first.isHigh,
  );
  final after = TideEvent(
    timeUtc: last.timeUtc.add(period ~/ (events.length - 1)),
    heightM: first.isHigh == last.isHigh ? first.heightM : last.heightM,
    isHigh: !last.isHigh,
  );

  return [before, ...events, after];
}
