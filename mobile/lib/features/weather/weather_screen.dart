import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../domain/tides/tide_station_bundle.dart';
import '../../domain/weather/weather_forecast_view.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_split_view.dart';
import '../../widgets/language_button.dart';
import '../tides/tides_screen.dart';
import 'weather_providers.dart';
import 'widgets/weather_hour_card.dart';
import 'widgets/weather_layer_toolbar.dart';
import 'widgets/weather_timeline_bar.dart';
import 'widgets/wind_legend_bar.dart';
import 'widgets/wind_rose.dart';

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
        data: (bundle) => _ForecastBody(bundle: bundle, tideAsync: tide),
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
    await ref
        .read(auditRepositoryProvider)
        .record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M4',
          action: 'weather_refresh',
          contextJson:
              '{"lat":${ref.read(weatherPinProvider).lat},'
              '"lon":${ref.read(weatherPinProvider).lon}}',
        );
    ref.invalidate(weatherForecastProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.weatherRefreshing)));
    }
  }

  Future<void> _useGps(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      var p = await Geolocator.checkPermission();
      if (p == LocationPermission.denied) {
        p = await Geolocator.requestPermission();
      }
      if (p != LocationPermission.always &&
          p != LocationPermission.whileInUse) {
        if (context.mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(l10n.weatherGpsDenied)));
        }
        return;
      }
      final pos = await Geolocator.getCurrentPosition();
      ref.read(weatherPinProvider.notifier).setPin(pos.latitude, pos.longitude);
      ref.invalidate(weatherForecastProvider);
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.weatherGpsUpdated)));
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.weatherGpsError('$e'))));
      }
    }
  }
}

class _ForecastBody extends ConsumerStatefulWidget {
  const _ForecastBody({required this.bundle, required this.tideAsync});

  final WeatherForecastBundle bundle;
  final AsyncValue<TideStationBundle> tideAsync;

  @override
  ConsumerState<_ForecastBody> createState() => _ForecastBodyState();
}

