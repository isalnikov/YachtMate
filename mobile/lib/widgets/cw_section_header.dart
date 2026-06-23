import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';

/// Uppercase section label in accent orange.
class CwSectionHeader extends StatelessWidget {
  const CwSectionHeader({
    super.key,
    required this.label,
  });

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return Padding(
      padding: const EdgeInsets.only(
        top: CwSpacing.m + CwSpacing.xs,
        bottom: CwSpacing.s,
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.88,
          color: colors.accentOrange,
        ),
      ),
    );
  }
}
