/// Одна запись справочника узлов (контент из JSON, i18n внутри модели по языкам).
class KnotEntry {
  const KnotEntry({
    required this.id,
    required this.category,
    required this.titles,
    required this.steps,
    this.difficulty = 'easy',
    this.useCases = const {},
  });

  final String id;

  /// Ключ категории для UI (`loops`, `bends`, …).
  final String category;

  /// Заголовки по коду языка ISO (минимум `en`).
  final Map<String, String> titles;

  /// Шаги по коду языка ISO (минимум `en`).
  final Map<String, List<String>> steps;

  /// `easy`, `medium`, or `hard`.
  final String difficulty;

  /// Краткое назначение узла по языкам (минимум `en`).
  final Map<String, String> useCases;

  String titleForLang(String lang) => titles[lang] ?? titles['en'] ?? id;

  List<String> stepsForLang(String lang) =>
      steps[lang] ?? steps['en'] ?? const [];

  String useCaseForLang(String lang) =>
      useCases[lang] ?? useCases['en'] ?? '';

  factory KnotEntry.fromJson(Map<String, dynamic> json) {
    final titlesRaw = json['titles'];
    final stepsRaw = json['steps'];
    final useCasesRaw = json['useCases'];
    final titles = <String, String>{};
    final steps = <String, List<String>>{};
    final useCases = <String, String>{};
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
    if (useCasesRaw is Map) {
      for (final e in useCasesRaw.entries) {
        final v = e.value;
        if (v is String) useCases[e.key.toString()] = v;
      }
    }
    return KnotEntry(
      id: json['id'] as String,
      category: json['category'] as String,
      titles: titles,
      steps: steps,
      difficulty: json['difficulty'] as String? ?? 'easy',
      useCases: useCases,
    );
  }
}
