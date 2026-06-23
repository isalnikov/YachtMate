import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/anchor_watch_alert_settings_controller.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';

/// SMS-on-drift preferences for anchor watch (step 45).
class AnchorWatchAlertSettingsForm extends ConsumerStatefulWidget {
  const AnchorWatchAlertSettingsForm({super.key});

  @override
  ConsumerState<AnchorWatchAlertSettingsForm> createState() =>
      _AnchorWatchAlertSettingsFormState();
}

class _AnchorWatchAlertSettingsFormState
    extends ConsumerState<AnchorWatchAlertSettingsForm> {
  late final TextEditingController _smsCtrl;

  @override
  void initState() {
    super.initState();
    _smsCtrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final n = ref.read(anchorWatchAlertSettingsProvider).smsNumber;
      if (_smsCtrl.text != n) _smsCtrl.text = n;
    });
  }

  @override
  void dispose() {
    _smsCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final alert = ref.watch(anchorWatchAlertSettingsProvider);
    final notifier = ref.read(anchorWatchAlertSettingsProvider.notifier);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.settingsAnchorWatchSmsOnDrift),
          subtitle: Text(l10n.settingsAnchorWatchSmsOnDriftSubtitle),
          value: alert.smsOnDrift,
          onChanged: (v) => unawaited(notifier.setSmsOnDrift(v)),
        ),
        if (alert.smsOnDrift) ...[
          const SizedBox(height: CwSpacing.s),
          TextField(
            controller: _smsCtrl,
            decoration: InputDecoration(
              labelText: l10n.settingsAnchorWatchSmsNumber,
              hintText: l10n.settingsAnchorWatchSmsNumberHint,
            ),
            keyboardType: TextInputType.phone,
            onSubmitted: (v) => unawaited(notifier.setSmsNumber(v)),
            onEditingComplete: () =>
                unawaited(notifier.setSmsNumber(_smsCtrl.text)),
          ),
          const SizedBox(height: CwSpacing.xs),
          Text(
            l10n.settingsAnchorWatchSmsTestModeNote,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ],
    );
  }
}
