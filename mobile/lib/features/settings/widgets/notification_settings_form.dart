import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/notifications/notification_preferences_controller.dart';
import '../../../core/providers.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// Local notification toggles (step 51).
class NotificationSettingsForm extends ConsumerWidget {
  const NotificationSettingsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final prefs = ref.watch(notificationPreferencesProvider);
    final notifier = ref.read(notificationPreferencesProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsNotifyAnchorDrift),
          subtitle: Text(l10n.settingsNotifyAnchorDriftSubtitle),
          value: prefs.anchorDriftEnabled,
          onChanged: (v) => unawaited(notifier.setAnchorDriftEnabled(v)),
        ),
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsNotifyWeatherWind),
          subtitle: Text(l10n.settingsNotifyWeatherWindSubtitle),
          value: prefs.weatherWindEnabled,
          onChanged: (v) => unawaited(notifier.setWeatherWindEnabled(v)),
        ),
        if (prefs.weatherWindEnabled) ...[
          const SizedBox(height: CwSpacing.s),
          Text(l10n.settingsNotifyWindThreshold),
          Slider(
            value: prefs.windThresholdKn.clamp(10, 45),
            min: 10,
            max: 45,
            divisions: 35,
            label: prefs.windThresholdKn.toStringAsFixed(0),
            onChanged: (v) => unawaited(notifier.setWindThresholdKn(v)),
          ),
        ],
      ],
    );
  }
}
