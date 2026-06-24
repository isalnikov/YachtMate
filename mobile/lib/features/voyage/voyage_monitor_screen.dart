import 'dart:async' show unawaited;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/voyage_monitor_controller.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_card.dart';
import '../../widgets/cw_segmented_control.dart';
import '../distress/sos_screen.dart';

String _formatDuration(Duration d, AppLocalizations l10n) {
  final h = d.inHours;
  final m = d.inMinutes.remainder(60);
  final s = d.inSeconds.remainder(60);
  if (h > 0) return '${h}h ${m}m';
  if (m > 0) return '${m}m ${s}s';
  return '${s}s';
}

/// Shore contact + periodic OK check-in (step 50).
class VoyageMonitorScreen extends ConsumerStatefulWidget {
  const VoyageMonitorScreen({super.key});

  @override
  ConsumerState<VoyageMonitorScreen> createState() =>
      _VoyageMonitorScreenState();
}

class _VoyageMonitorScreenState extends ConsumerState<VoyageMonitorScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController();
    _phoneCtrl = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final s = ref.read(voyageMonitorProvider);
      _nameCtrl.text = s.contactName;
      _phoneCtrl.text = s.contactPhone;
    });
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final monitor = ref.watch(voyageMonitorProvider);
    final notifier = ref.read(voyageMonitorProvider.notifier);
    final theme = Theme.of(context);

    final due = monitor.timeUntilDue();
    final statusText = monitor.active
        ? (monitor.isOverdue
            ? l10n.voyageMonitorOverdue
            : due != null
                ? l10n.voyageMonitorNextDue(_formatDuration(due, l10n))
                : l10n.voyageMonitorActive)
        : l10n.voyageMonitorInactive;

    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        Text(l10n.voyageMonitorLead, style: theme.textTheme.bodyMedium),
        const SizedBox(height: CwSpacing.m),
        CwCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(statusText, style: theme.textTheme.titleSmall),
              if (monitor.active) ...[
                const SizedBox(height: CwSpacing.m),
                CwButton(
                  label: l10n.voyageMonitorOk,
                  onPressed: () => unawaited(notifier.checkInOk()),
                ),
                const SizedBox(height: CwSpacing.s),
                CwButton(
                  label: l10n.voyageMonitorOpenSos,
                  variant: CwButtonVariant.danger,
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => Scaffold(
                          appBar: AppBar(title: Text(l10n.sosTitle)),
                          body: const SosScreen(),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: CwSpacing.m),
        TextField(
          controller: _nameCtrl,
          enabled: !monitor.active,
          decoration: InputDecoration(labelText: l10n.voyageMonitorContactName),
          onSubmitted: (v) => unawaited(notifier.setContactName(v)),
        ),
        const SizedBox(height: CwSpacing.s),
        TextField(
          controller: _phoneCtrl,
          enabled: !monitor.active,
          decoration: InputDecoration(labelText: l10n.voyageMonitorContactPhone),
          keyboardType: TextInputType.phone,
          onSubmitted: (v) => unawaited(notifier.setContactPhone(v)),
        ),
        const SizedBox(height: CwSpacing.m),
        Text(l10n.voyageMonitorInterval, style: theme.textTheme.bodyMedium),
        const SizedBox(height: CwSpacing.s),
        CwSegmentedControl<int>(
          selected: monitor.intervalMinutes,
          onChanged: monitor.active
              ? (_) {}
              : (v) => unawaited(notifier.setIntervalMinutes(v)),
          options: [
            CwSegmentedOption(
              value: 30,
              label: l10n.voyageMonitorInterval30,
            ),
            CwSegmentedOption(
              value: 60,
              label: l10n.voyageMonitorInterval60,
            ),
            CwSegmentedOption(
              value: 120,
              label: l10n.voyageMonitorInterval120,
            ),
          ],
        ),
        const SizedBox(height: CwSpacing.l),
        if (monitor.active)
          CwButton(
            label: l10n.voyageMonitorStop,
            variant: CwButtonVariant.secondary,
            onPressed: () => unawaited(notifier.stop()),
          )
        else
          CwButton(
            label: l10n.voyageMonitorStart,
            onPressed: () async {
              await notifier.setContactName(_nameCtrl.text);
              await notifier.setContactPhone(_phoneCtrl.text);
              await notifier.start();
            },
          ),
      ],
    );
  }
}
