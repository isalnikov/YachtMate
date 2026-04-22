import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/local/app_database.dart';

final logbookEntriesProvider =
    FutureProvider.autoDispose<List<LogbookEntryRow>>((ref) async {
      return ref.read(logbookRepositoryProvider).entriesNewestFirst();
    });
