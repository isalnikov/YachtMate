import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/local/app_database.dart';

/// All chart regions from Drift (step 48).
final chartRegionsProvider = FutureProvider.autoDispose<List<ChartRegionRow>>((
  ref,
) async {
  final repo = ref.watch(chartRegionRepositoryProvider);
  final rows = await repo.all();
  rows.sort((a, b) => b.installedAt.compareTo(a.installedAt));
  return rows;
});
