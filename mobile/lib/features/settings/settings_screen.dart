import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/accessibility_preferences_controller.dart';
import '../../core/energy_profile_controller.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

/// Доступность и профиль энергии (Фаза 8).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final acc = ref.watch(accessibilityPreferencesProvider);
    final profile = ref.watch(energyProfileProvider);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.settingsAccessibilitySection,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SwitchListTile(
          title: Text(l10n.settingsGloveMode),
          subtitle: Text(l10n.settingsGloveModeSubtitle),
          value: acc.gloveMode,
          onChanged: (v) => ref
              .read(accessibilityPreferencesProvider.notifier)
              .setGloveMode(v),
        ),
        SwitchListTile(
          title: Text(l10n.settingsHighContrast),
          value: acc.highContrast,
          onChanged: (v) => ref
              .read(accessibilityPreferencesProvider.notifier)
              .setHighContrast(v),
        ),
        ListTile(
          title: Text(l10n.settingsTextSize),
          subtitle: Padding(
            padding: const EdgeInsets.only(top: 12),
            child: SegmentedButton<TextSizeBucket>(
              segments: [
                ButtonSegment(
                  value: TextSizeBucket.standard,
                  label: Text(l10n.settingsTextSizeStandard),
                ),
                ButtonSegment(
                  value: TextSizeBucket.large,
                  label: Text(l10n.settingsTextSizeLarge),
                ),
                ButtonSegment(
                  value: TextSizeBucket.extraLarge,
                  label: Text(l10n.settingsTextSizeExtraLarge),
                ),
              ],
              selected: {acc.textSize},
              onSelectionChanged: (set) {
                final b = set.single;
                unawaited(
                  ref
                      .read(accessibilityPreferencesProvider.notifier)
                      .setTextSize(b),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          l10n.settingsEnergySection,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        ListTile(
          title: Text(l10n.energyProfileEco),
          subtitle: Text(l10n.energyProfileEcoDescription),
          trailing: profile == EnergyProfile.eco
              ? const Icon(Icons.check)
              : null,
          onTap: () => unawaited(
            ref
                .read(energyProfileProvider.notifier)
                .setProfile(EnergyProfile.eco),
          ),
        ),
        ListTile(
          title: Text(l10n.energyProfilePassage),
          subtitle: Text(l10n.energyProfilePassageDescription),
          trailing: profile == EnergyProfile.passage
              ? const Icon(Icons.check)
              : null,
          onTap: () => unawaited(
            ref
                .read(energyProfileProvider.notifier)
                .setProfile(EnergyProfile.passage),
          ),
        ),
        ListTile(
          title: Text(l10n.energyProfileSport),
          subtitle: Text(l10n.energyProfileSportDescription),
          trailing: profile == EnergyProfile.sport
              ? const Icon(Icons.check)
              : null,
          onTap: () => unawaited(
            ref
                .read(energyProfileProvider.notifier)
                .setProfile(EnergyProfile.sport),
          ),
        ),
      ],
    );
  }
}
