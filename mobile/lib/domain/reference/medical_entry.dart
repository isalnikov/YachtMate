/// Статья медицинского справочника (F13).
class MedicalEntry {
  MedicalEntry({
    required this.id,
    required this.category,
    required this.titles,
    required this.bodies,
  });

  final String id;
  final String category;
  final Map<String, String> titles;
  final Map<String, String> bodies;

  String titleFor(String lang) => titles[lang] ?? titles['en'] ?? id;

  String bodyFor(String lang) => bodies[lang] ?? bodies['en'] ?? '';

  factory MedicalEntry.fromJson(Map<String, dynamic> json) {
    final titlesRaw = json['titles'];
    final bodiesRaw = json['bodies'];
    final titles = <String, String>{};
    final bodies = <String, String>{};
    if (titlesRaw is Map) {
      for (final e in titlesRaw.entries) {
        if (e.value is String) titles[e.key.toString()] = e.value as String;
      }
    }
    if (bodiesRaw is Map) {
      for (final e in bodiesRaw.entries) {
        if (e.value is String) bodies[e.key.toString()] = e.value as String;
      }
    }
    return MedicalEntry(
      id: json['id'] as String,
      category: json['category'] as String,
      titles: titles,
      bodies: bodies,
    );
  }
}

List<MedicalEntry> parseMedicalCatalogJson(Map<String, dynamic> root) {
  final list = root['entries'];
  if (list is! List<dynamic>) return const [];
  return list
      .map((e) => MedicalEntry.fromJson(e as Map<String, dynamic>))
      .toList(growable: false);
}
