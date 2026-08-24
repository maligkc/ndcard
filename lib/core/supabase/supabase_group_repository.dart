import '../domain/entities/card_group.dart';
import '../domain/repositories/group_repository.dart';
import 'mappers.dart';
import 'supabase_client_provider.dart';

/// Gruplar doğrudan Supabase üzerinden okunur/yazılır; scanned_cards'ın
/// aksine offline kuyruklama uygulanmaz (düşük yazma sıklığı, basit CRUD).
class SupabaseGroupRepository implements GroupRepository {
  @override
  Stream<List<CardGroup>> watchGroups(String userId) {
    return supabaseClient
        .from('card_groups')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .asyncMap((rows) async {
      final groups = <CardGroup>[];
      for (final row in rows) {
        final members = await supabaseClient
            .from('card_group_members')
            .select('card_id')
            .eq('group_id', row['id'] as String);
        groups.add(cardGroupFromJson(row, cardCount: (members as List).length));
      }
      return groups;
    });
  }

  @override
  Future<CardGroup> createGroup({required String userId, required String name}) async {
    final row = await supabaseClient
        .from('card_groups')
        .insert({'user_id': userId, 'name': name})
        .select()
        .single();
    return cardGroupFromJson(row);
  }

  @override
  Future<void> renameGroup({required String id, required String name}) async {
    await supabaseClient.from('card_groups').update({'name': name}).eq('id', id);
  }

  @override
  Future<void> deleteGroup(String id) async {
    await supabaseClient.from('card_groups').delete().eq('id', id);
  }

  @override
  Future<void> addCardToGroup({required String groupId, required String cardId}) async {
    await supabaseClient
        .from('card_group_members')
        .upsert({'group_id': groupId, 'card_id': cardId});
  }

  @override
  Future<void> removeCardFromGroup({required String groupId, required String cardId}) async {
    await supabaseClient
        .from('card_group_members')
        .delete()
        .eq('group_id', groupId)
        .eq('card_id', cardId);
  }

  @override
  Future<List<String>> getGroupIdsForCard(String cardId) async {
    final rows = await supabaseClient
        .from('card_group_members')
        .select('group_id')
        .eq('card_id', cardId);
    return (rows as List).map((r) => r['group_id'] as String).toList();
  }

  @override
  Future<List<String>> getCardIdsForGroup(String groupId) async {
    final rows = await supabaseClient
        .from('card_group_members')
        .select('card_id')
        .eq('group_id', groupId);
    return (rows as List).map((r) => r['card_id'] as String).toList();
  }

  @override
  Future<int> countRecentlyViewed(String userId) async {
    final since = DateTime.now().subtract(const Duration(days: 30)).toIso8601String();
    final rows = await supabaseClient
        .from('scanned_cards')
        .select('id')
        .eq('user_id', userId)
        .gte('last_viewed_at', since)
        .isFilter('deleted_at', null);
    return (rows as List).length;
  }

  @override
  Future<int> countRecentlyAdded(String userId) async {
    final since = DateTime.now().subtract(const Duration(days: 7)).toIso8601String();
    final rows = await supabaseClient
        .from('scanned_cards')
        .select('id')
        .eq('user_id', userId)
        .gte('created_at', since)
        .isFilter('deleted_at', null);
    return (rows as List).length;
  }

  @override
  Future<int> countUngrouped(String userId) async {
    final allCards = await supabaseClient
        .from('scanned_cards')
        .select('id')
        .eq('user_id', userId)
        .isFilter('deleted_at', null);
    final groupedIds = await getAllGroupedCardIds(userId);
    return (allCards as List).where((c) => !groupedIds.contains(c['id'] as String)).length;
  }

  @override
  Future<Set<String>> getAllGroupedCardIds(String userId) async {
    final rows = await supabaseClient
        .from('card_group_members')
        .select('card_id, card_groups!inner(user_id)')
        .eq('card_groups.user_id', userId);
    return (rows as List).map((r) => r['card_id'] as String).toSet();
  }
}
