import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/crew/crew_controller.dart';
import '../../core/providers.dart';
import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/cw_button.dart';
import '../../widgets/cw_card.dart';
import '../../widgets/cw_text_field.dart';
import 'widgets/crew_role_card.dart';

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

  Future<void> _audit(String action, String ctx) async {
    await ref.read(auditRepositoryProvider).record(
          sessionId: ref.read(sessionIdProvider),
          module: 'M10',
          action: action,
          contextJson: ctx,
        );
  }

  Future<void> _copyInviteCode(String code, AppLocalizations l10n) async {
    await Clipboard.setData(ClipboardData(text: code));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.sosMessageCopied)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final crew = ref.watch(crewControllerProvider);
    final inviteCode = crew.inviteCode ?? '';

    return ListView(
      padding: const EdgeInsets.all(CwSpacing.m),
      children: [
        CrewRoleCard(role: crew.role),
        if (inviteCode.isNotEmpty) ...[
          const SizedBox(height: CwSpacing.m),
          CwCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.crewInviteExplain,
                  style: CwTypography.caption(color: colors.textMuted),
                ),
                const SizedBox(height: CwSpacing.m),
                SelectableText(
                  inviteCode,
                  style: CwTypography.monoCoords(
                    color: colors.accentTeal,
                  ).copyWith(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: CwSpacing.m),
                CwButton(
                  label: l10n.sosCopyMessage,
                  variant: CwButtonVariant.secondary,
                  icon: Icons.copy_outlined,
                  onPressed: () => _copyInviteCode(inviteCode, l10n),
                ),
              ],
            ),
          ),
        ],
        const SizedBox(height: CwSpacing.m),
        CwCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CwButton(
                label: l10n.crewCreateShip,
                icon: Icons.add_circle_outline,
                onPressed: () async {
                  await ref
                      .read(crewControllerProvider.notifier)
                      .createShipAndInvite();
                  await _audit('crew_ship_create', '{"role":"captain"}');
                },
              ),
              const SizedBox(height: CwSpacing.m),
              CwTextField(
                controller: _joinCtrl,
                label: l10n.crewJoinShip,
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: CwSpacing.s),
              CwButton(
                label: l10n.crewJoinShip,
                variant: CwButtonVariant.secondary,
                icon: Icons.login_outlined,
                onPressed: () async {
                  await ref
                      .read(crewControllerProvider.notifier)
                      .joinShip(_joinCtrl.text);
                  await _audit('crew_ship_join', '{"role":"crew"}');
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: CwSpacing.m),
        CwButton(
          label: l10n.crewLeave,
          variant: CwButtonVariant.tertiary,
          icon: Icons.logout_outlined,
          onPressed: () async {
            await ref.read(crewControllerProvider.notifier).leaveShip();
            await _audit('crew_ship_leave', '{}');
          },
        ),
      ],
    );
  }
}
