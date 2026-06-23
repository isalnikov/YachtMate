import 'package:flutter/material.dart';

import '../../../core/theme/cw_tokens.dart';
import '../../../widgets/cw_card.dart';

/// Grouped settings block with section title and card body (step-27).
class SettingsSection extends StatelessWidget {
  const SettingsSection({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: CwSpacing.s),
        CwCard(child: child),
        const SizedBox(height: CwSpacing.l),
      ],
    );
  }
}
