import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers.dart';
import '../../../l10n/app_localizations.dart';

/// Demo premium unlock toggle (step 52).
class PremiumSettingsForm extends ConsumerWidget {
  const PremiumSettingsForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final flags = ref.watch(featureFlagsProvider);
    final notifier = ref.read(featureFlagsProvider.notifier);

    return SwitchListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(l10n.settingsPremiumUnlocked),
      subtitle: Text(l10n.settingsPremiumUnlockedSubtitle),
      value: flags.premiumUnlocked,
      onChanged: (v) => unawaited(notifier.setPremiumUnlocked(v)),
    );
  }
}
