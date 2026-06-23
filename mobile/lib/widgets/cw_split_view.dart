import 'package:flutter/material.dart';

/// Navionics-style master/detail split for tablet widths (≥768px).
///
/// Left pane (master) is 60% — map or timeline content.
/// Right pane (detail) is 40% — list or detail panel.
class CwSplitView extends StatelessWidget {
  const CwSplitView({
    super.key,
    required this.master,
    required this.detail,
    this.breakpoint = tabletBreakpoint,
    this.masterFlex = 6,
    this.detailFlex = 4,
    this.showDivider = true,
  });

  static const double tabletBreakpoint = 768;

  final Widget master;
  final Widget detail;
  final double breakpoint;
  final int masterFlex;
  final int detailFlex;
  final bool showDivider;

  /// True when [width] is wide enough for side-by-side master/detail.
  static bool isSplitWidth(double width, [double bp = tabletBreakpoint]) =>
      width >= bp;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (!isSplitWidth(constraints.maxWidth, breakpoint)) {
          return detail;
        }

        return Row(
          key: const Key('cw_split_view'),
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              flex: masterFlex,
              key: const Key('cw_split_view_master'),
              child: master,
            ),
            if (showDivider) const VerticalDivider(width: 1, thickness: 1),
            Expanded(
              flex: detailFlex,
              key: const Key('cw_split_view_detail'),
              child: detail,
            ),
          ],
        );
      },
    );
  }
}
