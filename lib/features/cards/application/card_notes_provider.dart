import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/card_note.dart';

final cardNotesProvider = FutureProvider.family<List<CardNote>, String>((ref, cardId) {
  return ref.watch(noteRepositoryProvider).getNotesForCard(cardId);
});
