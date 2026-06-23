import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../core/theme/cw_typography.dart';

/// One segment in [CwSegmentedControl].
@immutable
class CwSegmentedOption<T> {
  const CwSegmentedOption({
    required this.value,
    required this.label,
    this.icon,
  });

  final T value;
  final String label;
  final IconData? icon;
}

/// Two-option segmented control styled with [CwColors].
class CwSegmentedControl<T> extends StatelessWidget {
  const CwSegmentedControl({
    super.key,
    required this.options,
    required this.selected,
    required this.onChanged,
    this.expand = true,
  }) : assert(options.length >= 2, 'At least two segments are required');

  final List<CwSegmentedOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;
  final bool expand;

  /// Map/List toggle used on mooring and similar screens.
  static CwSegmentedControl<bool> mapList({
    Key? key,
    required bool showMap,
    required ValueChanged<bool> onChanged,
    required String mapLabel,
    required String listLabel,
    bool expand = true,
  }) {
    return CwSegmentedControl<bool>(
      key: key,
      expand: expand,
      selected: showMap,
      onChanged: onChanged,
      options: [
        CwSegmentedOption(value: true, label: mapLabel, icon: Icons.map_outlined),
        CwSegmentedOption(value: false, label: listLabel, icon: Icons.list),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final children = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      if (i > 0) children.add(const SizedBox(width: CwSpacing.xs));
      final option = options[i];
      final isSelected = option.value == selected;
      children.add(
        Expanded(
          flex: expand ? 1 : 0,
          child: _CwSegment(
            label: option.label,
            icon: option.icon,
            selected: isSelected,
            colors: colors,
            onTap: () {
              if (!isSelected) onChanged(option.value);
            },
          ),
        ),
      );
    }

    return Semantics(
      container: true,
      child: Row(
        mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
        children: children,
      ),
    );
  }
}

class _CwSegment extends StatelessWidget {
  const _CwSegment({
    required this.label,
    required this.selected,
    required this.colors,
    required this.onTap,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final bool selected;
  final CwColors colors;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final background = selected
        ? colors.accentTeal
        : colors.panelBlue.withValues(alpha: 0.9);
    final foreground =
        selected ? colors.deckBlue : colors.textMuted;
    final border = selected
        ? BorderSide.none
        : BorderSide(color: colors.accentTeal.withValues(alpha: 0.2));

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CwRadius.sm),
          side: border,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          splashColor: foreground.withValues(alpha: 0.12),
          highlightColor: foreground.withValues(alpha: 0.08),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 44),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: CwSpacing.m,
                vertical: CwSpacing.s,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 18, color: foreground),
                    const SizedBox(width: CwSpacing.xs),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      style: CwTypography.button(color: foreground).copyWith(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
