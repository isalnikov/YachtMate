import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../domain/tides/tide_demo_models.dart';
import '../../domain/weather/weather_forecast_view.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/language_button.dart';
import 'weather_providers.dart';

/// Прогноз Open-Meteo + демо-приливы (Фаза 4).
class WeatherScreen extends ConsumerWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final fc = ref.watch(weatherForecastProvider);
    final tide = ref.watch(tideDemoProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.weatherScreenTitle),
        actions: [
          IconButton(
            tooltip: l10n.weatherGpsTooltip,
            onPressed: () => _useGps(context, ref),
            icon: const Icon(Icons.my_location_outlined),
          ),
          IconButton(
            tooltip: l10n.weatherRefreshTooltip,
            onPressed: () => _refresh(context, ref),
            icon: const Icon(Icons.refresh_outlined),
          ),
          const LanguageButton(),
        ],
      ),
      body: fc.when(
        data: (bundle) => _ForecastBody(
          bundle: bundle,
          tideAsync: tide,
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              l10n.weatherLoadError('$e'),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _refresh(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    await ref.read(auditRepositoryProvider).record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M4',
          action: 'weather_refresh',
          contextJson: '{"lat":${ref.read(weatherPinProvider).lat},'
              '"lon":${ref.read(weatherPinProvider).lon}}',
        );
    ref.invalidate(weatherForecastProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.weatherRefreshing)),
      );
    }
  }

  Future<void> _useGps(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) {
        p = await Geolocator.requestPermission();
      }
      if (p != LocationPermission.always && p != LocationPermission.whileInUse) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.weatherGpsDenied)),
          );
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      ref.read(weatherPinProvider.notifier).setPin(pos.latitude, pos.longitude);
      ref.invalidate(weatherForecastProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.weatherGpsUpdated)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.weatherGpsError('$e'))),
        );
      }
    }
  }
}

class _ForecastBody extends ConsumerWidget {
  const _ForecastBody({
    required this.bundle,
    required this.tideAsync,
  });

  final WeatherForecastBundle bundle;
  final AsyncValue<TideDemoStation> tideAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final pin = ref.watch(weatherPinProvider);
    final loc = Localizations.localeOf(context).toLanguageTag();
    final timeFmt = DateFormat.Hm(loc);
    final updated =
        DateFormat('yyyy-MM-dd HH:mm', loc).format(bundle.fetchedAtUtc.toLocal());

    final hours = bundle.hourly.take(48).toList(growable: false);

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(auditRepositoryProvider).record(
              sessionId: ref.read(sessionIdProvider),
              module: 'M4',
              action: 'weather_refresh',
              contextJson:
                  '{"lat":${pin.lat},"lon":${pin.lon},"pull":true}',
            );
        ref.invalidate(weatherForecastProvider);
        await ref.read(weatherForecastProvider.future);
      },
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (bundle.isStale)
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: ListTile(
                leading: const Icon(Icons.cloud_off_outlined),
                title: Text(l10n.weatherStaleBanner),
              ),
            ),
          Text(
            l10n.weatherCoordinates(
              pin.lat.toStringAsFixed(4),
              pin.lon.toStringAsFixed(4),
            ),
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            l10n.weatherLastUpdated(updated),
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.weatherHourlyHeading,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          for (final h in hours)
            Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                title: Text(
                  DateFormat('yyyy-MM-dd HH:mm', loc)
                      .format(h.timeUtc.toLocal()),
                ),
                subtitle: Text(
                  l10n.weatherHourLine(
                    h.temperatureC.toStringAsFixed(1),
                    h.windSpeedKn.isNaN
                        ? '—'
                        : h.windSpeedKn.toStringAsFixed(0),
                    h.windDirectionDeg.isNaN
                        ? '—'
                        : h.windDirectionDeg.toStringAsFixed(0),
                    h.precipitationMm.toStringAsFixed(1),
                    h.pressureHpa.toStringAsFixed(0),
                    (h.waveHeightM != null && !h.waveHeightM!.isNaN)
                        ? l10n.weatherWaveSuffix(
                            h.waveHeightM!.toStringAsFixed(1),
                          )
                        : '',
                  ),
                ),
              ),
            ),
          const SizedBox(height: 24),
          Text(
            l10n.weatherTidesSection,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          tideAsync.when(
            data: (s) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.stationName,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  s.note,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                for (final e in s.events)
                  ListTile(
                    dense: true,
                    leading: Icon(
                      e.isHigh ? Icons.arrow_upward : Icons.arrow_downward,
                    ),
                    title: Text(
                      l10n.weatherTideRow(
                        timeFmt.format(e.timeUtc.toLocal()),
                        '${e.heightM.toStringAsFixed(1)} m',
                        e.isHigh ? l10n.tidesHigh : l10n.tidesLow,
                      ),
                    ),
                  ),
              ],
            ),
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
        ],
      ),
    );
  }
}
