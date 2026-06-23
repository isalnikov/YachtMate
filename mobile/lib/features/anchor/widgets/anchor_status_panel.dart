import 'package:flutter/material.dart';

import '../../../core/anchor_watch_controller.dart';
import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../l10n/app_localizations.dart';
import '../../../widgets/cw_card.dart';

/// Status chip: IN ZONE (green) or DRIFTING (red pulse) plus distance.
class AnchorStatusPanel extends StatefulWidget {
  const AnchorStatusPanel({
    super.key,
    required this.state,
  });

  final AnchorWatchState state;

  @override
  State<AnchorStatusPanel> createState() => _AnchorStatusPanelState();
}

class _AnchorStatusPanelState extends State<AnchorStatusPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _syncPulse();
  }

  @override
  void didUpdateWidget(covariant AnchorStatusPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncPulse();
  }

  void _syncPulse() {
    if (widget.state.isDrifting) {
      if (!_pulse.isAnimating) {
        _pulse.repeat(reverse: true);
      }
    } else {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final s = widget.state;
    final theme = Theme.of(context);

    final armed = s.armed;
    final drifting = s.isDrifting;
    final statusLabel = !armed
        ? l10n.anchorWatchDisarmed
        : drifting
            ? l10n.anchorWatchDrifting
            : l10n.anchorWatchInZone;
    final statusColor = !armed
        ? colors.textMuted
        : drifting
            ? colors.danger
            : colors.safe;

    return CwCard(
      padding: const EdgeInsets.symmetric(
        horizontal: CwSpacing.m,
        vertical: CwSpacing.s + 4,
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _pulse,
            builder: (context, child) {
              final glow = drifting ? 0.35 + _pulse.value * 0.45 : 0.0;
              return Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: statusColor.withValues(alpha: drifting ? 0.85 : 1),
                  boxShadow: drifting
                      ? [
                          BoxShadow(
                            color: colors.danger.withValues(alpha: glow),
                            blurRadius: 10,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
              );
            },
          ),
          const SizedBox(width: CwSpacing.s),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  statusLabel,
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.4,
                  ),
                ),
                if (armed && s.lastDistanceM != null)
                  Text(
                    '${l10n.anchorWatchDistance}: ${s.lastDistanceM!.toStringAsFixed(1)} m',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: colors.textMuted,
                    ),
                  )
                else if (!s.hasAnchor)
                  Text(
                    l10n.anchorWatchHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colors.textMuted,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (armed)
            Text(
              '● ${l10n.anchorWatchArmedBadge}',
              style: theme.textTheme.labelSmall?.copyWith(
                color: colors.safe,
                fontWeight: FontWeight.w600,
              ),
            ),
        ],
      ),
    );
  }
}
