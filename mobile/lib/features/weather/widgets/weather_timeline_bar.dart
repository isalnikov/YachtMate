import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../domain/weather/weather_forecast_view.dart';
import '../weather_providers.dart';
import 'wind_legend_bar.dart';

/// 48-hour horizontal scrubber; selected hour highlighted in teal.
class WeatherTimelineBar extends ConsumerWidget {
  const WeatherTimelineBar({
    super.key,
    required this.hours,
    required this.locale,
  });

  final List<HourlyWeatherPoint> hours;
  final String locale;

  static const double _cellWidth = 44;
  static const double _barHeight = 28;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.cwColors;
    final selected = ref.watch(selectedHourIndexProvider);

    return SizedBox(
      height: 72,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: hours.length,
        itemBuilder: (context, index) {
          final hour = hours[index];
          final isSelected = index == selected;
          final local = hour.timeUtc.toLocal();
          final showDay = index == 0 ||
              local.day != hours[index - 1].timeUtc.toLocal().day;
          final dayLabel = DateFormat('EEE d', locale).format(local);
          final hourLabel = DateFormat.H(locale).format(local);
          final windColor = windColorForKn(hour.windSpeedKn, colors.windScale);

          return Semantics(
            button: true,
            selected: isSelected,
            label: '$dayLabel $hourLabel',
            child: InkWell(
              onTap: () =>
                  ref.read(selectedHourIndexProvider.notifier).state = index,
              child: SizedBox(
                width: _cellWidth,
                child: Column(
                  children: [
                    SizedBox(
                      height: 14,
                      child: showDay
                          ? Text(
                              dayLabel,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 9,
                                color: isSelected
                                    ? colors.accentTeal
                                    : colors.textMuted,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      hourLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: isSelected
                            ? colors.accentTeal
                            : colors.textPrimary,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: CwSpacing.xs),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: _cellWidth - 8,
                      height: _barHeight,
                      decoration: BoxDecoration(
                        color: windColor,
                        borderRadius: BorderRadius.circular(CwRadius.sm),
                        border: isSelected
                            ? Border.all(color: colors.accentTeal, width: 2)
                            : null,
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: colors.accentTeal.withValues(alpha: 0.45),
                                  blurRadius: 6,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
