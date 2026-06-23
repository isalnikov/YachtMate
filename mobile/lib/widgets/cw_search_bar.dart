import 'package:flutter/material.dart';

import 'cw_text_field.dart';

/// Search input with magnifier prefix and optional clear action.
class CwSearchBar extends StatelessWidget {
  const CwSearchBar({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.onClear,
    this.autofocus = false,
    this.semanticLabel,
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;
  final bool autofocus;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final hasText = controller.text.isNotEmpty;
        return CwTextField(
          controller: controller,
          hint: hintText,
          prefixIcon: Icons.search,
          suffixIcon: hasText
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    controller.clear();
                    onClear?.call();
                    onChanged?.call('');
                  },
                  tooltip: MaterialLocalizations.of(context).clearButtonTooltip,
                )
              : null,
          onChanged: onChanged,
          autofocus: autofocus,
          textInputAction: TextInputAction.search,
          semanticLabel: semanticLabel ?? hintText,
        );
      },
    );
  }
}
