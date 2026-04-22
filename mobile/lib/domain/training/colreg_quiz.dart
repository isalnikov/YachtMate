import 'dart:convert';

/// Вопрос викторины COLREG из JSON (F12).
class ColregQuestion {
  ColregQuestion({
    required this.id,
    required this.prompt,
    required this.choices,
    required this.correctKey,
  });

  final String id;
  final Map<String, String> prompt;
  final List<ColregChoice> choices;
  final String correctKey;

  String promptFor(String lang) => prompt[lang] ?? prompt['en'] ?? '';

  static List<ColregQuestion> parseJson(String raw) {
    final root = jsonDecode(raw) as Map<String, dynamic>;
    final qs = root['questions'];
    if (qs is! List<dynamic>) return const [];
    return qs.map((q) {
      final m = q as Map<String, dynamic>;
      final prompt = _strMap(m['prompt']);
      final choicesRaw = m['choices'];
      final choices = <ColregChoice>[];
      if (choicesRaw is List) {
        for (final c in choicesRaw) {
          if (c is Map<String, dynamic>) {
            choices.add(
              ColregChoice(
                key: c['key'] as String,
                text: _strMap(c['text']),
              ),
            );
          }
        }
      }
      return ColregQuestion(
        id: m['id'] as String,
        prompt: prompt,
        choices: choices,
        correctKey: m['correct'] as String,
      );
    }).toList(growable: false);
  }

  static Map<String, String> _strMap(Object? raw) {
    final m = <String, String>{};
    if (raw is Map) {
      for (final e in raw.entries) {
        if (e.value is String) m[e.key.toString()] = e.value as String;
      }
    }
    return m;
  }
}

class ColregChoice {
  ColregChoice({required this.key, required this.text});

  final String key;
  final Map<String, String> text;

  String labelFor(String lang) => text[lang] ?? text['en'] ?? key;
}
