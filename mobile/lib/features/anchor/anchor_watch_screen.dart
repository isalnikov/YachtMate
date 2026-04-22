import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

/// Якорная вахта: круг фиксированного радиуса (F06 MVP).
class AnchorWatchScreen extends ConsumerWidget {
  const AnchorWatchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final s = ref.watch(anchorWatchProvider);
    final c = ref.read(anchorWatchProvider.notifier);

    final dist = s.lastDistanceM;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
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
          if (s.gpsLost)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Material(
                color: Theme.of(context).colorScheme.errorContainer,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.satellite_alt_outlined,
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          l10n.anchorWatchGpsLost,
                          style: TextStyle(
                            color:
                                Theme.of(context).colorScheme.onErrorContainer,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Text(l10n.anchorWatchHint, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 16),
          Text(
            '${l10n.anchorWatchRadius}: ${s.radiusM.toStringAsFixed(0)} m',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Slider(
            min: 15,
            max: 200,
            divisions: 37,
            label: '${s.radiusM.toStringAsFixed(0)} m',
            value: s.radiusM.clamp(15, 200),
            onChanged: (v) => c.setRadiusMeters(v),
          ),
          const SizedBox(height: 8),
          if (dist != null)
            Text(
              '${l10n.anchorWatchDistance}: ${dist.toStringAsFixed(1)} m',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          const Spacer(),
          FilledButton.icon(
            onPressed: s.hasAnchor ? null : c.dropAnchor,
            icon: const Icon(Icons.place_outlined),
            label: Text(l10n.anchorWatchDrop),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed:
                      (!s.hasAnchor || s.armed) ? null : () => c.arm(),
                  child: Text(l10n.anchorWatchArm),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton(
                  onPressed: !s.armed ? null : () => c.disarm(),
                  child: Text(l10n.anchorWatchDisarm),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => c.clearAnchor(),
            child: Text(l10n.anchorWatchClear),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
