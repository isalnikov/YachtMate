/// Точка прибрежного POI из GeoJSON (F11).
class ShorePoi {
  ShorePoi({
    required this.id,
    required this.category,
    required this.lat,
    required this.lon,
    required this.titles,
    required this.bodies,
  });

  final String id;
  final String category;
  final double lat;
  final double lon;
  final Map<String, String> titles;
  final Map<String, String> bodies;

  String titleFor(String lang) => titles[lang] ?? titles['en'] ?? id;

  String bodyFor(String lang) => bodies[lang] ?? bodies['en'] ?? '';

  static List<ShorePoi> parseGeoJson(Map<String, dynamic> root) {
    final feats = root['features'];
    if (feats is! List<dynamic>) return const [];
    final out = <ShorePoi>[];
    for (final raw in feats) {
      if (raw is! Map<String, dynamic>) continue;
      final geom = raw['geometry'];
      final props = raw['properties'];
      if (geom is! Map<String, dynamic> || props is! Map<String, dynamic>) {
        continue;
      }
      final coords = geom['coordinates'];
      if (coords is! List || coords.length < 2) continue;
      final lon = (coords[0] as num).toDouble();
      final lat = (coords[1] as num).toDouble();
      final id = props['id']?.toString() ?? '';
      if (id.isEmpty) continue;
      final titles = _stringMap(props['titles']);
      final bodies = _stringMap(props['bodies']);
      out.add(
        ShorePoi(
          id: id,
          category: props['category']?.toString() ?? 'other',
          lat: lat,
          lon: lon,
          titles: titles,
          bodies: bodies,
        ),
      );
    }
    return out;
  }

  static Map<String, String> _stringMap(Object? raw) {
    final m = <String, String>{};
    if (raw is Map) {
      for (final e in raw.entries) {
        final v = e.value;
        if (v is String) m[e.key.toString()] = v;
      }
    }
    return m;
  }
}
