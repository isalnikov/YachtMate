import 'package:captain_wrongel/domain/distress/sos_message_formatter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SosMessageFormatter test mode prefix', () {
    final s = SosMessageFormatter.build(
      lat: 36.6,
      lon: 29.1,
      utc: DateTime.utc(2025, 1, 1, 12),
      vesselName: 'X',
      testMode: true,
    );
    expect(s, contains('TEST'));
    expect(s, contains('X'));
  });
}
