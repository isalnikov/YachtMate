import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import 'widgets/anchor_radius_slider.dart';
import 'widgets/anchor_status_panel.dart';
import 'widgets/anchor_zone_map.dart';

/// Якорная вахта: круг на карте, радиус, arm/disarm (F06 / step 19).
class AnchorWatchScreen extends ConsumerWidget {
  const AnchorWatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(anchorWatchProvider);
    final c = ref.read(anchorWatchProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(CwSpacing.m),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (s.alarmLatched)
            MaterialBanner(
              content: Text(l10n.anchorWatchAlarmBanner),
              actions: [
                TextButton(
                  onPressed: c.acknowledgeAlarm,
                  child: Text(l10n.anchorWatchDismissAlarm),
                ),
              ],
            ),
          if (s.gpsLost) _GpsLostBanner(message: l10n.anchorWatchGpsLost),
          const SizedBox(height: CwSpacing.s),
          AnchorZoneMap(state: s),
          const SizedBox(height: CwSpacing.m),
          AnchorStatusPanel(state: s),
          const SizedBox(height: CwSpacing.m),
          AnchorRadiusSlider(
            radiusM: s.radiusM,
            enabled: s.hasAnchor,
            onChanged: c.setRadiusMeters,
          ),
          const SizedBox(height: CwSpacing.m),
          CwButton(
            label: l10n.anchorWatchDrop,
            icon: Icons.place_outlined,
            variant: CwButtonVariant.secondary,
            onPressed: s.hasAnchor ? null : c.dropAnchor,
          ),
          const SizedBox(height: CwSpacing.s),
          if (s.armed)
            CwButton(
              label: l10n.anchorWatchDisarm,
              icon: Icons.shield_outlined,
              variant: CwButtonVariant.danger,
              onPressed: c.disarm,
            )
          else
            CwButton(
              label: l10n.anchorWatchArm,
              icon: Icons.shield,
              variant: CwButtonVariant.primary,
              onPressed: s.hasAnchor ? c.arm : null,
            ),
          const SizedBox(height: CwSpacing.s),
          CwButton(
            label: l10n.anchorWatchClear,
            variant: CwButtonVariant.tertiary,
            onPressed: s.hasAnchor ? c.clearAnchor : null,
          ),
          const SizedBox(height: CwSpacing.l),
        ],
      ),
    );
  }
}

class _GpsLostBanner extends StatelessWidget {
  const _GpsLostBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: CwSpacing.s),
      child: Material(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(CwRadius.sm),
        child: Padding(
          padding: const EdgeInsets.all(CwSpacing.s + 4),
          child: Row(
            children: [
              Icon(
                Icons.satellite_alt_outlined,
                color: Theme.of(context).colorScheme.onErrorContainer,
              ),
              const SizedBox(width: CwSpacing.s),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
