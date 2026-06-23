import 'sos_emergency_type.dart';

/// Текст SOS без сетевого вызова — для SMS/email (Фаза 7.2).
class SosMessageFormatter {
  const SosMessageFormatter._();

  static String emergencyTypeLine(SosEmergencyType type) {
    return switch (type) {
      SosEmergencyType.medical => 'Medical emergency',
      SosEmergencyType.fire => 'Fire on board',
      SosEmergencyType.sinking => 'Sinking / taking on water',
      SosEmergencyType.manOverboard => 'Man overboard',
    };
  }

  static String build({
    required double lat,
    required double lon,
    required DateTime utc,
    required String vesselName,
    required bool testMode,
    SosEmergencyType emergencyType = SosEmergencyType.medical,
  }) {
    final prefix = testMode
        ? '[TEST SOS — NOT A REAL EMERGENCY]\n'
        : 'DISTRESS / SOS\n';
    final vessel = vesselName.trim().isEmpty
        ? 'Unknown vessel'
        : vesselName.trim();
    final body = StringBuffer(prefix)
      ..writeln('Type: ${emergencyTypeLine(emergencyType)}')
      ..writeln('Vessel: $vessel')
      ..writeln('Time UTC: ${utc.toUtc().toIso8601String()}')
      ..writeln(
        'Position (WGS84): ${lat.toStringAsFixed(5)}, ${lon.toStringAsFixed(5)}',
      );
    if (testMode) {
      body
        ..writeln()
        ..writeln('Test mode: no automatic distress message was sent.');
    }
    return body.toString();
  }
}
