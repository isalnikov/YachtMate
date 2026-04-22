import 'aivdm_sentence.dart';

/// Результат склейки AIVDM перед декодированием полезной нагрузки.
class AssembledAisPayload {
  const AssembledAisPayload(this.armoredPayload, this.fillBits);

  final String armoredPayload;

  /// Хвостовые заполнительные биты последнего фрагмента (0–5).
  final int fillBits;
}

/// Склейка фрагментированных AIVDM в одну строку полезной нагрузки.
class AivdmAssembler {
  final Map<String, _FragBuf> _bufs = {};

  /// Если сообщение полное — результат, иначе `null`.
  AssembledAisPayload? assemble(AivdmSentence s) {
    if (s.fragmentsTotal <= 1) {
      return AssembledAisPayload(s.payload, s.fillBits);
    }
    final key = '${s.sequenceId}_${s.fragmentsTotal}';
    final buf =
        _bufs.putIfAbsent(key, () => _FragBuf(total: s.fragmentsTotal));

    buf.parts[s.fragmentIndex - 1] = _FragPart(payload: s.payload, fillBits: s.fillBits);
    if (!buf.complete) return null;

    final assembled = buf.concatenatedPayload;
    final tailFill = buf.tailFillBits;
    _bufs.remove(key);
    return AssembledAisPayload(assembled, tailFill);
  }

  void clear() => _bufs.clear();
}

class _FragPart {
  const _FragPart({required this.payload, required this.fillBits});
  final String payload;
  final int fillBits;
}

class _FragBuf {
  _FragBuf({required int total})
      : parts = List<_FragPart?>.filled(total, null),
        _total = total;

  final List<_FragPart?> parts;
  final int _total;

  bool get complete => parts.every((e) => e != null);

  String get concatenatedPayload => parts.map((e) => e!.payload).join();

  /// Заполнительные биты задаются только на последнем фрагменте (индекс `total`).
  int get tailFillBits => parts[_total - 1]!.fillBits;
}
