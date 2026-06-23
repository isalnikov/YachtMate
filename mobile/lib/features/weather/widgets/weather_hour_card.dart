import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../domain/weather/weather_forecast_view.dart';
import '../weather_providers.dart';
import 'wind_legend_bar.dart';

/// Compact or expanded hour card: wind, gust, direction arrow, temperature.
class WeatherHourCard extends StatelessWidget {
  const WeatherHourCard({
    super.key,
    required this.hour,
    required this.selected,
    required this.locale,
    this.compact = false,
    this.onTap,
    this.emphasisLayer = WeatherLayer.wind,
  });

  final HourlyWeatherPoint hour;
  final bool selected;
  final String locale;
  final bool compact;
  final VoidCallback? onTap;
  final WeatherLayer emphasisLayer;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final timeLocal = hour.timeUtc.toLocal();
    final timeLabel = compact
        ? DateFormat.Hm(locale).format(timeLocal)
        : DateFormat('EEE d MMM, HH:mm', locale).format(timeLocal);

    final windKn = hour.windSpeedKn.isNaN
        ? '—'
        : hour.windSpeedKn.toStringAsFixed(0);
    final gustKn = hour.windGustKn == null || hour.windGustKn!.isNaN
        ? '—'
        : hour.windGustKn!.toStringAsFixed(0);
    final tempC = hour.temperatureC.isNaN
        ? '—'
        : hour.temperatureC.toStringAsFixed(0);

    final borderColor = selected ? colors.accentTeal : colors.accentTeal.withValues(alpha: 0.12);
    final bgColor = selected
        ? colors.accentTeal.withValues(alpha: 0.18)
        : colors.panelBlue;

    final content = Padding(
      padding: EdgeInsets.all(compact ? CwSpacing.s : CwSpacing.m),
      child: compact
          ? _compactBody(colors, timeLabel, windKn, gustKn, tempC)
          : _expandedBody(context, colors, timeLabel, windKn, gustKn, tempC),
    );

