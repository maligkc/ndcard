import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/domain/repositories/scanned_card_repository.dart';

final scannedCardsProvider =
    StreamProvider.family<List<ScannedCard>, ScannedCardSort>((ref, sort) {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) return Stream.value(const <ScannedCard>[]);
  return ref.watch(scannedCardRepositoryProvider).watchCards(userId, sort: sort);
});

final scannedCardByIdProvider = StreamProvider.family<ScannedCard?, String>((ref, id) {
  return ref.watch(scannedCardRepositoryProvider).watchCard(id);
});
