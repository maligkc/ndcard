import '../entities/app_notification.dart';
import '../entities/user_settings.dart';

abstract interface class NotificationRepository {
  Future<List<AppNotification>> getNotifications(String userId);

  Future<int> getUnreadCount(String userId);

  Future<void> addNotification({
    required String userId,
    required String title,
    required String body,
  });

  Future<void> markRead(String id);

  Future<void> markAllRead(String userId);

  Future<void> clearAll(String userId);

  /// Bildirim/ses/titreşim tercihleri (user_settings tablosu).
  Future<UserSettings> getUserSettings(String userId);

  Future<void> updateUserSettings(UserSettings settings);
}
