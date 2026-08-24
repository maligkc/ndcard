import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../l10n/gen/app_localizations.dart';
import '../backend_providers.dart';
import 'empty_state.dart';
import 'notification_providers.dart';

class NotificationsPage extends ConsumerWidget {
  const NotificationsPage({super.key});

  void _refresh(WidgetRef ref) {
    ref.invalidate(notificationsProvider);
    ref.invalidate(unreadNotificationCountProvider);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final notificationsAsync = ref.watch(notificationsProvider);
    final userId = ref.watch(authStateChangesProvider).value?.id;

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.notificationsTitle),
        trailing: userId == null
            ? null
            : CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () async {
                  await ref.read(notificationRepositoryProvider).clearAll(userId);
                  _refresh(ref);
                },
                child: Text(l10n.notificationsClearAll),
              ),
      ),
      child: SafeArea(
        child: notificationsAsync.when(
          data: (notifications) => notifications.isEmpty
              ? EmptyState(
                  icon: CupertinoIcons.bell,
                  title: l10n.notificationsEmpty,
                  message: '',
                )
              : ListView(
                  children: [
                    for (final n in notifications)
                      CupertinoListTile(
                        leading: Icon(
                          n.isRead ? CupertinoIcons.circle : CupertinoIcons.circle_fill,
                          size: 12,
                          color: n.isRead
                              ? CupertinoColors.systemGrey4
                              : CupertinoColors.activeBlue,
                        ),
                        title: Text(
                          n.title,
                          style: TextStyle(
                            fontWeight:
                                n.isRead ? FontWeight.normal : FontWeight.w600,
                          ),
                        ),
                        subtitle: n.body.isNotEmpty ? Text(n.body) : null,
                        onTap: () async {
                          if (!n.isRead) {
                            await ref
                                .read(notificationRepositoryProvider)
                                .markRead(n.id);
                            _refresh(ref);
                          }
                        },
                      ),
                  ],
                ),
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, _) => Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.commonError),
                const SizedBox(height: 12),
                CupertinoButton(
                  onPressed: () => _refresh(ref),
                  child: const Text('Yenile'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
