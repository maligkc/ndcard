import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';

final _deletedCardsProvider = StreamProvider<List<ScannedCard>>((ref) {
  final userId = ref.watch(authStateChangesProvider).value?.id;
  if (userId == null) return Stream.value(const <ScannedCard>[]);
  return ref
      .watch(scannedCardRepositoryProvider)
      .watchCards(userId, includeDeleted: true)
      .map((cards) => cards.where((c) => c.isDeleted).toList());
});

class RecycleBinPage extends ConsumerWidget {
  const RecycleBinPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cardsAsync = ref.watch(_deletedCardsProvider);

    Future<void> restore(ScannedCard card) async {
      try {
        await ref.read(scannedCardRepositoryProvider).restoreCard(card.id);
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      }
    }

    Future<void> deleteForever(ScannedCard card) async {
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(l10n.recycleBinPermanentDeleteTitle),
          content: Text(l10n.cardDeleteConfirmMessage),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.commonCancel),
              onPressed: () => Navigator.of(ctx).pop(false),
            ),
            CupertinoDialogAction(
              isDestructiveAction: true,
              child: Text(l10n.commonDelete),
              onPressed: () => Navigator.of(ctx).pop(true),
            ),
          ],
        ),
      );
      if (confirmed != true) return;
      try {
        await ref.read(scannedCardRepositoryProvider).permanentlyDeleteCard(card.id);
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      }
    }

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.recycleBinTitle)),
      child: SafeArea(
        child: cardsAsync.when(
          data: (cards) => cards.isEmpty
              ? EmptyState(
                  icon: CupertinoIcons.trash,
                  title: l10n.recycleBinEmpty,
                  message: l10n.recycleBinEmptyMessage,
                )
              : ListView(
                  children: [
                    for (final card in cards)
                      CupertinoListTile(
                        title: Text(card.fullName ?? ''),
                        subtitle: Text(card.company ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => restore(card),
                              child: Text(l10n.recycleBinRestore),
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: () => deleteForever(card),
                              child: const Icon(CupertinoIcons.delete_solid,
                                  color: CupertinoColors.destructiveRed),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonError)),
        ),
      ),
    );
  }
}
