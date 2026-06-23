import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

/// Parsed GRIB2 grid definition (regular lat/lon template 3.0).
class GribGrid {
  const GribGrid({
    required this.ni,
    required this.nj,
    required this.lat1,
    required this.lon1,
    required this.lat2,
    required this.lon2,
    required this.di,
    required this.dj,
    required this.scanMode,
  });

  final int ni;
  final int nj;
  final double lat1;
  final double lon1;
  final double lat2;
  final double lon2;
  final double di;
  final double dj;
  final int scanMode;

  double get latMin => math.min(lat1, lat2);
  double get latMax => math.max(lat1, lat2);
  double get lonMin => math.min(lon1, lon2);
  double get lonMax => math.max(lon1, lon2);

  String get boundsLabel =>
      '${latMin.toStringAsFixed(1)}–${latMax.toStringAsFixed(1)}°N, '
      '${lonMin.toStringAsFixed(1)}–${lonMax.toStringAsFixed(1)}°E';
}

/// One GRIB2 product message (typically one scalar field on a grid).
class GribMessage {
  const GribMessage({
    required this.discipline,
    required this.category,
    required this.parameterNumber,
    required this.parameterLabel,
    required this.referenceTimeUtc,
    required this.forecastHour,
    required this.grid,
    required this.values,
  });

  final int discipline;
  final int category;
  final int parameterNumber;
  final String parameterLabel;
  final DateTime referenceTimeUtc;
  final int forecastHour;
  final GribGrid grid;
  final List<double> values;

  bool get isWindU => discipline == 0 && category == 2 && parameterNumber == 2;
  bool get isWindV => discipline == 0 && category == 2 && parameterNumber == 3;
}

/// Wind sample interpolated from U/V messages at a lat/lon point.
class GribWindSample {
  const GribWindSample({
    required this.lat,
    required this.lon,
    required this.uMs,
    required this.vMs,
  });

  final double lat;
  final double lon;
  final double uMs;
  final double vMs;

  double get speedMs => math.sqrt(uMs * uMs + vMs * vMs);

  double get directionDeg {
    final rad = math.atan2(uMs, vMs);
    final deg = rad * 180 / math.pi;
    return (deg + 360) % 360;
  }
}

/// Result of decoding one or more GRIB2 messages from a file.
class GribDecodeResult {
  const GribDecodeResult({
    required this.messages,
    this.error,
  });

  final List<GribMessage> messages;
  final String? error;

  bool get isOk => error == null && messages.isNotEmpty;

  String get summaryLabel {
    if (error != null) return error!;
    if (messages.isEmpty) return 'No GRIB messages found';

    final grid = messages.first.grid;
    final parts = <String>[
      '${messages.length} message(s)',
      '${grid.ni}×${grid.nj} grid',
      grid.boundsLabel,
    ];

    final wind = messages.where((m) => m.isWindU || m.isWindV).toList();
    if (wind.isNotEmpty) {
      parts.add(wind.map((m) => m.parameterLabel).join(', '));
    }

    final ref = messages.first.referenceTimeUtc;
    parts.add(
      'Ref ${ref.year}-${_two(ref.month)}-${_two(ref.day)} '
      '${_two(ref.hour)}:${_two(ref.minute)}Z',
    );
    return parts.join(' · ');
  }

  static String _two(int v) => v.toString().padLeft(2, '0');
}

/// Minimal GRIB2 decoder: metadata + simple-packed scalar grids (wind U/V MVP).
class GribDecoder {
  const GribDecoder._();

  static GribDecodeResult decodeBytes(Uint8List bytes) {
    if (bytes.length < 16) {
      return const GribDecodeResult(
        messages: [],
        error: 'File too small for GRIB2',
      );
    }

    final messages = <GribMessage>[];
    var offset = 0;

    while (offset + 16 <= bytes.length) {
      if (!_isGribMagic(bytes, offset)) break;

      final totalLength = _readUint64(bytes, offset + 7);
      if (totalLength < 16 || offset + totalLength > bytes.length) {
        return GribDecodeResult(
          messages: messages,
          error: 'Invalid GRIB message length at offset $offset',
        );
      }

      final slice = bytes.sublist(offset, offset + totalLength);
      final message = _parseMessage(slice);
      if (message == null) {
        return GribDecodeResult(
          messages: messages,
          error: 'Unsupported GRIB2 section layout',
        );
      }
      messages.add(message);
      offset += totalLength;
    }

    if (messages.isEmpty) {
      return const GribDecodeResult(
        messages: [],
        error: 'No GRIB2 messages found',
      );
    }

    return GribDecodeResult(messages: messages);
  }

  static Future<GribDecodeResult> decodeFile(String path) async {
    final file = File(path);
    if (!await file.exists()) {
      return GribDecodeResult(
        messages: const [],
        error: 'File not found: $path',
      );
    }
    final bytes = await file.readAsBytes();
    return decodeBytes(bytes);
  }

