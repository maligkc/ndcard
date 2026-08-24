import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../backend_providers.dart';
import '../domain/entities/app_notification.dart';

// autoDispose: bildirim sayfası her açıldığında taze veri çeker.
final notificationsProvider = FutureProvider.autoDispose<List<AppNotification>>((ref) {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) return Future.value(const <AppNotification>[]);
  return ref.read(notificationRepositoryProvider).getNotifications(userId);
});

// Bell butonu için: sayfada kalıcı, invalidate ile güncellenir.
final unreadNotificationCountProvider = FutureProvider<int>((ref) {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) return Future.value(0);
  return ref.read(notificationRepositoryProvider).getUnreadCount(userId);
});
