import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../application/digital_card_providers.dart';
import 'widgets/digital_card_view.dart';

class DigitalCardRecycleBinPage extends ConsumerWidget {
  const DigitalCardRecycleBinPage({super.key});

  Future<void> _restore(BuildContext context, WidgetRef ref, String id) async {
    try {
      await ref.read(digitalCardRepositoryProvider).restoreCard(id);
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  Future<void> _permanentlyDelete(
      BuildContext context, WidgetRef ref, String id, String name) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(l10n.recycleBinPermanentDeleteTitle),
        content: Text(name),
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
    if (confirmed == true && context.mounted) {
      try {
        await ref.read(digitalCardRepositoryProvider).permanentlyDeleteCard(id);
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      }
    }
  }

  String _deletedAgo(AppLocalizations l10n, DateTime? deletedAt) {
    if (deletedAt == null) return '';
    final days = DateTime.now().difference(deletedAt).inDays;
    final remaining = 30 - days;
    if (remaining <= 0) return l10n.recycleBinPermanentDeleteTitle;
    return '${remaining}d kaldı';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cardsAsync = ref.watch(deletedDigitalCardsProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.recycleBinTitle),
      ),
      child: SafeArea(
        child: cardsAsync.when(
          data: (cards) {
            if (cards.isEmpty) {
              return EmptyState(
                icon: CupertinoIcons.trash,
                title: l10n.recycleBinEmpty,
                message: l10n.recycleBinEmptyMessage,
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cards.length,
              itemBuilder: (context, index) {
                final card = cards[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DigitalCardView(card: card),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              _deletedAgo(l10n, card.deletedAt),
                              style: TextStyle(
                                fontSize: 12,
                                color: CupertinoColors.secondaryLabel.resolveFrom(context),
                              ),
                            ),
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => _restore(context, ref, card.id),
                            child: Text(
                              l10n.recycleBinRestore,
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.activeBlue.resolveFrom(context),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: () => _permanentlyDelete(
                                context, ref, card.id, card.fullName),
                            child: Text(
                              l10n.commonDelete,
                              style: TextStyle(
                                fontSize: 14,
                                color: CupertinoColors.destructiveRed.resolveFrom(context),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, __) => Center(child: Text(l10n.commonError)),
        ),
      ),
    );
  }
}
