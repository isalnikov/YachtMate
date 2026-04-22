import 'package:captain_wrongel/domain/ais/ais_decode_pipeline.dart';
import 'package:captain_wrongel/domain/ais/aivdm_sentence.dart';
import 'package:captain_wrongel/domain/ais/nmea_checksum.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('parses Class A position from fixture line', () {
    const line =
        '!AIVDM,1,1,,A,13HOI:0P0000VOHCMnHQKwvL05Ip,0*22';
    expect(nmeaChecksumValid(line), isTrue);

    final s = AivdmSentence.tryParse(line);
    expect(s, isNotNull);
    expect(s!.fragmentsTotal, 1);
    expect(s.payload, '13HOI:0P0000VOHCMnHQKwvL05Ip');

    final pipe = AisDecodePipeline();
    final pos = pipe.ingestLine(line);
    expect(pos, isNotNull);
    expect(pos!.messageType, 1);
    expect(pos.mmsi, 227006760);
    expect(pos.latitudeDeg, closeTo(34.02, 1e-5));
    expect(pos.longitudeDeg, closeTo(0.13138, 1e-5));
    expect(pos.sogKnots, 0);
    expect(pos.cogDegrees, closeTo(36.7, 1e-6));
  });
}
