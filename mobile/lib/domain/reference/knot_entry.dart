/// Одна запись справочника узлов (контент из JSON, i18n внутри модели по языкам).
class KnotEntry {
  const KnotEntry({
    required this.id,
    required this.category,
    required this.titles,
    required this.steps,
  });

  final String id;

  /// Ключ категории для UI (`loops`, `bends`, …).
  final String category;

  /// Заголовки по коду языка ISO (минимум `en`).
  final Map<String, String> titles;

  /// Шаги по коду языка ISO (минимум `en`).
  final Map<String, List<String>> steps;

  String titleForLang(String lang) => titles[lang] ?? titles['en'] ?? id;

  List<String> stepsForLang(String lang) =>
      steps[lang] ?? steps['en'] ?? const [];

  factory KnotEntry.fromJson(Map<String, dynamic> json) {
    final titlesRaw = json['titles'];
    final stepsRaw = json['steps'];
    final titles = <String, String>{};
    final steps = <String, List<String>>{};
    if (titlesRaw is Map) {
      for (final e in titlesRaw.entries) {
        final v = e.value;
        if (v is String) titles[e.key.toString()] = v;
      }
    }
    if (stepsRaw is Map) {
      for (final e in stepsRaw.entries) {
        final v = e.value;
        if (v is List) {
          steps[e.key.toString()] = v
              .map((x) => x.toString())
              .toList(growable: false);
        }
      }
    }
    return KnotEntry(
      id: json['id'] as String,
      category: json['category'] as String,
      titles: titles,
      steps: steps,
    );
  }
}
