/// Демонстрационные данные приливов (локальный asset, Фаза 4 MVP).
class TideEvent {
  const TideEvent({
    required this.timeUtc,
    required this.heightM,
    required this.isHigh,
  });

  final DateTime timeUtc;
  final double heightM;
  final bool isHigh;
}

class TideDemoStation {
  const TideDemoStation({
    required this.stationName,
    required this.events,
    required this.note,
  });

  final String stationName;
  final List<TideEvent> events;
  final String note;
}