    final card = Material(
      color: bgColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CwRadius.md),
        side: BorderSide(color: borderColor, width: selected ? 2 : 1),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              splashColor: colors.accentTeal.withValues(alpha: 0.12),
              child: content,
            )
          : content,
    );

    if (compact) {
      return SizedBox(width: 88, child: card);
    }
    return card;
  }

  Widget _compactBody(
    CwColors colors,
    String timeLabel,
    String windKn,
    String gustKn,
    String tempC,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          timeLabel,
          style: TextStyle(
            color: selected ? colors.accentTeal : colors.textMuted,
            fontSize: 11,
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        const SizedBox(height: CwSpacing.xs),
        _WindArrow(
          directionDeg: hour.windDirectionDeg,
          color: windColorForKn(hour.windSpeedKn, colors.windScale),
          size: emphasisLayer == WeatherLayer.wind ? 26 : 22,
          emphasized: emphasisLayer == WeatherLayer.wind,
        ),
        const SizedBox(height: 2),
        Text(
          '$windKn kn',
          style: TextStyle(
            color: emphasisLayer == WeatherLayer.wind
                ? colors.accentTeal
                : colors.textPrimary,
            fontSize: emphasisLayer == WeatherLayer.wind ? 14 : 13,
            fontWeight: emphasisLayer == WeatherLayer.wind
                ? FontWeight.w700
                : FontWeight.w600,
          ),
        ),
        Text(
          'g $gustKn',
          style: TextStyle(
            color: emphasisLayer == WeatherLayer.wind
                ? colors.textPrimary
                : colors.textMuted,
            fontSize: 10,
            fontWeight: emphasisLayer == WeatherLayer.wind
                ? FontWeight.w600
                : FontWeight.normal,
          ),
        ),
        const SizedBox(height: CwSpacing.xs),
        _compactBottomMetric(colors, tempC),
      ],
    );
  }

  Widget _compactBottomMetric(CwColors colors, String tempC) {
    switch (emphasisLayer) {
      case WeatherLayer.temperature:
        return Text(
          '$tempC°',
          style: TextStyle(
            color: colors.accentTeal,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        );
      case WeatherLayer.waves:
        final wave = hour.waveHeightM;
        final waveLabel = wave == null || wave.isNaN
            ? '— m'
            : '${wave.toStringAsFixed(1)} m';
        return Text(
          waveLabel,
          style: TextStyle(
            color: colors.accentTeal,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        );
      case WeatherLayer.pressure:
        final press = hour.pressureHpa.isNaN
            ? '—'
            : hour.pressureHpa.toStringAsFixed(0);
        return Text(
          '$press hPa',
          style: TextStyle(
            color: colors.accentTeal,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        );
      case WeatherLayer.wind:
        return Text(
          '$tempC°',
          style: TextStyle(color: colors.textMuted, fontSize: 12),
        );
    }
  }

  Widget _expandedBody(
    BuildContext context,
    CwColors colors,
    String timeLabel,
    String windKn,
    String gustKn,
    String tempC,
  ) {
    return Row(
      children: [
        _WindArrow(
          directionDeg: hour.windDirectionDeg,
          color: windColorForKn(hour.windSpeedKn, colors.windScale),
          size: emphasisLayer == WeatherLayer.wind ? 48 : 40,
          emphasized: emphasisLayer == WeatherLayer.wind,
        ),
        const SizedBox(width: CwSpacing.m),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                timeLabel,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colors.textPrimary,
                ),
              ),
              const SizedBox(height: CwSpacing.xs),
              ..._expandedMetrics(context, colors, windKn, gustKn),
            ],
          ),
        ),
        _expandedTrailing(colors, tempC),
      ],
    );
  }

  List<Widget> _expandedMetrics(
    BuildContext context,
    CwColors colors,
    String windKn,
    String gustKn,
  ) {
    final body = Theme.of(context).textTheme.bodyLarge;
    final muted = body?.copyWith(color: colors.textMuted, fontWeight: FontWeight.normal);
    final windStyle = emphasisLayer == WeatherLayer.wind
        ? body?.copyWith(color: colors.accentTeal, fontWeight: FontWeight.w700)
        : body?.copyWith(color: colors.textPrimary, fontWeight: FontWeight.w600);
    final wave = hour.waveHeightM;
    final waveLabel = wave == null || wave.isNaN
        ? '— m'
        : '${wave.toStringAsFixed(1)} m';
    final pressLabel = hour.pressureHpa.isNaN
        ? '— hPa'
        : '${hour.pressureHpa.toStringAsFixed(0)} hPa';

    return [
      Text('$windKn kn · gust $gustKn kn', style: windStyle),
      const SizedBox(height: 2),
      Text(
        'Wave $waveLabel · $pressLabel',
        style: emphasisLayer == WeatherLayer.waves
            ? body?.copyWith(color: colors.accentTeal, fontWeight: FontWeight.w700)
            : emphasisLayer == WeatherLayer.pressure
            ? body?.copyWith(color: colors.accentTeal, fontWeight: FontWeight.w700)
            : muted,
      ),
    ];
  }

  Widget _expandedTrailing(CwColors colors, String tempC) {
    final emphasized = emphasisLayer == WeatherLayer.temperature;
    return Text(
      '$tempC°C',
      style: TextStyle(
        color: emphasized ? colors.accentTeal : colors.textPrimary,
        fontSize: emphasized ? 28 : 24,
        fontWeight: emphasized ? FontWeight.w700 : FontWeight.w600,
      ),
    );
  }
}

class _WindArrow extends StatelessWidget {
  const _WindArrow({
    required this.directionDeg,
    required this.color,
    required this.size,
    this.emphasized = false,
  });

  final double directionDeg;
  final Color color;
  final double size;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    if (directionDeg.isNaN) {
      return Icon(Icons.help_outline, size: size, color: color);
    }
    // Meteorological direction = where wind comes from; arrow points downwind.
    final radians = (directionDeg + 180) * math.pi / 180;
    return Transform.rotate(
      angle: radians,
      child: Icon(
        Icons.navigation,
        size: size,
        color: color,
        shadows: emphasized
            ? [Shadow(color: color.withValues(alpha: 0.45), blurRadius: 6)]
            : null,
      ),
    );
  }
}
