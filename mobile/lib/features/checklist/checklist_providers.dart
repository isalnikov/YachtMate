import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/local/app_database.dart' show ChecklistInstanceRow;
import '../../data/repositories/checklist_repository.dart';
import '../../domain/checklist/checklist_templates.dart';

final checklistInstanceProvider =
    FutureProvider.family<ChecklistInstanceRow, String>((
      ref,
      templateKey,
    ) async {
      final repo = ref.watch(checklistRepositoryProvider);
      final seeds = checklistSeedItemsEn()[templateKey]!
          .map((e) => ChecklistItemSeed(id: e.$1, label: e.$2))
          .toList();
      return repo.getOrCreateInstance(templateKey: templateKey, seeds: seeds);
    });