class _ForecastBodyState extends ConsumerState<_ForecastBody> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _clampSelection());
  }

  @override
  void didUpdateWidget(covariant _ForecastBody oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.bundle != widget.bundle) {
      _clampSelection();
    }
  }

  void _clampSelection() {
    final hours = widget.bundle.hourly.take(48).length;
    if (hours == 0) return;
    final current = ref.read(selectedHourIndexProvider);
    if (current >= hours) {
      ref.read(selectedHourIndexProvider.notifier).state = 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pin = ref.watch(weatherPinProvider);
    final loc = Localizations.localeOf(context).toLanguageTag();
    final timeFmt = DateFormat.Hm(loc);
    final updated = DateFormat(
      'yyyy-MM-dd HH:mm',
      loc,
    ).format(widget.bundle.fetchedAtUtc.toLocal());

    final hours = widget.bundle.hourly.take(48).toList(growable: false);
    if (hours.isEmpty) {
      return Center(child: Text(l10n.weatherLoadError('no hourly data')));
    }

    final selectedIndex = ref.watch(selectedHourIndexProvider).clamp(
      0,
      hours.length - 1,
    );
    final selectedHour = hours[selectedIndex];
    final layer = ref.watch(weatherLayerProvider);

    Future<void> onRefresh() async {
      await ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: ref.read(sessionIdProvider),
            module: 'M4',
            action: 'weather_refresh',
            contextJson: '{"lat":${pin.lat},"lon":${pin.lon},"pull":true}',
          );
      ref.invalidate(weatherForecastProvider);
      await ref.read(weatherForecastProvider.future);
    }

    final staleBanner = widget.bundle.isStale
        ? Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: ListTile(
              leading: const Icon(Icons.cloud_off_outlined),
              title: Text(l10n.weatherStaleBanner),
            ),
          )
        : null;

    final timelinePane = [
      if (staleBanner != null) staleBanner,
      Text(
        l10n.weatherCoordinates(
          pin.lat.toStringAsFixed(4),
          pin.lon.toStringAsFixed(4),
        ),
        style: Theme.of(context).textTheme.titleMedium,
      ),
      const SizedBox(height: CwSpacing.xs),
      Text(
        l10n.weatherLastUpdated(updated),
        style: Theme.of(context).textTheme.bodySmall,
      ),
      const SizedBox(height: CwSpacing.m),
      Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          WindRoseWidget(hour: selectedHour),
          const Spacer(),
          const WeatherLayerToolbar(),
        ],
      ),
      const SizedBox(height: CwSpacing.m),
      const WindLegendBar(),
      const SizedBox(height: CwSpacing.m),
      WeatherTimelineBar(hours: hours, locale: loc),
      const SizedBox(height: CwSpacing.m),
      Text(
        l10n.weatherHourlyHeading,
        style: Theme.of(context).textTheme.titleLarge,
      ),
      const SizedBox(height: CwSpacing.s),
      SizedBox(
        height: 132,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: hours.length,
          separatorBuilder: (_, __) => const SizedBox(width: CwSpacing.s),
          itemBuilder: (context, index) {
            return WeatherHourCard(
              hour: hours[index],
              selected: index == selectedIndex,
              locale: loc,
              compact: true,
              emphasisLayer: layer,
              onTap: () =>
                  ref.read(selectedHourIndexProvider.notifier).state = index,
            );
          },
        ),
      ),
    ];

    final detailPane = [
      WeatherHourCard(
        hour: selectedHour,
        selected: true,
        locale: loc,
        emphasisLayer: layer,
      ),
      const SizedBox(height: CwSpacing.s),
      Text(
        l10n.weatherHourLine(
          selectedHour.temperatureC.toStringAsFixed(1),
          selectedHour.windSpeedKn.isNaN
              ? '—'
              : selectedHour.windSpeedKn.toStringAsFixed(0),
          selectedHour.windDirectionDeg.isNaN
              ? '—'
              : selectedHour.windDirectionDeg.toStringAsFixed(0),
          selectedHour.precipitationMm.toStringAsFixed(1),
          selectedHour.pressureHpa.toStringAsFixed(0),
          (selectedHour.waveHeightM != null && !selectedHour.waveHeightM!.isNaN)
              ? l10n.weatherWaveSuffix(
                  selectedHour.waveHeightM!.toStringAsFixed(1),
                )
              : '',
        ),
        style: Theme.of(context).textTheme.bodyMedium,
      ),
      const SizedBox(height: CwSpacing.l),
      Row(
        children: [
          Expanded(
            child: Text(
              l10n.weatherTidesSection,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const TidesScreen()),
              );
            },
            child: Text(l10n.weatherSeeAllTides),
          ),
        ],
      ),
      const SizedBox(height: CwSpacing.s),
      widget.tideAsync.when(
        data: (bundle) {
          final s = bundle.station;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (bundle.isStale)
                Padding(
                  padding: const EdgeInsets.only(bottom: CwSpacing.s),
                  child: Text(
                    l10n.tidesStaleBanner,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              Text(
                s.stationName,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: CwSpacing.xs),
              Text(s.note, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: CwSpacing.m - CwSpacing.xs),
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
          );
        },
        loading: () => const LinearProgressIndicator(),
        error: (e, _) => Text('$e'),
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final split = CwSplitView.isSplitWidth(constraints.maxWidth);

        if (split) {
          return RefreshIndicator(
            onRefresh: onRefresh,
            child: CwSplitView(
              master: ListView(
                padding: const EdgeInsets.all(CwSpacing.m),
                children: timelinePane,
              ),
              detail: ListView(
                padding: const EdgeInsets.all(CwSpacing.m),
                children: detailPane,
              ),
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: onRefresh,
          child: ListView(
            padding: const EdgeInsets.all(CwSpacing.m),
            children: [
              ...timelinePane,
              const SizedBox(height: CwSpacing.m),
              ...detailPane,
            ],
          ),
        );
      },
    );
  }
}