  static GribWindSample? windAtPoint({
    required GribDecodeResult result,
    required double lat,
    required double lon,
  }) {
    GribMessage? uMsg;
    GribMessage? vMsg;
    for (final m in result.messages) {
      if (m.isWindU) uMsg = m;
      if (m.isWindV) vMsg = m;
    }
    if (uMsg == null && vMsg == null) return null;

    final grid = (uMsg ?? vMsg)!.grid;
    final u = uMsg == null ? 0.0 : _sampleGrid(uMsg, lat, lon);
    final v = vMsg == null ? 0.0 : _sampleGrid(vMsg, lat, lon);
    if (u.isNaN || v.isNaN) return null;

    return GribWindSample(lat: lat, lon: lon, uMs: u, vMs: v);
  }

  static GribMessage? _parseMessage(Uint8List bytes) {
    final discipline = bytes[5];
    if (bytes[6] != 2) return null;

    var offset = 16;
    GribGrid? grid;
    int category = 0;
    int parameterNumber = 0;
    DateTime? referenceTime;
    var forecastHour = 0;
    double referenceValue = 0;
    var binaryScale = 0;
    var decimalScale = 0;
    var bitsPerValue = 0;
    var dataPoints = 0;
    Uint8List? packedData;

    while (offset + 5 <= bytes.length) {
      final sectionLength = _readUint32(bytes, offset);
      if (sectionLength < 5 || offset + sectionLength > bytes.length) {
        return null;
      }

      final sectionNumber = bytes[offset + 4];
      final sectionStart = offset + 5;
      final sectionEnd = offset + sectionLength;

      if (sectionNumber == 1) {
        if (sectionEnd - sectionStart >= 13) {
          final year = _readUint16(bytes, sectionStart + 7);
          final month = bytes[sectionStart + 9];
          final day = bytes[sectionStart + 10];
          final hour = bytes[sectionStart + 11];
          final minute = bytes[sectionStart + 12];
          referenceTime = DateTime.utc(year, month, day, hour, minute);
        }
      } else if (sectionNumber == 3) {
        grid = _parseGridSection(bytes, sectionStart, sectionEnd);
      } else if (sectionNumber == 4) {
        if (sectionEnd - sectionStart >= 10) {
          category = bytes[sectionStart + 4];
          parameterNumber = bytes[sectionStart + 5];
          if (sectionEnd - sectionStart >= 11) {
            forecastHour = _readUint16(bytes, sectionStart + 9);
          }
        }
      } else if (sectionNumber == 5) {
        if (sectionEnd - sectionStart >= 15) {
          dataPoints = _readUint32(bytes, sectionStart);
          referenceValue = _readFloat32(bytes, sectionStart + 6);
          binaryScale = _readInt16(bytes, sectionStart + 10);
          decimalScale = _readInt16(bytes, sectionStart + 12);
          bitsPerValue = bytes[sectionStart + 14];
        }
      } else if (sectionNumber == 7) {
        packedData = bytes.sublist(sectionStart, sectionEnd);
      } else if (sectionNumber == 8) {
        offset = sectionEnd;
        continue;
      }

      offset = sectionEnd;
    }

    if (grid == null ||
        referenceTime == null ||
        packedData == null ||
        dataPoints <= 0 ||
        bitsPerValue <= 0) {
      return null;
    }

    final values = _decodeSimplePacking(
      packed: packedData,
      count: dataPoints,
      bitsPerValue: bitsPerValue,
      referenceValue: referenceValue,
      binaryScale: binaryScale,
      decimalScale: decimalScale,
    );

    return GribMessage(
      discipline: discipline,
      category: category,
      parameterNumber: parameterNumber,
      parameterLabel: _parameterLabel(
        discipline: discipline,
        category: category,
        parameterNumber: parameterNumber,
      ),
      referenceTimeUtc: referenceTime,
      forecastHour: forecastHour,
      grid: grid,
      values: values,
    );
  }

  static GribGrid? _parseGridSection(
    Uint8List bytes,
    int start,
    int end,
  ) {
    if (end - start < 20) return null;

    final template = _readUint16(bytes, start + 6);
    if (template != 0) return null;

    var o = start + 8;
    o += 16; // earth shape block (shape + 3 scaled values)

    final ni = _readUint32(bytes, o);
    o += 4;
    final nj = _readUint32(bytes, o);
    o += 4;
    final lat1 = _gribAngle(_readInt32(bytes, o));
    o += 4;
    final lon1 = _gribAngle(_readInt32(bytes, o));
    o += 4;
    o += 1; // resolution flags
    final lat2 = _gribAngle(_readInt32(bytes, o));
    o += 4;
    final lon2 = _gribAngle(_readInt32(bytes, o));
    o += 4;
    final di = _gribAngle(_readInt32(bytes, o));
    o += 4;
    final dj = _gribAngle(_readInt32(bytes, o));
    o += 4;
    final scanMode = bytes[o];

    return GribGrid(
      ni: ni,
      nj: nj,
      lat1: lat1,
      lon1: lon1,
      lat2: lat2,
      lon2: lon2,
      di: di,
      dj: dj,
      scanMode: scanMode,
    );
  }

