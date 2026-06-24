import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/map_layer_preferences_controller.dart';
import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';

/// Toggles map wind overlay from the weather tab (step 47 / 65).
class WeatherMapWindOverlayToggle extends ConsumerWidget {
  const WeatherMapWindOverlayToggle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final vis = ref.watch(mapLayerPreferencesProvider);

    return SwitchListTile(
      key: const Key('weather_map_wind_overlay'),
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.mapLayerWindOverlay),
      subtitle: Text(l10n.mapLayerWindOverlaySubtitle),
      value: vis.windOverlay,
      onChanged: (on) => ref
          .read(mapLayerPreferencesProvider.notifier)
          .setWindOverlay(on),
    );
  }
}
