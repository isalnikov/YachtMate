import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';

enum CwChipVariant { filter }

/// Filter chip with selected and unselected states.
class CwChip extends StatelessWidget {
  const CwChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onSelected,
    this.variant = CwChipVariant.filter,
  });

  final String label;
  final bool selected;
  final ValueChanged<bool> onSelected;
  final CwChipVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final palette = _CwChipPalette.resolve(
      variant: variant,
      colors: colors,
      selected: selected,
    );

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: palette.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CwRadius.full),
          side: palette.border,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onSelected(!selected),
          splashColor: palette.foreground.withValues(alpha: 0.12),
          highlightColor: palette.foreground.withValues(alpha: 0.08),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: CwSpacing.s,
            ),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: palette.foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _CwChipPalette {
  const _CwChipPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final BorderSide border;

  static _CwChipPalette resolve({
    required CwChipVariant variant,
    required CwColors colors,
    required bool selected,
  }) {
    return switch (variant) {
      CwChipVariant.filter when selected => _CwChipPalette(
          background: colors.accentTeal,
          foreground: colors.deckBlue,
          border: BorderSide.none,
        ),
      CwChipVariant.filter => _CwChipPalette(
          background: colors.panelBlue.withValues(alpha: 0.9),
          foreground: colors.textMuted,
          border: BorderSide(color: colors.accentTeal.withValues(alpha: 0.2)),
        ),
    };
  }
}
