import '../domain/entities/app_notification.dart';
import '../domain/entities/user_settings.dart';
import '../domain/repositories/notification_repository.dart';
import 'mappers.dart';
import 'supabase_client_provider.dart';

class SupabaseNotificationRepository implements NotificationRepository {
  @override
  Future<List<AppNotification>> getNotifications(String userId) async {
    final rows = await supabaseClient
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return (rows as List)
        .map((r) => appNotificationFromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<int> getUnreadCount(String userId) async {
    final rows = await supabaseClient
        .from('notifications')
        .select('id')
        .eq('user_id', userId)
        .eq('is_read', false);
    return (rows as List).length;
  }

  @override
  Future<void> addNotification({
    required String userId,
    required String title,
    required String body,
  }) async {
    await supabaseClient.from('notifications').insert({
      'user_id': userId,
      'title': title,
      'body': body,
    });
  }

  @override
  Future<void> markRead(String id) async {
    await supabaseClient.from('notifications').update({'is_read': true}).eq('id', id);
  }

  @override
  Future<void> markAllRead(String userId) async {
    await supabaseClient
        .from('notifications')
        .update({'is_read': true})
        .eq('user_id', userId);
  }

  @override
  Future<void> clearAll(String userId) async {
    await supabaseClient.from('notifications').delete().eq('user_id', userId);
  }

  @override
  Future<UserSettings> getUserSettings(String userId) async {
    final row = await supabaseClient
        .from('user_settings')
        .select()
        .eq('user_id', userId)
        .maybeSingle();
    if (row == null) return UserSettings(userId: userId);
    return userSettingsFromJson(row);
  }

  @override
  Future<void> updateUserSettings(UserSettings settings) async {
    await supabaseClient.from('user_settings').upsert(userSettingsToJson(settings));
  }
}
