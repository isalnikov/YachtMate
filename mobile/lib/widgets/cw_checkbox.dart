import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../core/theme/cw_typography.dart';

/// Design-system checkbox row: teal box, optional strike-through label.
class CwCheckbox extends StatelessWidget {
  const CwCheckbox({
    super.key,
    required this.value,
    required this.label,
    this.onChanged,
    this.strikeThroughWhenChecked = true,
  });

  final bool value;
  final String label;
  final ValueChanged<bool>? onChanged;
  final bool strikeThroughWhenChecked;

  static const double _boxSize = 24;
  static const double _minHeight = 44;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final enabled = onChanged != null;

    final labelStyle = CwTypography.body(color: colors.textPrimary).copyWith(
      decoration: value && strikeThroughWhenChecked
          ? TextDecoration.lineThrough
          : null,
      decorationColor: colors.textMuted,
      color: value && strikeThroughWhenChecked ? colors.textMuted : null,
    );

    final box = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _boxSize,
      height: _boxSize,
      decoration: BoxDecoration(
        color: value ? colors.accentTeal : Colors.transparent,
        borderRadius: BorderRadius.circular(CwRadius.sm),
        border: Border.all(
          color: value
              ? colors.accentTeal
              : colors.accentTeal.withValues(alpha: 0.4),
          width: 2,
        ),
      ),
      child: value
          ? Icon(Icons.check, size: 16, color: colors.deckBlue)
          : null,
    );

    final row = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        box,
        const SizedBox(width: CwSpacing.m),
        Expanded(child: Text(label, style: labelStyle)),
      ],
    );

    if (!enabled) {
      return Opacity(
        opacity: 0.6,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _minHeight),
          child: row,
        ),
      );
    }

    return Semantics(
      checked: value,
      button: true,
      label: label,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onChanged!(!value);
        },
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: _minHeight),
          child: row,
        ),
      ),
    );
  }
}
