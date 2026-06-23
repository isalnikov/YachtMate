import 'package:flutter/material.dart';

import '../../../core/crew/crew_controller.dart';
import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';

/// Current crew role with captain/crew chips and color-coded badge.
class CrewRoleCard extends StatelessWidget {
  const CrewRoleCard({super.key, required this.role});

  final CrewRole role;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final isCaptain = role == CrewRole.captain;

    return CwCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                isCaptain ? Icons.sailing_outlined : Icons.groups_outlined,
                color: isCaptain ? colors.accentTeal : colors.accentOrange,
              ),
              const SizedBox(width: CwSpacing.s),
              Expanded(
                child: Text(
                  l10n.crewTitle,
                  style: CwTypography.h2(color: colors.textPrimary),
                ),
              ),
              CrewRoleBadge(role: role),
            ],
          ),
          const SizedBox(height: CwSpacing.m),
          Row(
            children: [
              Expanded(
                child: _RoleChip(
                  label: l10n.crewRoleCaptain,
                  icon: Icons.sailing_outlined,
                  active: isCaptain,
                  activeColor: colors.accentTeal,
                  colors: colors,
                ),
              ),
              const SizedBox(width: CwSpacing.s),
              Expanded(
                child: _RoleChip(
                  label: l10n.crewRoleCrew,
                  icon: Icons.groups_outlined,
                  active: !isCaptain,
                  activeColor: colors.accentOrange,
                  colors: colors,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Compact role pill: captain = teal, crew = orange.
class CrewRoleBadge extends StatelessWidget {
  const CrewRoleBadge({super.key, required this.role});

  final CrewRole role;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final isCaptain = role == CrewRole.captain;
    final palette = isCaptain
        ? _RolePalette(
            background: colors.accentTeal.withValues(alpha: 0.2),
            foreground: colors.accentTeal,
          )
        : _RolePalette(
            background: colors.accentOrange.withValues(alpha: 0.2),
            foreground: colors.accentOrange,
          );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: palette.background,
        borderRadius: BorderRadius.circular(CwRadius.full),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CwSpacing.s,
          vertical: CwSpacing.xs,
        ),
        child: Text(
          isCaptain ? l10n.crewRoleCaptain : l10n.crewRoleCrew,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: palette.foreground,
          ),
        ),
      ),
    );
  }
}

@immutable
class _RolePalette {
  const _RolePalette({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

class _RoleChip extends StatelessWidget {
  const _RoleChip({
    required this.label,
    required this.icon,
    required this.active,
    required this.activeColor,
    required this.colors,
  });

  final String label;
  final IconData icon;
  final bool active;
  final Color activeColor;
  final CwColors colors;

  @override
  Widget build(BuildContext context) {
    final background = active
        ? activeColor.withValues(alpha: 0.18)
        : colors.deckBlue.withValues(alpha: 0.5);
    final foreground = active ? activeColor : colors.textMuted;
    final border = active
        ? BorderSide(color: activeColor.withValues(alpha: 0.45))
        : BorderSide(color: colors.accentTeal.withValues(alpha: 0.15));

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(CwRadius.full),
        border: Border.fromBorderSide(border),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: CwSpacing.s,
          vertical: CwSpacing.s + 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16, color: foreground),
            const SizedBox(width: CwSpacing.xs),
            Flexible(
              child: Text(
                label,
                style: CwTypography.caption(color: foreground).copyWith(
                  fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
