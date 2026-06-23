import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../core/theme/cw_tokens.dart';
import '../../domain/astro/moon_phase.dart';
import '../../domain/astro/suncalc_port.dart';
import '../../domain/tides/tide_demo_models.dart';
import '../../domain/tides/tide_week_schedule.dart';
import '../../l10n/app_localizations.dart';
import '../weather/weather_providers.dart';
import 'widgets/tide_curve_chart.dart';
import 'widgets/tide_table.dart';

/// Dedicated tides screen: curve, 7-day table, moon phase, sun times (demo).
class TidesScreen extends ConsumerWidget {
  const TidesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toLanguageTag();
    final tideAsync = ref.watch(tideDemoProvider);
    final pin = ref.watch(weatherPinProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.tidesScreenTitle)),
      body: tideAsync.when(
        data: (station) => _TidesBody(
          station: station,
          locale: locale,
          l10n: l10n,
          lat: pin.lat,
          lon: pin.lon,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class _TidesBody extends StatelessWidget {
  const _TidesBody({
    required this.station,
    required this.locale,
    required this.l10n,
    required this.lat,
    required this.lon,
  });

  final TideDemoStation station;
  final String locale;
  final AppLocalizations l10n;
  final double lat;
  final double lon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final events = station.events;
    if (events.isEmpty) {
      return Center(child: Text(l10n.tidesEmpty));
    }

    final anchorDay = events.first.timeUtc.toLocal();
    final chartDay = DateTime(anchorDay.year, anchorDay.month, anchorDay.day);
    final week = buildTideWeekSchedule(events);
    final timeFmt = DateFormat.Hm(locale);

    final solar = approximateSunriseSunsetUtc(
      latDeg: lat,
      lonDeg: lon,
      whenUtc: DateTime.utc(chartDay.year, chartDay.month, chartDay.day, 12),
    );

    String formatEvent(DateTime local, double heightM, bool isHigh) {
      final kind = isHigh ? l10n.tidesHighShort : l10n.tidesLowShort;
      return l10n.tidesTableCell(
        timeFmt.format(local),
        l10n.tidesHeightM(heightM.toStringAsFixed(1)),
        kind,
      );
    }

    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        Text(station.stationName, style: theme.textTheme.titleLarge),
        const SizedBox(height: CwSpacing.xs),
        Text(station.note, style: theme.textTheme.bodySmall),
        const SizedBox(height: CwSpacing.l),
        Text(l10n.tidesCurveHeading, style: theme.textTheme.titleMedium),
        const SizedBox(height: CwSpacing.s),
        TideCurveChart(
          anchorEvents: events,
          dayLocal: chartDay,
          locale: locale,
          highLabel: l10n.tidesHighShort,
          lowLabel: l10n.tidesLowShort,
        ),
        const SizedBox(height: CwSpacing.l),
        Text(l10n.tidesMoonHeading, style: theme.textTheme.titleMedium),
        const SizedBox(height: CwSpacing.s),
        _MoonPhaseRow(days: week.map((d) => d.dateLocal).toList(growable: false)),
        const SizedBox(height: CwSpacing.l),
        Text(l10n.tidesSunHeading, style: theme.textTheme.titleMedium),
        const SizedBox(height: CwSpacing.s),
        Text(
          l10n.tidesSunLine(
            timeFmt.format(solar.sunriseUtc.toLocal()),
            timeFmt.format(solar.sunsetUtc.toLocal()),
          ),
          style: theme.textTheme.bodyMedium,
        ),
        const SizedBox(height: CwSpacing.l),
        Text(l10n.tidesTableHeading, style: theme.textTheme.titleMedium),
        const SizedBox(height: CwSpacing.s),
        TideTable(
          anchorEvents: events,
          locale: locale,
          dayHeader: l10n.tidesTableDay,
          hwHeader: l10n.tidesHighShort,
          lwHeader: l10n.tidesLowShort,
          formatEvent: formatEvent,
        ),
      ],
    );
  }
}

class _MoonPhaseRow extends StatelessWidget {
  const _MoonPhaseRow({required this.days});

  final List<DateTime> days;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        for (final day in days)
          Column(
            children: [
              Icon(
                moonPhaseIcon(moonPhaseIndex(day)),
                color: theme.colorScheme.primary,
              ),
              const SizedBox(height: CwSpacing.xs),
              Text(
                DateFormat.E('en').format(day),
                style: theme.textTheme.labelSmall,
              ),
            ],
          ),
      ],
    );
  }
}
