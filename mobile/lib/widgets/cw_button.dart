import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../core/theme/cw_typography.dart';
import 'cw_button_sizes.dart';

enum CwButtonVariant { primary, secondary, tertiary, danger }

class CwButton extends StatefulWidget {
  const CwButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = CwButtonVariant.primary,
    this.size = CwButtonSize.md,
    this.loading = false,
    this.semanticLabel,
    this.icon,
    this.expand = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final CwButtonVariant variant;
  final CwButtonSize size;
  final bool loading;
  final String? semanticLabel;
  final IconData? icon;
  final bool expand;

  @override
  State<CwButton> createState() => _CwButtonState();
}

class _CwButtonState extends State<CwButton> {
  bool _pressed = false;

  bool get _enabled => !widget.loading && widget.onPressed != null;

  void _handleTapDown(TapDownDetails _) {
    if (!_enabled) return;
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (!_pressed) return;
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    if (!_pressed) return;
    setState(() => _pressed = false);
  }

  void _handleTap() {
    if (!_enabled) return;
    HapticFeedback.lightImpact();
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final palette = _CwButtonPalette.resolve(
      variant: widget.variant,
      colors: colors,
      enabled: _enabled,
      pressed: _pressed,
    );

    final child = _CwButtonContent(
      label: widget.label,
      icon: widget.icon,
      size: widget.size,
      loading: widget.loading,
      foreground: palette.foreground,
    );

    final button = Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel ?? widget.label,
      excludeSemantics: true,
      child: Material(
        color: palette.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CwRadius.md),
          side: palette.border,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _enabled ? _handleTap : null,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          splashColor: palette.foreground.withValues(alpha: 0.12),
          highlightColor: palette.foreground.withValues(alpha: 0.08),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: widget.size.minHeight,
              minWidth: widget.size.minHeight,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: widget.size.horizontalPadding,
                vertical: CwSpacing.s,
              ),
              child: widget.expand
                  ? Center(child: child)
                  : child,
            ),
          ),
        ),
      ),
    );

    if (widget.expand) {
      return SizedBox(width: double.infinity, child: button);
    }
    return button;
  }
}

class CwIconButton extends StatefulWidget {
  const CwIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.variant = CwButtonVariant.tertiary,
    this.size = CwButtonSize.md,
    this.loading = false,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final CwButtonVariant variant;
  final CwButtonSize size;
  final bool loading;
  final String? semanticLabel;

  @override
  State<CwIconButton> createState() => _CwIconButtonState();
}

class _CwIconButtonState extends State<CwIconButton> {
  bool _pressed = false;

  bool get _enabled => !widget.loading && widget.onPressed != null;

  void _handleTapDown(TapDownDetails _) {
    if (!_enabled) return;
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (!_pressed) return;
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    if (!_pressed) return;
    setState(() => _pressed = false);
  }

