import 'package:flutter/material.dart';

import '../../core/theme/cw_theme_extensions.dart';
import '../../core/theme/cw_tokens.dart';
import '../../core/theme/cw_typography.dart';

/// Shared layout for onboarding steps 2–4 (title + body + content).
class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
  });

  final String title;
  final String? subtitle;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: CwSpacing.l),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: CwSpacing.xl),
            Text(
              title,
              style: CwTypography.h1(color: colors.textPrimary),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: CwSpacing.m),
              Text(
                subtitle!,
                style: CwTypography.body(color: colors.textMuted),
              ),
            ],
            const SizedBox(height: CwSpacing.xl),
            Expanded(child: child),
          ],
        ),
      ),
    );
  }
}
