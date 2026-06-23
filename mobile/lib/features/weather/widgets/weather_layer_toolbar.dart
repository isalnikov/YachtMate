import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../weather_providers.dart';

/// Vertical 44dp layer switcher (wind / waves / temp / pressure).
class WeatherLayerToolbar extends ConsumerWidget {
  const WeatherLayerToolbar({super.key});

  static const buttonSize = 44.0;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final selected = ref.watch(weatherLayerProvider);
    final colors = context.cwColors;

    final layers = <(WeatherLayer, IconData, String)>[
      (WeatherLayer.wind, Icons.air, l10n.weatherLayerWindTooltip),
      (WeatherLayer.waves, Icons.waves, l10n.weatherLayerWavesTooltip),
      (WeatherLayer.temperature, Icons.thermostat_outlined, l10n.weatherLayerTempTooltip),
      (WeatherLayer.pressure, Icons.speed_outlined, l10n.weatherLayerPressureTooltip),
    ];

    return Material(
      color: colors.panelBlue,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(CwRadius.md),
        side: BorderSide(color: colors.accentTeal.withValues(alpha: 0.15)),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < layers.length; i++) ...[
            if (i > 0)
              Divider(
                height: 1,
                thickness: 1,
                color: colors.accentTeal.withValues(alpha: 0.12),
              ),
            _LayerButton(
              selected: selected == layers[i].$1,
              icon: layers[i].$2,
              tooltip: layers[i].$3,
              onTap: () => ref.read(weatherLayerProvider.notifier).state = layers[i].$1,
            ),
          ],
        ],
      ),
    );
  }
}

class _LayerButton extends StatelessWidget {
  const _LayerButton({
    required this.selected,
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final bool selected;
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Semantics(
      button: true,
      selected: selected,
      label: tooltip,
      child: SizedBox(
        width: WeatherLayerToolbar.buttonSize,
        height: WeatherLayerToolbar.buttonSize,
        child: Material(
          color: selected
              ? colors.accentTeal.withValues(alpha: 0.22)
              : Colors.transparent,
          child: InkWell(
            onTap: onTap,
            splashColor: colors.accentTeal.withValues(alpha: 0.12),
            child: Icon(
              icon,
              size: 22,
              color: selected ? colors.accentTeal : colors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}
