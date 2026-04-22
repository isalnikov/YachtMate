import 'dart:convert';

import 'package:flutter/services.dart';

import '../../domain/tides/tide_demo_models.dart';

/// Загружает иллюстративное расписание приливов из asset (не гидрографический эталон).
class TidesRepository {
  Future<TideDemoStation> loadDemoBundled() async {
    final raw = await rootBundle.loadString('assets/tides/demo_tides.json');
    final map = jsonDecode(raw) as Map<String, dynamic>;
    final name = map['stationName'] as String? ?? 'Demo';
    final note = map['note'] as String? ?? '';
    final ev = <TideEvent>[];
    for (final e in map['events'] as List<dynamic>? ?? const []) {
      if (e is! Map<String, dynamic>) continue;
      ev.add(
        TideEvent(
          timeUtc: DateTime.parse(e['time'] as String).toUtc(),
          heightM: (e['heightM'] as num).toDouble(),
          isHigh: e['kind'] == 'high',
        ),
      );
    }
    return TideDemoStation(stationName: name, events: ev, note: note);
  }
}
