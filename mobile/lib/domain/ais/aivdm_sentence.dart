/// Разбор строки `!AIVDM,...` (одна строка без завершающего CR/LF).
class AivdmSentence {
  const AivdmSentence({
    required this.fragmentsTotal,
    required this.fragmentIndex,
    required this.sequenceId,
    required this.channel,
    required this.payload,
    required this.fillBits,
  });

  final int fragmentsTotal;
  final int fragmentIndex;

  /// Идентификатор склейки многофрагментных сообщений (может быть пустым).
  final String sequenceId;
  final String channel;
  final String payload;
  final int fillBits;

  /// Возвращает полезную нагрузку или `null`, если строка не AIVDM.
  static AivdmSentence? tryParse(String line) {
    final trimmed = line.trim();
    if (!trimmed.startsWith('!AIVDM')) return null;

    final star = trimmed.lastIndexOf('*');
    final body = star >= 0 ? trimmed.substring(0, star) : trimmed;

    final parts = body.split(',');
    if (parts.length < 7) return null;

    final total = int.tryParse(parts[1]);
    final index = int.tryParse(parts[2]);
    if (total == null || index == null) return null;

    final payload = parts[5];
    final fillBits = int.tryParse(parts[6]) ?? 0;

    return AivdmSentence(
      fragmentsTotal: total,
      fragmentIndex: index,
      sequenceId: parts[3],
      channel: parts[4],
      payload: payload,
      fillBits: fillBits,
    );
  }
}
