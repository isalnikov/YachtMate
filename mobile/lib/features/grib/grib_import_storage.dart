import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/grib/grib_decoder.dart';

/// One imported GRIB file with optional decoded metadata (step-44).
class GribImportFile {
  const GribImportFile({
    required this.path,
    this.importedAtMs,
    this.decodeSummary,
    this.decodeError,
    this.windSampleLabel,
  });

  final String path;
  final int? importedAtMs;
  final String? decodeSummary;
  final String? decodeError;
  final String? windSampleLabel;

  String get fileName {
    final parts = path.split('/');
    return parts.isEmpty ? path : parts.last;
  }

  bool get isDecoded => decodeSummary != null && decodeError == null;
}

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

/// Decode a GRIB file on disk and attach summary labels for the UI.
Future<GribImportFile> decodeGribImportFile(GribImportFile file) async {
  final source = File(file.path);
  if (!source.existsSync()) {
    return GribImportFile(
      path: file.path,
      importedAtMs: file.importedAtMs,
      decodeError: 'File not found: ${file.path}',
    );
  }

  final result = GribDecoder.decodeBytes(await source.readAsBytes());
  if (!result.isOk) {
    return GribImportFile(
      path: file.path,
      importedAtMs: file.importedAtMs,
      decodeError: result.error ?? 'Could not parse GRIB file',
    );
  }

  final sample = GribDecoder.windAtPoint(
    result: result,
    lat: result.messages.first.grid.latMin +
        (result.messages.first.grid.latMax -
                result.messages.first.grid.latMin) /
            2,
    lon: result.messages.first.grid.lonMin +
        (result.messages.first.grid.lonMax -
                result.messages.first.grid.lonMin) /
            2,
  );

  return GribImportFile(
    path: file.path,
    importedAtMs: file.importedAtMs,
    decodeSummary: result.summaryLabel,
    windSampleLabel: sample == null
        ? null
        : 'Wind @ ${sample.lat.toStringAsFixed(1)}°, '
            '${sample.lon.toStringAsFixed(1)}°: '
            'U ${sample.uMs.toStringAsFixed(1)} · '
            'V ${sample.vMs.toStringAsFixed(1)} m/s',
  );
}
