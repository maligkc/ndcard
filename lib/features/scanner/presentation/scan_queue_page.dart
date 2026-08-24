import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../l10n/gen/app_localizations.dart';
import '../application/scan_queue_controller.dart';

class ScanQueuePage extends ConsumerWidget {
  const ScanQueuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final items = ref.watch(scanQueueProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.scanQueueTitle),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => context.pop(),
          child: Text(l10n.commonSave),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            for (final item in items)
              CupertinoListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(item.imageFile, width: 44, height: 44, fit: BoxFit.cover),
                ),
                title: Text(item.result?.fullName ?? l10n.scanQueuePending),
                subtitle: Text(_statusLabel(l10n, item.status)),
                trailing: item.status == ScanQueueStatus.scanning
                    ? const CupertinoActivityIndicator()
                    : item.status == ScanQueueStatus.done
                        ? const Icon(CupertinoIcons.chevron_right)
                        : item.status == ScanQueueStatus.error
                            ? const Icon(CupertinoIcons.exclamationmark_circle,
                                color: CupertinoColors.destructiveRed)
                            : const Icon(CupertinoIcons.clock),
                onTap: item.status == ScanQueueStatus.done
                    ? () {
                        ref.read(scanQueueProvider.notifier).removeItem(item.id);
                        context.push('/scanned-card/edit', extra: item.result);
                      }
                    : null,
              ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(AppLocalizations l10n, ScanQueueStatus status) {
    switch (status) {
      case ScanQueueStatus.pending:
        return l10n.scanQueuePending;
      case ScanQueueStatus.scanning:
        return l10n.scanLoading;
      case ScanQueueStatus.done:
        return l10n.scanQueueDone;
      case ScanQueueStatus.error:
        return l10n.commonError;
    }
  }
}
