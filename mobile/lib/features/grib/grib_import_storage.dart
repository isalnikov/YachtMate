import 'package:shared_preferences/shared_preferences.dart';

/// One imported GRIB file path (decode metadata comes in step-44).
class GribImportFile {
  const GribImportFile({
    required this.path,
    this.importedAtMs,
  });

  final String path;
  final int? importedAtMs;

  String get fileName {
    final parts = path.split('/');
    return parts.isEmpty ? path : parts.last;
  }
}

/// Legacy single-path key kept until step-44 decoder replaces the stub.
const gribLegacyPathPrefsKey = 'gribImportPathStub';

const gribImportListPrefsKey = 'gribImportPathsStub';

List<GribImportFile> loadGribImports(SharedPreferences prefs) {
  final paths = <String>{};

  final legacy = prefs.getString(gribLegacyPathPrefsKey);
  if (legacy != null && legacy.isNotEmpty) {
    paths.add(legacy);
  }

  final stored = prefs.getStringList(gribImportListPrefsKey);
  if (stored != null) {
    paths.addAll(stored);
  }

  return paths
      .map((path) => GribImportFile(path: path))
      .toList(growable: false);
}

Future<void> addGribImport(SharedPreferences prefs, String path) async {
  final list = List<String>.from(prefs.getStringList(gribImportListPrefsKey) ?? []);
  list.remove(path);
  list.insert(0, path);
  await prefs.setStringList(gribImportListPrefsKey, list);
  await prefs.setString(gribLegacyPathPrefsKey, path);
}
