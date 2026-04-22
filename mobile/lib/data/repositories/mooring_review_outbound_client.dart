import '../local/app_database.dart';

/// Исходящая очередь отзывов (Фаза 6). Реализацию с HTTP замените в провайдере при появлении API.
abstract class MooringReviewOutboundClient {
  Future<MooringReviewSubmitResult> submit(MooringReviewDraftRow draft);
}

/// Результат одной попытки отправки (без текста комментария — только статус).
class MooringReviewSubmitResult {
  const MooringReviewSubmitResult({required this.accepted});

  final bool accepted;
}

/// Пока сервера нет: принимаем черновики локально и снимаем с офлайн-очереди (политика MVP).
///
/// При подключении REST замените на клиент с `dart:convert` + `package:http`.
class LoopbackMooringReviewOutboundClient
    implements MooringReviewOutboundClient {
  const LoopbackMooringReviewOutboundClient();

  @override
  Future<MooringReviewSubmitResult> submit(MooringReviewDraftRow draft) async {
    return MooringReviewSubmitResult(accepted: draft.placeId.isNotEmpty);
  }
}