  static List<double> _decodeSimplePacking({
    required Uint8List packed,
    required int count,
    required int bitsPerValue,
    required double referenceValue,
    required int binaryScale,
    required int decimalScale,
  }) {
    final scale = math.pow(2.0, binaryScale).toDouble();
    final decimal = math.pow(10.0, decimalScale).toDouble();
    final out = List<double>.filled(count, double.nan);
    var bitPos = 0;

    for (var i = 0; i < count; i++) {
      final raw = _readBits(packed, bitPos, bitsPerValue);
      bitPos += bitsPerValue;
      out[i] = (referenceValue + raw * scale) / decimal;
    }

    return out;
  }

  static double _sampleGrid(GribMessage message, double lat, double lon) {
    final g = message.grid;
    if (message.values.length != g.ni * g.nj) return double.nan;

    final latMin = g.latMin;
    final lonMin = g.lonMin;
    final latMax = g.latMax;
    final lonMax = g.lonMax;

    if (lat < latMin || lat > latMax || lon < lonMin || lon > lonMax) {
      return double.nan;
    }

    final di = g.di == 0 ? (g.ni > 1 ? (g.lon2 - g.lon1) / (g.ni - 1) : 0) : g.di;
    final dj = g.dj == 0 ? (g.nj > 1 ? (g.lat2 - g.lat1) / (g.nj - 1) : 0) : g.dj;

    if (di == 0 || dj == 0) {
      return message.values.first;
    }

    final fi = (lon - lonMin) / di;
    final fj = (lat - latMin) / dj;

    final i0 = fi.floor().clamp(0, g.ni - 2);
    final j0 = fj.floor().clamp(0, g.nj - 2);
    final tx = fi - i0;
    final ty = fj - j0;

    double at(int i, int j) {
      final idx = j * g.ni + i;
      if (idx < 0 || idx >= message.values.length) return double.nan;
      return message.values[idx];
    }

    final v00 = at(i0, j0);
    final v10 = at(i0 + 1, j0);
    final v01 = at(i0, j0 + 1);
    final v11 = at(i0 + 1, j0 + 1);

    final top = v00 + (v10 - v00) * tx;
    final bottom = v01 + (v11 - v01) * tx;
    return top + (bottom - top) * ty;
  }

  static String _parameterLabel({
    required int discipline,
    required int category,
    required int parameterNumber,
  }) {
    if (discipline == 0 && category == 2) {
      return switch (parameterNumber) {
        2 => 'U wind',
        3 => 'V wind',
        _ => 'Momentum $parameterNumber',
      };
    }
    return 'D$discipline C$category P$parameterNumber';
  }

  static bool _isGribMagic(Uint8List bytes, int offset) =>
      bytes[offset] == 0x47 &&
      bytes[offset + 1] == 0x52 &&
      bytes[offset + 2] == 0x49 &&
      bytes[offset + 3] == 0x42;

  static double _gribAngle(int raw) => raw / 1e6;

  static int _readBits(Uint8List bytes, int bitOffset, int bitCount) {
    var value = 0;
    for (var b = 0; b < bitCount; b++) {
      final bitIndex = bitOffset + b;
      final byteIndex = bitIndex ~/ 8;
      final bitInByte = 7 - (bitIndex % 8);
      if (byteIndex >= bytes.length) break;
      final bit = (bytes[byteIndex] >> bitInByte) & 1;
      value = (value << 1) | bit;
    }
    return value;
  }

  static int _readUint16(Uint8List b, int o) =>
      (b[o] << 8) | b[o + 1];

  static int _readInt16(Uint8List b, int o) {
    final v = _readUint16(b, o);
    return v >= 0x8000 ? v - 0x10000 : v;
  }

  static int _readUint32(Uint8List b, int o) =>
      (b[o] << 24) | (b[o + 1] << 16) | (b[o + 2] << 8) | b[o + 3];

  static int _readInt32(Uint8List b, int o) {
    final v = _readUint32(b, o);
    return v >= 0x80000000 ? v - 0x100000000 : v;
  }

  static int _readUint64(Uint8List b, int o) {
    var v = 0;
    for (var i = 0; i < 8; i++) {
      v = (v << 8) | b[o + i];
    }
    return v;
  }

  static double _readFloat32(Uint8List b, int o) =>
      ByteData.sublistView(b, o, o + 4).getFloat32(0, Endian.big);
}
