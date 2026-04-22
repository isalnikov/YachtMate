import 'payload_bits.dart';

/// Фиксация класса A (сообщения типов 1, 2, 3 — одинаковая разметка полей).
class AisPositionReport {
  const AisPositionReport({
    required this.messageType,
    required this.mmsi,
    required this.latitudeDeg,
    required this.longitudeDeg,
    required this.sogKnots,
    required this.cogDegrees,
    required this.trueHeadingDeg,
  });

  final int messageType;
  final int mmsi;
  final double latitudeDeg;
  final double longitudeDeg;

  /// Скорость над грунтом, узлы.
  final double sogKnots;

  /// Путевой угол, ° \[0,360).
  final double cogDegrees;

  /// Истинный курс (511 = недоступно).
  final int trueHeadingDeg;

  /// Разбирает типы 1/2/3 из полного битового массива полезной нагрузки (≥168 бит).
  static AisPositionReport? decodeClassAPosition(List<bool> bits) {
    if (bits.length < 168) return null;
    final t = readUnsignedBits(bits, 0, 6);
    if (t != 1 && t != 2 && t != 3) return null;

    final mmsi = readUnsignedBits(bits, 8, 30);
    final sogRaw = readUnsignedBits(bits, 50, 10);
    final lonRaw = readSignedBits(bits, 61, 28);
    final latRaw = readSignedBits(bits, 89, 27);
    final cogRaw = readUnsignedBits(bits, 116, 12);
    final hdgRaw = readUnsignedBits(bits, 128, 9);

    const scale = 600000.0;
    const unavailableLat = 91 * 600000;
    const unavailableLon = 181 * 600000;

    if (latRaw.abs() >= unavailableLat || lonRaw.abs() >= unavailableLon) {
      return null;
    }

    return AisPositionReport(
      messageType: t,
      mmsi: mmsi,
      latitudeDeg: latRaw / scale,
      longitudeDeg: lonRaw / scale,
      sogKnots: sogRaw / 10.0,
      cogDegrees: (cogRaw == 3600) ? 0.0 : cogRaw / 10.0,
      trueHeadingDeg: hdgRaw,
    );
  }

  /// Декодирует из полезной нагрузки AIVDM; [fillBits] — хвостовые биты упаковки последнего символа.
  static AisPositionReport? decodeFromArmoredPayload(
    String payload, {
    int fillBits = 0,
  }) {
    final raw = aisArmoringToBits(payload);
    final bits = fillBits > 0 && raw.length >= fillBits
        ? raw.sublist(0, raw.length - fillBits)
        : raw;
    return decodeClassAPosition(bits);
  }
}
