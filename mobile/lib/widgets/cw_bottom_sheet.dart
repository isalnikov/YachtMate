import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import 'cw_button.dart';
import 'cw_button_sizes.dart';

/// Shows a Captain Wrongel bottom sheet: drag handle, title, close button,
/// content capped at 50% of screen height.
Future<T?> showCwBottomSheet<T>({
  required BuildContext context,
  required String title,
  required Widget child,
  bool useRootNavigator = true,
}) {
  final maxHeight = MediaQuery.sizeOf(context).height * 0.5;
  final panelBlue =
      Theme.of(context).extension<CwColors>()?.panelBlue ??
      CwColors.light.panelBlue;

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: useRootNavigator,
    backgroundColor: panelBlue,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(CwRadius.lg)),
    ),
    constraints: BoxConstraints(maxHeight: maxHeight),
    builder: (ctx) => CwBottomSheet(title: title, child: child),
  );
}

/// Shared bottom sheet chrome: drag handle, title row, close button, scroll body.
class CwBottomSheet extends StatelessWidget {
  const CwBottomSheet({
    super.key,
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;

    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Semantics(
              label: 'Drag handle',
              child: Container(
                key: const Key('cw_bottom_sheet_drag_handle'),
                margin: const EdgeInsets.only(
                  top: CwSpacing.s,
                  bottom: CwSpacing.s,
                ),
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                  color: colors.textMuted.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(CwRadius.full),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: CwSpacing.m),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                CwIconButton(
                  key: const Key('cw_bottom_sheet_close'),
                  icon: Icons.close,
                  onPressed: () => Navigator.of(context).pop(),
                  variant: CwButtonVariant.tertiary,
                  size: CwButtonSize.md,
                  semanticLabel: 'Close',
                ),
              ],
            ),
          ),
          const SizedBox(height: CwSpacing.s),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                CwSpacing.m,
                0,
                CwSpacing.m,
                CwSpacing.l,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
