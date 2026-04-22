import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers.dart';
import '../../data/local/app_database.dart';
import '../../data/repositories/mooring_repository.dart';

final mooringRepositoryProvider = Provider<MooringRepository>(
  (ref) => MooringRepository(ref.watch(databaseProvider)),
);

final mooringSeedFutureProvider = FutureProvider<void>((ref) async {
  await ref.read(mooringRepositoryProvider).ensureSeedLoaded();
});

/// Статический каталог после сида; без долгого stream — проще для тестов и офлайн MVP.
final mooringPlacesProvider = FutureProvider<List<MooringPlaceRow>>((ref) async {
  await ref.watch(mooringSeedFutureProvider.future);
  return ref.read(mooringRepositoryProvider).allPlaces();
});
