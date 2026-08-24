import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/card_group.dart';

final groupsProvider = StreamProvider<List<CardGroup>>((ref) {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) return Stream.value(const <CardGroup>[]);
  return ref.watch(groupRepositoryProvider).watchGroups(userId);
});

class SmartGroupCounts {
  const SmartGroupCounts({
    required this.recentlyViewed,
    required this.recentlyAdded,
    required this.ungrouped,
  });

  final int recentlyViewed;
  final int recentlyAdded;
  final int ungrouped;
}

final smartGroupCountsProvider = FutureProvider<SmartGroupCounts>((ref) async {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) {
    return const SmartGroupCounts(recentlyViewed: 0, recentlyAdded: 0, ungrouped: 0);
  }
  final repo = ref.watch(groupRepositoryProvider);
  final results = await Future.wait([
    repo.countRecentlyViewed(userId),
    repo.countRecentlyAdded(userId),
    repo.countUngrouped(userId),
  ]);
  return SmartGroupCounts(
    recentlyViewed: results[0],
    recentlyAdded: results[1],
    ungrouped: results[2],
  );
});

final groupCardIdsProvider = FutureProvider.family<List<String>, String>((ref, groupId) {
  return ref.watch(groupRepositoryProvider).getCardIdsForGroup(groupId);
});
