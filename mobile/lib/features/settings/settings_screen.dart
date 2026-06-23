import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/accessibility_preferences_controller.dart';
import '../../core/energy_profile_controller.dart';
import '../../core/providers.dart';
import '../../core/theme/cw_theme_mode.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/vessel_prefs.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_button_sizes.dart';
import '../../widgets/cw_chip.dart';
import '../../widgets/cw_segmented_control.dart';
import 'widgets/anchor_watch_alert_settings_form.dart';
import 'widgets/settings_section.dart';
import 'widgets/vessel_profile_form.dart';

/// Settings grouped by vessel, display, accessibility, energy, and about (step-27).
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  static const appVersion = '1.0.0';

  CwThemeMode _activeTheme(
    bool nightRed,
    AccessibilityPreferences accessibility,
  ) {
    return CwThemeMode.resolve(
      nightRedEnabled: nightRed,
      highContrastEnabled: accessibility.highContrast,
    );
  }

  Future<void> _setTheme(WidgetRef ref, CwThemeMode mode) async {
    final acc = ref.read(accessibilityPreferencesProvider.notifier);
    final theme = ref.read(themeModeProvider.notifier);
    switch (mode) {
      case CwThemeMode.deck:
        await theme.setNightRedEnabled(false);
        await acc.setHighContrast(false);
      case CwThemeMode.nightRed:
        await theme.setNightRedEnabled(true);
        await acc.setHighContrast(false);
      case CwThemeMode.highContrast:
        await acc.setHighContrast(true);
        await theme.setNightRedEnabled(false);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final acc = ref.watch(accessibilityPreferencesProvider);
    final profile = ref.watch(energyProfileProvider);
    final vessel = ref.watch(vesselPrefsProvider);
    final nightRed = ref.watch(themeModeProvider);
    final themeMode = _activeTheme(nightRed, acc);

    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        SettingsSection(
          title: l10n.settingsVesselSection,
          child: const VesselProfileForm(),
        ),
        SettingsSection(
          title: l10n.settingsDisplaySection,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.settingsUnits, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: CwSpacing.s),
              CwSegmentedControl<UnitSystem>(
                selected: vessel.units,
                onChanged: (u) => unawaited(
                  ref.read(vesselPrefsProvider.notifier).setUnits(u),
                ),
                options: [
                  CwSegmentedOption(
                    value: UnitSystem.metric,
                    label: l10n.settingsUnitsMetric,
                  ),
                  CwSegmentedOption(
                    value: UnitSystem.imperial,
                    label: l10n.settingsUnitsImperial,
                  ),
                ],
              ),
              const SizedBox(height: CwSpacing.m),
              Text(l10n.settingsTheme, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: CwSpacing.s),
              Wrap(
                spacing: CwSpacing.s,
                runSpacing: CwSpacing.s,
                children: [
                  CwChip(
                    label: l10n.settingsThemeDeck,
                    selected: themeMode == CwThemeMode.deck,
                    onSelected: (_) => unawaited(_setTheme(ref, CwThemeMode.deck)),
                  ),
                  CwChip(
                    label: l10n.settingsThemeNightRed,
                    selected: themeMode == CwThemeMode.nightRed,
                    onSelected: (_) =>
                        unawaited(_setTheme(ref, CwThemeMode.nightRed)),
                  ),
                  CwChip(
                    label: l10n.settingsThemeHighContrast,
                    selected: themeMode == CwThemeMode.highContrast,
                    onSelected: (_) =>
                        unawaited(_setTheme(ref, CwThemeMode.highContrast)),
                  ),
                ],
              ),
            ],
          ),
        ),
        SettingsSection(
          title: l10n.settingsAccessibilitySection,
          child: Column(
            children: [
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.settingsGloveMode),
                subtitle: Text(l10n.settingsGloveModeSubtitle),
                value: acc.gloveMode,
                onChanged: (v) => ref
                    .read(accessibilityPreferencesProvider.notifier)
                    .setGloveMode(v),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
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
            ],
          ),
        ),
        SettingsSection(
          title: l10n.settingsAnchorWatchSection,
          child: const AnchorWatchAlertSettingsForm(),
        ),
        SettingsSection(
          title: l10n.settingsEnergySection,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CwButton(
                label: l10n.energyProfileEco,
                variant: profile == EnergyProfile.eco
                    ? CwButtonVariant.primary
                    : CwButtonVariant.secondary,
                size: CwButtonSize.fromGloveMode(acc.gloveMode),
                semanticLabel: l10n.energyProfileEcoDescription,
                onPressed: () => unawaited(
                  ref
                      .read(energyProfileProvider.notifier)
                      .setProfile(EnergyProfile.eco),
                ),
              ),
              const SizedBox(height: CwSpacing.s),
              CwButton(
                label: l10n.energyProfilePassage,
                variant: profile == EnergyProfile.passage
                    ? CwButtonVariant.primary
                    : CwButtonVariant.secondary,
                size: CwButtonSize.fromGloveMode(acc.gloveMode),
                semanticLabel: l10n.energyProfilePassageDescription,
                onPressed: () => unawaited(
                  ref
                      .read(energyProfileProvider.notifier)
                      .setProfile(EnergyProfile.passage),
                ),
              ),
              const SizedBox(height: CwSpacing.s),
              CwButton(
                label: l10n.energyProfileSport,
                variant: profile == EnergyProfile.sport
                    ? CwButtonVariant.danger
                    : CwButtonVariant.tertiary,
                size: CwButtonSize.fromGloveMode(acc.gloveMode),
                semanticLabel: l10n.energyProfileSportDescription,
                onPressed: () => unawaited(
                  ref
                      .read(energyProfileProvider.notifier)
                      .setProfile(EnergyProfile.sport),
                ),
              ),
            ],
          ),
        ),
        SettingsSection(
          title: l10n.settingsAboutSection,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsAboutAppName,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: CwSpacing.xs),
              Text(
                l10n.settingsAboutVersion(appVersion),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: CwSpacing.s),
              Text(
                l10n.settingsAboutTagline,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
