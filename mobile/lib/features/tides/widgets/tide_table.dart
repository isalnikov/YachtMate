import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;

import '../../../core/theme/cw_tokens.dart';
import '../../../domain/tides/tide_demo_models.dart';
import '../../../domain/tides/tide_week_schedule.dart';

/// Seven-day HW/LW table derived from demo anchor events.
class TideTable extends StatelessWidget {
  const TideTable({
    super.key,
    required this.anchorEvents,
    required this.locale,
    required this.dayHeader,
    required this.hwHeader,
    required this.lwHeader,
    required this.formatEvent,
  });

  final List<TideEvent> anchorEvents;
  final String locale;
  final String dayHeader;
  final String hwHeader;
  final String lwHeader;
  final String Function(DateTime local, double heightM, bool isHigh) formatEvent;

  @override
  Widget build(BuildContext context) {
    final week = buildTideWeekSchedule(anchorEvents);
    if (week.isEmpty) {
      return const SizedBox.shrink();
    }

    final dayFmt = DateFormat.E('en').addPattern(' d MMM');
    final timeFmt = DateFormat.Hm(locale);
    final theme = Theme.of(context);

    return Table(
      columnWidths: const {
        0: FlexColumnWidth(1.4),
        1: FlexColumnWidth(1.2),
        2: FlexColumnWidth(1.2),
        3: FlexColumnWidth(1.2),
        4: FlexColumnWidth(1.2),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.35,
            ),
          ),
          children: [
            _HeaderCell(dayHeader),
            _HeaderCell(hwHeader),
            _HeaderCell(lwHeader),
            _HeaderCell(hwHeader),
            _HeaderCell(lwHeader),
          ],
        ),
        for (final row in week)
          TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: CwSpacing.s,
                  horizontal: CwSpacing.xs,
                ),
                child: Text(
                  dayFmt.format(row.dateLocal),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              for (var i = 0; i < 2; i++)
                _EventCell(
                  event: i < row.highs.length ? row.highs[i] : null,
                  timeFmt: timeFmt,
                  formatEvent: formatEvent,
                  isHigh: true,
                ),
              for (var i = 0; i < 2; i++)
                _EventCell(
                  event: i < row.lows.length ? row.lows[i] : null,
                  timeFmt: timeFmt,
                  formatEvent: formatEvent,
                  isHigh: false,
                ),
            ],
          ),
      ],
    );
  }
}

class _HeaderCell extends StatelessWidget {
  const _HeaderCell(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: CwSpacing.s,
        horizontal: CwSpacing.xs,
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}

class _EventCell extends StatelessWidget {
  const _EventCell({
    required this.event,
    required this.timeFmt,
    required this.formatEvent,
    required this.isHigh,
  });

  final TideEvent? event;
  final DateFormat timeFmt;
  final String Function(DateTime local, double heightM, bool isHigh) formatEvent;
  final bool isHigh;

  @override
  Widget build(BuildContext context) {
    final e = event;
    if (e == null) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: CwSpacing.s,
          horizontal: CwSpacing.xs,
        ),
        child: Text('—'),
      );
    }
    final local = e.timeUtc.toLocal();
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: CwSpacing.s,
        horizontal: CwSpacing.xs,
      ),
      child: Text(
        formatEvent(local, e.heightM, isHigh),
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
