import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/digital_card.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../core/widgets/notification_bell_button.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../digital_card/application/digital_card_providers.dart';
import '../../digital_card/application/share_vcard.dart';
import '../../digital_card/presentation/digital_card_recycle_bin_page.dart';
import '../../digital_card/presentation/widgets/digital_card_view.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  Future<void> _openCardActions(BuildContext context, WidgetRef ref, DigitalCard card) async {
    final l10n = AppLocalizations.of(context)!;
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(card.fullName),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('share'),
            child: Text(l10n.homeShareCard),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('edit'),
            child: Text(l10n.commonEdit),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop('delete'),
            child: Text(l10n.commonDelete),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
      ),
    );
    if (!context.mounted) return;
    if (action == 'share') {
      try {
        await shareDigitalCardAsVCard(card);
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      }
    } else if (action == 'edit') {
      if (context.mounted) context.push('/digital-card/edit/${card.id}');
    } else if (action == 'delete') {
      final confirmed = await showCupertinoDialog<bool>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(l10n.commonDelete),
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
      if (confirmed == true && context.mounted) {
        try {
          await ref.read(digitalCardRepositoryProvider).deleteCard(card.id);
        } catch (e) {
          if (context.mounted) await showErrorDialog(context, e);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cardsAsync = ref.watch(digitalCardsProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: const NotificationBellButton(),
        middle: Text(l10n.tabHome),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).push(
                CupertinoPageRoute<void>(
                  builder: (_) => const DigitalCardRecycleBinPage(),
                ),
              ),
              child: const Icon(CupertinoIcons.trash),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => context.push('/digital-card/new'),
              child: const Icon(CupertinoIcons.add),
            ),
          ],
        ),
      ),
      child: SafeArea(
        child: cardsAsync.when(
          data: (cards) {
            if (cards.isEmpty) {
              return EmptyState(
                icon: CupertinoIcons.person_crop_rectangle,
                title: l10n.homeEmptyTitle,
                message: l10n.homeEmptyMessage,
                actionLabel: l10n.homeCreateCardButton,
                onAction: () => context.push('/digital-card/new'),
              );
            }
            final sorted = [...cards]..sort((a, b) => b.isDefault ? 1 : (a.isDefault ? -1 : 0));
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sorted.length,
              itemBuilder: (context, index) {
                final card = sorted[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GestureDetector(
                    onTap: () => _openCardActions(context, ref, card),
                    child: DigitalCardView(card: card),
                  ),
                );
              },
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (error, _) => Center(child: Text(l10n.commonError)),
        ),
      ),
    );
  }
}
