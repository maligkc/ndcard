import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../digital_card/application/digital_card_providers.dart';
import '../../digital_card/application/share_vcard.dart';
import '../../digital_card/presentation/widgets/digital_card_view.dart';

class AccountPage extends ConsumerWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final user = ref.watch(authStateChangesProvider).value;
    final cardsAsync = ref.watch(digitalCardsProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.settingsAccount)),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  leading: const Icon(CupertinoIcons.person_crop_circle, size: 32),
                  title: Text(user?.email ?? ''),
                ),
              ],
            ),
            cardsAsync.when(
              data: (cards) {
                if (cards.isEmpty) return const SizedBox.shrink();
                final defaultCard = cards.firstWhere(
                  (c) => c.isDefault,
                  orElse: () => cards.first,
                );
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: DigitalCardView(card: defaultCard),
                    ),
                    CupertinoListSection.insetGrouped(
                      children: [
                        CupertinoListTile(
                          title: Text(l10n.commonEdit),
                          leading: const Icon(CupertinoIcons.pencil),
                          onTap: () => context.push('/digital-card/edit/${defaultCard.id}'),
                        ),
                        CupertinoListTile(
                          title: Text(l10n.homeShareCard),
                          leading: const Icon(CupertinoIcons.share),
                          onTap: () async {
                            try {
                              await shareDigitalCardAsVCard(defaultCard);
                            } catch (e) {
                              if (context.mounted) await showErrorDialog(context, e);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                );
              },
              loading: () => const Center(child: CupertinoActivityIndicator()),
              error: (_, _) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
