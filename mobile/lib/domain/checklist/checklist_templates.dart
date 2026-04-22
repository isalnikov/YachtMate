/// Встроенные шаблоны чек-листов (Фаза 7.4).
abstract final class ChecklistTemplateKeys {
  static const departure = 'departure';
  static const docking = 'docking';
  static const storm = 'storm';

  static const Iterable<String> all = [departure, docking, storm];
}

/// Пункты по ключу шаблона (английский id для стабильности данных).
Map<String, List<(String id, String labelEn)>> checklistSeedItemsEn() => {
  ChecklistTemplateKeys.departure: [
    ('weather', 'Weather and sea state reviewed'),
    ('engine', 'Engine / motor checks'),
    ('safety', 'Safety gear & life jackets'),
    ('nav', 'Navigation plan / waypoints'),
    ('brief', 'Crew briefing'),
  ],
  ChecklistTemplateKeys.docking: [
    ('fenders', 'Fenders and lines ready'),
    ('crew', 'Crew positions assigned'),
    ('engine', 'Engine ready for maneuver'),
    ('vhf', 'VHF tuned to marina/canal'),
  ],
  ChecklistTemplateKeys.storm: [
    ('deck', 'Deck cleared and secured'),
    ('windows', 'Hatches / windows secured'),
    ('drag', 'Anchor drag alarm considered'),
    ('plan', 'Shelter / plan B identified'),
  ],
};
