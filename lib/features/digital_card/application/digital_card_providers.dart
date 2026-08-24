import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/digital_card.dart';

final digitalCardsProvider = StreamProvider<List<DigitalCard>>((ref) {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) return Stream.value(const <DigitalCard>[]);
  return ref.watch(digitalCardRepositoryProvider).watchCards(userId);
});

final digitalCardByIdProvider = FutureProvider.family<DigitalCard?, String>((ref, id) {
  return ref.watch(digitalCardRepositoryProvider).getCard(id);
});

final deletedDigitalCardsProvider = StreamProvider<List<DigitalCard>>((ref) {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) return Stream.value(const <DigitalCard>[]);
  return ref.watch(digitalCardRepositoryProvider).watchDeletedCards(userId);
});
