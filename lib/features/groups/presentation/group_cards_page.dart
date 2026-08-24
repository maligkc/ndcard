import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/widgets/empty_state.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../cards/presentation/widgets/scanned_card_list_tile.dart';
import '../application/group_cards_provider.dart';

class GroupCardsPage extends ConsumerWidget {
  const GroupCardsPage({super.key, this.title, this.groupId, this.smartType});

  final String? title;
  final String? groupId;
  final String? smartType;

  String _resolveTitle(AppLocalizations l10n) {
    if (title != null) return title!;
    switch (smartType) {
      case 'recently_viewed':
        return l10n.groupsRecentlyViewed;
      case 'recently_added':
        return l10n.groupsRecentlyAdded;
      case 'ungrouped':
        return l10n.groupsUngrouped;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cardsAsync = groupId != null
        ? ref.watch(groupFilteredCardsProvider(groupId!))
        : ref.watch(smartFilteredCardsProvider(smartType ?? ''));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(_resolveTitle(l10n))),
      child: SafeArea(
        child: cardsAsync.when(
          data: (cards) => cards.isEmpty
              ? EmptyState(
                  icon: CupertinoIcons.rectangle_stack,
                  title: l10n.cardsEmptyTitle,
                  message: l10n.cardsEmptyMessage,
                )
              : ListView.builder(
                  itemCount: cards.length,
                  itemBuilder: (context, index) {
                    final card = cards[index];
                    return ScannedCardListTile(
                      card: card,
                      onTap: () => context.push('/scanned-card/${card.id}'),
                      onMore: () {},
                    );
                  },
                ),
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonError)),
        ),
      ),
    );
  }
}
