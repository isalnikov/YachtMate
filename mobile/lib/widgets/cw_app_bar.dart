import 'package:flutter/material.dart';

import '../core/theme/cw_theme_extensions.dart';
import '../core/theme/cw_tokens.dart';
import '../core/theme/cw_typography.dart';

/// Captain Wrongel app bar — solid deck panels or transparent over map.
class CwAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CwAppBar({
    super.key,
    required this.title,
    this.actions = const [],
    this.transparent = false,
    this.showBack,
  });

  final String title;
  final List<Widget> actions;
  final bool transparent;

  /// When null, back is shown if [Navigator.canPop].
  final bool? showBack;

  static const double iconSize = 24;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colors = context.cwColors;
    final back = showBack ?? Navigator.canPop(context);

    return AppBar(
      backgroundColor: transparent ? Colors.transparent : colors.deckBlue,
      elevation: 0,
      scrolledUnderElevation: transparent ? 0 : 1,
      surfaceTintColor: Colors.transparent,
      foregroundColor: colors.textPrimary,
      automaticallyImplyLeading: false,
      leading: back
          ? IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: colors.accentTeal,
                size: iconSize,
              ),
              tooltip: MaterialLocalizations.of(context).backButtonTooltip,
              onPressed: () => Navigator.maybePop(context),
            )
          : null,
      title: Text(title, style: CwTypography.h2(color: colors.textPrimary)),
      actions: actions,
      iconTheme: IconThemeData(color: colors.textPrimary, size: iconSize),
      actionsIconTheme: IconThemeData(color: colors.textPrimary, size: iconSize),
    );
  }
}
