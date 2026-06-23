import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';
import '../../../domain/training/vhf_scenario.dart';
import '../../../l10n/app_localizations.dart';

/// Chat-style VHF dialogue bubble — shore (left) or you (right).
class VhfDialogueBubble extends StatelessWidget {
  const VhfDialogueBubble({
    super.key,
    required this.line,
    required this.lang,
  });

  final VhfDialogueLine line;
  final String lang;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = context.cwColors;
    final isYou = line.speaker == VhfDialogueSpeaker.you;
    final label =
        isYou ? l10n.vhfDialogueYou : l10n.vhfDialogueShore;
    final bubbleColor = isYou
        ? colors.accentTeal.withValues(alpha: 0.18)
        : colors.panelBlue;
    final borderColor = isYou
        ? colors.accentTeal.withValues(alpha: 0.35)
        : colors.textMuted.withValues(alpha: 0.25);
    final align = isYou ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(CwRadius.md),
      topRight: const Radius.circular(CwRadius.md),
      bottomLeft: Radius.circular(isYou ? CwRadius.md : CwRadius.sm),
      bottomRight: Radius.circular(isYou ? CwRadius.sm : CwRadius.md),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: CwSpacing.m),
      child: Column(
        crossAxisAlignment: align,
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: isYou ? CwSpacing.xl : CwSpacing.s,
              right: isYou ? CwSpacing.s : CwSpacing.xl,
              bottom: CwSpacing.xs,
            ),
            child: Text(
              label,
              style: CwTypography.caption(color: colors.textMuted),
            ),
          ),
          Align(
            alignment: isYou ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.82,
              ),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: bubbleColor,
                  borderRadius: radius,
                  border: Border.all(color: borderColor),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(CwSpacing.m),
                  child: Text(
                    line.textFor(lang),
                    style: CwTypography.body(color: colors.textPrimary),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