  void _handleTap() {
    if (!_enabled) return;
    HapticFeedback.lightImpact();
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final palette = _CwButtonPalette.resolve(
      variant: widget.variant,
      colors: colors,
      enabled: _enabled,
      pressed: _pressed,
    );
    final dimension = widget.size.minHeight;

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: palette.background,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(CwRadius.full),
          side: palette.border,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _enabled ? _handleTap : null,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          customBorder: const CircleBorder(),
          splashColor: palette.foreground.withValues(alpha: 0.12),
          highlightColor: palette.foreground.withValues(alpha: 0.08),
          child: SizedBox(
            width: dimension,
            height: dimension,
            child: Center(
              child: widget.loading
                  ? SizedBox(
                      width: widget.size.iconSize,
                      height: widget.size.iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: palette.foreground,
                      ),
                    )
                  : Icon(
                      widget.icon,
                      size: widget.size.iconSize,
                      color: palette.foreground,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class CwFab extends StatefulWidget {
  const CwFab({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = CwFabSize.sm,
    this.loading = false,
    this.semanticLabel,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final CwFabSize size;
  final bool loading;
  final String? semanticLabel;

  @override
  State<CwFab> createState() => _CwFabState();
}

class _CwFabState extends State<CwFab> {
  bool _pressed = false;

  bool get _enabled => !widget.loading && widget.onPressed != null;

  void _handleTapDown(TapDownDetails _) {
    if (!_enabled) return;
    setState(() => _pressed = true);
  }

  void _handleTapUp(TapUpDetails _) {
    if (!_pressed) return;
    setState(() => _pressed = false);
  }

  void _handleTapCancel() {
    if (!_pressed) return;
    setState(() => _pressed = false);
  }

  void _handleTap() {
    if (!_enabled) return;
    HapticFeedback.lightImpact();
    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final background = _enabled
        ? (_pressed
            ? Color.lerp(colors.accentTeal, Colors.black, 0.12)!
            : colors.accentTeal)
        : colors.accentTeal.withValues(alpha: 0.4);
    final foreground =
        _enabled ? colors.deckBlue : colors.deckBlue.withValues(alpha: 0.5);

    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      excludeSemantics: true,
      child: Material(
        color: background,
        elevation: _pressed ? 6 : 4,
        shadowColor: Colors.black.withValues(alpha: 0.35),
        shape: const CircleBorder(),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: _enabled ? _handleTap : null,
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          customBorder: const CircleBorder(),
          splashColor: foreground.withValues(alpha: 0.12),
          highlightColor: foreground.withValues(alpha: 0.08),
          child: SizedBox(
            width: widget.size.diameter,
            height: widget.size.diameter,
            child: Center(
              child: widget.loading
                  ? SizedBox(
                      width: widget.size.iconSize,
                      height: widget.size.iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: foreground,
                      ),
                    )
                  : Icon(
                      widget.icon,
                      size: widget.size.iconSize,
                      color: foreground,
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CwButtonContent extends StatelessWidget {
  const _CwButtonContent({
    required this.label,
    required this.size,
    required this.loading,
    required this.foreground,
    this.icon,
  });

  final String label;
  final IconData? icon;
  final CwButtonSize size;
  final bool loading;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      final indicatorSize = size.minHeight * 0.45;
      return SizedBox(
        width: indicatorSize,
        height: indicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: foreground,
        ),
      );
    }

    final textStyle = CwTypography.button(color: foreground);
    if (icon == null) {
      return Text(label, style: textStyle, textAlign: TextAlign.center);
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: size.iconSize, color: foreground),
        const SizedBox(width: CwSpacing.s),
        Flexible(
          child: Text(label, style: textStyle, textAlign: TextAlign.center),
        ),
      ],
    );
  }
}

@immutable
class _CwButtonPalette {
  const _CwButtonPalette({
    required this.background,
    required this.foreground,
    required this.border,
  });

  final Color background;
  final Color foreground;
  final BorderSide border;

  static _CwButtonPalette resolve({
    required CwButtonVariant variant,
    required CwColors colors,
    required bool enabled,
    required bool pressed,
  }) {
    if (!enabled) {
      return _CwButtonPalette(
        background: _disabledBackground(variant, colors),
        foreground: colors.textMuted,
        border: _disabledBorder(variant, colors),
      );
    }

    return switch (variant) {
      CwButtonVariant.primary => _CwButtonPalette(
          background: pressed
              ? Color.lerp(colors.accentTeal, Colors.black, 0.12)!
              : colors.accentTeal,
          foreground: colors.deckBlue,
          border: BorderSide.none,
        ),
      CwButtonVariant.secondary => _CwButtonPalette(
          background: pressed
              ? colors.panelBlue.withValues(alpha: 0.9)
              : colors.panelBlue,
          foreground: colors.textPrimary,
          border: BorderSide(color: colors.accentTeal.withValues(alpha: 0.8)),
        ),
      CwButtonVariant.tertiary => _CwButtonPalette(
          background: pressed
              ? colors.accentTeal.withValues(alpha: 0.12)
              : Colors.transparent,
          foreground: colors.accentTeal,
          border: BorderSide.none,
        ),
      CwButtonVariant.danger => _CwButtonPalette(
          background: pressed
              ? Color.lerp(colors.danger, Colors.black, 0.12)!
              : colors.danger,
          foreground: colors.textPrimary,
          border: BorderSide.none,
        ),
    };
  }

  static Color _disabledBackground(CwButtonVariant variant, CwColors colors) {
    return switch (variant) {
      CwButtonVariant.primary =>
        colors.accentTeal.withValues(alpha: 0.35),
      CwButtonVariant.secondary => colors.panelBlue.withValues(alpha: 0.5),
      CwButtonVariant.tertiary => Colors.transparent,
      CwButtonVariant.danger => colors.danger.withValues(alpha: 0.35),
    };
  }

  static BorderSide _disabledBorder(CwButtonVariant variant, CwColors colors) {
    if (variant == CwButtonVariant.secondary) {
      return BorderSide(color: colors.textMuted.withValues(alpha: 0.4));
    }
    return BorderSide.none;
  }
}
