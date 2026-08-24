import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/scanned_card.dart';

final smartFilteredCardsProvider =
    FutureProvider.family<List<ScannedCard>, String>((ref, type) async {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) return const [];
  final allCards = await ref.watch(scannedCardRepositoryProvider).watchCards(userId).first;
  switch (type) {
    case 'recently_viewed':
      final cutoff = DateTime.now().subtract(const Duration(days: 30));
      return allCards
          .where((c) => c.lastViewedAt != null && c.lastViewedAt!.isAfter(cutoff))
          .toList();
    case 'recently_added':
      final cutoff = DateTime.now().subtract(const Duration(days: 7));
      return allCards.where((c) => c.createdAt != null && c.createdAt!.isAfter(cutoff)).toList();
    case 'ungrouped':
      final groupedIds = await ref.watch(groupRepositoryProvider).getAllGroupedCardIds(userId);
      return allCards.where((c) => !groupedIds.contains(c.id)).toList();
    default:
      return const [];
  }
});

final groupFilteredCardsProvider =
    FutureProvider.family<List<ScannedCard>, String>((ref, groupId) async {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) return const [];
  final cardIds = (await ref.watch(groupRepositoryProvider).getCardIdsForGroup(groupId)).toSet();
  final allCards = await ref.watch(scannedCardRepositoryProvider).watchCards(userId).first;
  return allCards.where((c) => cardIds.contains(c.id)).toList();
});
