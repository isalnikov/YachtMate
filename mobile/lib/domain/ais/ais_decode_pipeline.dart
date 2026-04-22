import 'aivdm_assembler.dart';
import 'aivdm_position_report.dart';
import 'aivdm_sentence.dart';

/// Цепочка: строка NMEA → [AisPositionReport].
class AisDecodePipeline {
  AisDecodePipeline() : _assembler = AivdmAssembler();

  final AivdmAssembler _assembler;

  /// Разбирает одну строку; если позиции нет — `null`.
  AisPositionReport? ingestLine(String line) {
    final sentence = AivdmSentence.tryParse(line);
    if (sentence == null) return null;

    final assembled = _assembler.assemble(sentence);
    if (assembled == null) return null;

    return AisPositionReport.decodeFromArmoredPayload(
      assembled.armoredPayload,
      fillBits: assembled.fillBits,
    );
  }

  void resetAssembler() {
    _assembler.clear();
  }
}
