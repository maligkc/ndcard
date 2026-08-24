import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import '../../../core/backend_providers.dart';
import '../../../core/widgets/notification_providers.dart';

final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

/// main.dart açılışında bir kere çağrılır. Ayarlar/bildirim merkezinin tam
/// kurulumu Faz 7'de yapılacak; burada yalnızca hatırlatıcıların
/// planlanabilmesi için gerekli altyapı kurulur.
Future<void> initNotifications() async {
  tzdata.initializeTimeZones();
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const iosSettings = DarwinInitializationSettings();
  const settings = InitializationSettings(android: androidSettings, iOS: iosSettings);
  await _plugin.initialize(settings: settings);
}

Future<void> requestNotificationPermission() async {
  await _plugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();
  await _plugin
      .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, badge: true, sound: true);
}

/// Zamanı geçmiş ve henüz bildirim kutusuna eklenmemiş hatırlatıcıları kontrol eder.
/// Uygulama açılışında ve arka plandan dönüşte çağrılır.
Future<void> checkDueReminders(WidgetRef ref, String userId) async {
  try {
    final noteRepo = ref.read(noteRepositoryProvider);
    final notifRepo = ref.read(notificationRepositoryProvider);
    final due = await noteRepo.getDueUnnotifiedReminders(userId);
    if (due.isEmpty) return;

    for (final reminder in due) {
      final dateStr =
          '${reminder.remindAt.toLocal().day.toString().padLeft(2, '0')}.${reminder.remindAt.toLocal().month.toString().padLeft(2, '0')}.${reminder.remindAt.toLocal().year} '
          '${reminder.remindAt.toLocal().hour.toString().padLeft(2, '0')}:${reminder.remindAt.toLocal().minute.toString().padLeft(2, '0')}';
      await notifRepo.addNotification(
        userId: userId,
        title: 'Hatırlatıcı',
        body: reminder.message.isNotEmpty
            ? '${reminder.message} · $dateStr'
            : dateStr,
      );
      await noteRepo.markReminderNotified(reminder.id);
    }

    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadNotificationCountProvider);
  } catch (e) {
    debugPrint('[Reminder] checkDueReminders hatası: $e');
  }
}

Future<void> scheduleReminderNotification({
  required int id,
  required String title,
  required String body,
  required DateTime scheduledAt,
}) async {
  await _plugin.zonedSchedule(
    id: id,
    title: title,
    body: body,
    scheduledDate: tz.TZDateTime.from(scheduledAt, tz.local),
    notificationDetails: const NotificationDetails(
      android: AndroidNotificationDetails('reminders', 'Hatırlatıcılar'),
      iOS: DarwinNotificationDetails(),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
  );
}
