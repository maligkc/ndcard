import '../entities/card_group.dart';

abstract interface class GroupRepository {
  Stream<List<CardGroup>> watchGroups(String userId);

  Future<CardGroup> createGroup({required String userId, required String name});

  Future<void> renameGroup({required String id, required String name});

  Future<void> deleteGroup(String id);

  Future<void> addCardToGroup({required String groupId, required String cardId});

  Future<void> removeCardFromGroup({required String groupId, required String cardId});

  Future<List<String>> getGroupIdsForCard(String cardId);

  Future<List<String>> getCardIdsForGroup(String groupId);

  /// Kullanıcının herhangi bir grubuna dahil olan tüm kart id'leri
  /// ("Grupsuz" akıllı grup listesini oluşturmak için).
  Future<Set<String>> getAllGroupedCardIds(String userId);

  /// Akıllı gruplar için sayaçlar: son 30 gün görüntülenen, son 7 gün eklenen, grupsuz.
  Future<int> countRecentlyViewed(String userId);

  Future<int> countRecentlyAdded(String userId);

  Future<int> countUngrouped(String userId);
}
