import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../core/theme/cw_typography.dart';

/// Themed text field with prefix/suffix icons and error text (design-system §3.4.2).
class CwTextField extends StatelessWidget {
  const CwTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.label,
    this.hint,
    this.errorText,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.readOnly = false,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofocus = false,
    this.enabled = true,
    this.maxLines = 1,
    this.style,
    this.semanticLabel,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? label;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final bool readOnly;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final bool enabled;
  final int maxLines;
  final TextStyle? style;
  final String? semanticLabel;

  /// Shared [InputDecoration] styled from [CwColors].
  static InputDecoration decoration(
    BuildContext context, {
    String? label,
    String? hint,
    String? errorText,
    IconData? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
  }) {
    final colors = context.cwColors;
    final borderRadius = BorderRadius.circular(CwRadius.sm);
    final idleBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colors.accentTeal.withValues(alpha: 0.2)),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colors.accentTeal, width: 1.5),
    );
    final errorBorder = OutlineInputBorder(
      borderRadius: borderRadius,
      borderSide: BorderSide(color: colors.danger),
    );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: errorText,
      filled: true,
      fillColor: enabled
          ? colors.panelBlue
          : colors.panelBlue.withValues(alpha: 0.5),
      hintStyle: CwTypography.caption(color: colors.textMuted),
      labelStyle: CwTypography.caption(color: colors.textMuted),
      errorStyle: CwTypography.caption(color: colors.danger),
      prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      prefixIconColor: colors.textMuted,
      suffixIcon: suffixIcon,
      suffixIconColor: colors.textMuted,
      enabledBorder: idleBorder,
      disabledBorder: idleBorder,
      border: idleBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: errorBorder,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: CwSpacing.m,
        vertical: CwSpacing.s,
      ),
      isDense: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      style: style ?? CwTypography.body(color: colors.textPrimary),
      decoration: decoration(
        context,
        label: label,
        hint: hint,
        errorText: errorText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        enabled: enabled,
      ),
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      onTap: onTap,
      readOnly: readOnly,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      inputFormatters: inputFormatters,
      autofocus: autofocus,
      enabled: enabled,
      maxLines: maxLines,
    );

    if (semanticLabel == null) return field;
    return Semantics(
      textField: true,
      label: semanticLabel,
      child: field,
    );
  }
}
