import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/user_settings.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';

class NotificationsSettingsPage extends HookConsumerWidget {
  const NotificationsSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userId = ref.watch(authStateChangesProvider).value?.id;
    final settings = useState<UserSettings?>(null);
    final loadedOnce = useState(false);

    if (!loadedOnce.value && userId != null) {
      loadedOnce.value = true;
      ref.read(notificationRepositoryProvider).getUserSettings(userId).then((value) {
        if (context.mounted) settings.value = value;
      });
    }

    Future<void> update(UserSettings Function(UserSettings) updater) async {
      final current = settings.value;
      if (current == null) return;
      final updated = updater(current);
      settings.value = updated;
      try {
        await ref.read(notificationRepositoryProvider).updateUserSettings(updated);
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      }
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.settingsNotifications)),
      child: SafeArea(
        child: settings.value == null
            ? const Center(child: CupertinoActivityIndicator())
            : ListView(
                children: [
                  CupertinoListSection.insetGrouped(
                    children: [
                      CupertinoListTile(
                        title: Text(l10n.notificationsEnabled),
                        trailing: CupertinoSwitch(
                          value: settings.value!.notificationsEnabled,
                          onChanged: (v) =>
                              update((s) => s.copyWith(notificationsEnabled: v)),
                        ),
                      ),
                      CupertinoListTile(
                        title: Text(l10n.notificationsSound),
                        trailing: CupertinoSwitch(
                          value: settings.value!.sound,
                          onChanged: (v) => update((s) => s.copyWith(sound: v)),
                        ),
                      ),
                      CupertinoListTile(
                        title: Text(l10n.notificationsVibrate),
                        trailing: CupertinoSwitch(
                          value: settings.value!.vibrate,
                          onChanged: (v) => update((s) => s.copyWith(vibrate: v)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}
