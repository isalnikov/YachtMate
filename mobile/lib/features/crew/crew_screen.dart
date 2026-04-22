import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/crew/crew_controller.dart';
import '../../core/providers.dart';
import '../../l10n/app_localizations.dart';

/// Инвайт-код и роль (локально, Фаза 7.6).
class CrewScreen extends ConsumerStatefulWidget {
  const CrewScreen({super.key});

  @override
  ConsumerState<CrewScreen> createState() => _CrewScreenState();
}

class _CrewScreenState extends ConsumerState<CrewScreen> {
  final _joinCtrl = TextEditingController();

  @override
  void dispose() {
    _joinCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final crew = ref.watch(crewControllerProvider);

    Future<void> audit(String action, String ctx) async {
      await ref
          .read(auditRepositoryProvider)
          .record(
            sessionId: ref.read(sessionIdProvider),
            module: 'M10',
            action: action,
            contextJson: ctx,
          );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          crew.role == CrewRole.captain
              ? l10n.crewRoleCaptain
              : l10n.crewRoleCrew,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if ((crew.inviteCode ?? '').isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(l10n.crewInviteExplain),
          const SizedBox(height: 8),
          SelectableText(
            crew.inviteCode!,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          IconButton(
            icon: const Icon(Icons.copy),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: crew.inviteCode!));
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(l10n.sosMessageCopied)));
            },
          ),
        ],
        const Divider(),
        FilledButton(
          onPressed: () async {
            await ref
                .read(crewControllerProvider.notifier)
                .createShipAndInvite();
            await audit('crew_ship_create', '{"role":"captain"}');
            if (mounted) setState(() {});
          },
          child: Text(l10n.crewCreateShip),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _joinCtrl,
          decoration: InputDecoration(labelText: l10n.crewJoinShip),
          textCapitalization: TextCapitalization.characters,
        ),
        const SizedBox(height: 8),
        FilledButton.tonal(
          onPressed: () async {
            await ref
                .read(crewControllerProvider.notifier)
                .joinShip(_joinCtrl.text);
            await audit('crew_ship_join', '{"role":"crew"}');
            if (mounted) setState(() {});
          },
          child: Text(l10n.crewJoinShip),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () async {
            await ref.read(crewControllerProvider.notifier).leaveShip();
            await audit('crew_ship_leave', '{}');
            if (mounted) setState(() {});
          },
          child: Text(l10n.crewLeave),
        ),
      ],
    );
  }
}
