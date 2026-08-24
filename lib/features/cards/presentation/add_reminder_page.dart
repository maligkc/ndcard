import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/card_reminder.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../core/widgets/notification_providers.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../application/notification_service.dart';

class AddReminderPage extends HookConsumerWidget {
  const AddReminderPage({super.key, required this.cardId});

  final String cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final messageController = useTextEditingController();
    final selectedDate = useState(DateTime.now().add(const Duration(hours: 1)));
    final isSaving = useState(false);

    Future<void> save() async {
      final userId = ref.read(authStateChangesProvider).value?.id;
      if (userId == null) return;
      isSaving.value = true;
      try {
        await requestNotificationPermission();
        final reminder = await ref.read(noteRepositoryProvider).addReminder(CardReminder(
              id: '',
              userId: userId,
              cardId: cardId,
              remindAt: selectedDate.value,
              message: messageController.text.trim(),
            ));
        // Telefona yerel bildirim planla
        await scheduleReminderNotification(
          id: reminder.id.hashCode & 0x7fffffff,
          title: l10n.cardActionAddReminder,
          body: reminder.message.isNotEmpty ? reminder.message : l10n.cardActionAddReminder,
          scheduledAt: reminder.remindAt,
        );

        // Uygulama içi bildirim kutusuna ekle
        final dateStr =
            '${reminder.remindAt.day.toString().padLeft(2, '0')}.${reminder.remindAt.month.toString().padLeft(2, '0')}.${reminder.remindAt.year} '
            '${reminder.remindAt.hour.toString().padLeft(2, '0')}:${reminder.remindAt.minute.toString().padLeft(2, '0')}';
        await ref.read(notificationRepositoryProvider).addNotification(
              userId: userId,
              title: l10n.cardActionAddReminder,
              body: reminder.message.isNotEmpty
                  ? '${reminder.message} · $dateStr'
                  : dateStr,
            );
        ref.invalidate(notificationsProvider);
        ref.invalidate(unreadNotificationCountProvider);

        if (context.mounted) context.pop();
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      } finally {
        isSaving.value = false;
      }
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.cardActionAddReminder),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isSaving.value ? null : save,
          child: isSaving.value ? const CupertinoActivityIndicator() : Text(l10n.commonSave),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.dateAndTime,
                initialDateTime: selectedDate.value,
                minimumDate: DateTime.now(),
                onDateTimeChanged: (v) => selectedDate.value = v,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoTextField(
                controller: messageController,
                placeholder: l10n.reminderMessage,
                padding: const EdgeInsets.all(14),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
