import 'package:flutter/material.dart';

import '../../../core/theme/cw_theme_extensions.dart';
import '../../../core/theme/cw_tokens.dart';
import '../../../core/theme/cw_typography.dart';

/// Chat bubble for offline assistant (step 54).
class AssistantBubble extends StatelessWidget {
  const AssistantBubble({
    super.key,
    required this.text,
    required this.fromUser,
    this.label,
  });

  final String text;
  final bool fromUser;
  final String? label;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final bubbleColor = fromUser
        ? colors.accentTeal.withValues(alpha: 0.18)
        : colors.panelBlue;
    final borderColor = fromUser
        ? colors.accentTeal.withValues(alpha: 0.35)
        : colors.textMuted.withValues(alpha: 0.25);
    final align = fromUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(CwRadius.md),
      topRight: const Radius.circular(CwRadius.md),
      bottomLeft: Radius.circular(fromUser ? CwRadius.md : CwRadius.sm),
      bottomRight: Radius.circular(fromUser ? CwRadius.sm : CwRadius.md),
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: CwSpacing.m),
      child: Column(
        crossAxisAlignment: align,
        children: [
          if (label != null)
            Padding(
              padding: EdgeInsets.only(
                left: fromUser ? CwSpacing.xl : CwSpacing.s,
                right: fromUser ? CwSpacing.s : CwSpacing.xl,
                bottom: CwSpacing.xs,
              ),
              child: Text(
                label!,
                style: CwTypography.caption(color: colors.textMuted),
              ),
            ),
          Align(
            alignment: fromUser ? Alignment.centerRight : Alignment.centerLeft,
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
                    text,
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
