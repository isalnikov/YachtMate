import 'dart:async' show unawaited;

import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../../widgets/cw_bottom_sheet.dart';
import '../../widgets/cw_button.dart';
import '../../core/feature_flags.dart';
import '../../core/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Shows premium upgrade placeholder (step 52).
Future<void> showPaywallPlaceholderSheet(
  BuildContext context,
  PremiumFeature feature,
) async {
  final l10n = AppLocalizations.of(context)!;
  await showCwBottomSheet<void>(
    context: context,
    title: l10n.paywallTitle,
    child: _PaywallBody(feature: feature),
  );
}

class _PaywallBody extends ConsumerWidget {
  const _PaywallBody({required this.feature});

  final PremiumFeature feature;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.paywallBody),
        const SizedBox(height: 16),
        CwButton(
          label: l10n.paywallCta,
          onPressed: () async {
            await ref.read(auditRepositoryProvider).record(
                  sessionId: ref.read(sessionIdProvider),
                  module: 'core',
                  action: 'paywall_cta',
                  contextJson:
                      '{"feature":"${ref.read(featureFlagsProvider).featureLabelKey(feature)}"}',
                );
            if (context.mounted) Navigator.of(context).pop();
          },
        ),
        const SizedBox(height: 8),
        CwButton(
          label: l10n.paywallDismiss,
          variant: CwButtonVariant.tertiary,
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }
}

/// Returns true when feature is allowed; otherwise shows paywall and returns false.
Future<bool> requirePremiumFeature(
  BuildContext context,
  WidgetRef ref,
  PremiumFeature feature,
) async {
  if (ref.read(featureFlagsProvider).canUse(feature)) return true;
  await showPaywallPlaceholderSheet(context, feature);
  return false;
}
