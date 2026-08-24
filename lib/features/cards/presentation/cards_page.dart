import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/domain/repositories/scanned_card_repository.dart';
import '../application/vcf_import.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../core/widgets/notification_bell_button.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../groups/presentation/assign_groups_sheet.dart';
import '../../scanner/application/scan_queue_controller.dart';
import '../../scanner/presentation/scan_queue_page.dart';
import '../application/bulk_actions.dart';
import 'dart:async';

import '../application/google_contacts_helper.dart';
import '../application/scanned_cards_provider.dart';
import '../application/share_scanned_card.dart';
import 'duplicate_cleanup_page.dart';
import 'high_accuracy_settings_page.dart';
import 'manage_sheet.dart';
import 'recycle_bin_page.dart';
import 'widgets/scanned_card_grid_tile.dart';
import 'widgets/scanned_card_list_tile.dart';

class CardsPage extends HookConsumerWidget {
  const CardsPage({super.key});

  bool _matchesQuery(ScannedCard card, String query) {
    if (query.isEmpty) return true;
    final q = query.toLowerCase();
    if ((card.fullName ?? '').toLowerCase().contains(q)) return true;
    if ((card.company ?? '').toLowerCase().contains(q)) return true;
    if ((card.jobTitle ?? '').toLowerCase().contains(q)) return true;
    for (final field in card.fields) {
      if ((field.fieldType == 'mobile' || field.fieldType == 'phone' || field.fieldType == 'email') &&
          field.value.toLowerCase().contains(q)) {
        return true;
      }
    }
    return false;
  }

  Future<void> _openCardActions(BuildContext context, WidgetRef ref, ScannedCard card) async {
    final l10n = AppLocalizations.of(context)!;
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(card.fullName ?? ''),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('call'),
            child: Text(l10n.cardActionCall),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('groups'),
            child: Text(l10n.cardActionManageGroups),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('note'),
            child: Text(l10n.cardActionAddNote),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('share'),
            child: Text(l10n.homeShareCard),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () => Navigator.of(context).pop('delete'),
            child: Text(l10n.commonDelete),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
      ),
    );
    if (!context.mounted) return;
    switch (action) {
      case 'call':
        final mobile = card.fields.where((f) => f.fieldType == 'mobile' || f.fieldType == 'phone');
        if (mobile.isNotEmpty) {
          await launchUrlString('tel:${mobile.first.value}');
        }
        break;
      case 'groups':
        await showAssignGroupsSheet(context, ref, cardId: card.id);
        break;
      case 'note':
        context.push('/scanned-card/${card.id}/note');
        break;
      case 'share':
        try {
          await shareScannedCard(card);
        } catch (e) {
          if (context.mounted) await showErrorDialog(context, e);
        }
        break;
      case 'delete':
        final confirmed = await showCupertinoDialog<bool>(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: Text(l10n.cardDeleteConfirmTitle),
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
            await ref.read(scannedCardRepositoryProvider).softDeleteCard(card.id);
          } catch (e) {
            if (context.mounted) await showErrorDialog(context, e);
          }
        }
        break;
    }
  }

  Future<void> _handleManageResult(
    BuildContext context,
    WidgetRef ref,
    ManageSheetResult result,
    ValueNotifier<ScannedCardSort> sort,
    ValueNotifier<bool> selectionMode,
    ValueNotifier<bool> gridView,
    ValueNotifier<Set<String>> selectedIds,
    ValueNotifier<String> query,
  ) async {
    if (result.sort != null) {
      sort.value = result.sort!;
      return;
    }
    switch (result.action) {
      case ManageAction.bulkSelect:
        selectionMode.value = true;
        break;
      case ManageAction.import:
        final l10n = AppLocalizations.of(context)!;
        final choice = await showCupertinoModalPopup<String>(
          context: context,
          builder: (ctx) => CupertinoActionSheet(
            title: Text(l10n.manageImport),
            actions: [
              CupertinoActionSheetAction(
                onPressed: () => Navigator.of(ctx).pop('image'),
                child: Text(l10n.importFromGallery),
              ),
              CupertinoActionSheetAction(
                onPressed: () => Navigator.of(ctx).pop('vcf'),
                child: Text(l10n.importFromVcf),
              ),
            ],
            cancelButton: CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(l10n.commonCancel),
            ),
          ),
        );
        if (!context.mounted) return;
        if (choice == 'image') {
          final files = await ImagePicker().pickMultiImage(imageQuality: 90);
          if (files.isEmpty || !context.mounted) return;
          ref.read(scanQueueProvider.notifier).addFiles(files.map((f) => File(f.path)).toList());
          Navigator.of(context).push(CupertinoPageRoute<void>(builder: (_) => const ScanQueuePage()));
        } else if (choice == 'vcf') {
          await _importVcf(context, ref);
        }
        break;
      case ManageAction.highAccuracy:
        Navigator.of(context).push(
          CupertinoPageRoute<void>(builder: (_) => const HighAccuracySettingsPage()),
        );
        break;
      case ManageAction.dedup:
        Navigator.of(context)
            .push(CupertinoPageRoute<void>(builder: (_) => const DuplicateCleanupPage()));
        break;
      case ManageAction.browse:
        gridView.value = !gridView.value;
        break;
      case ManageAction.recycleBin:
        Navigator.of(context)
            .push(CupertinoPageRoute<void>(builder: (_) => const RecycleBinPage()));
        break;
      case null:
        break;
    }
  }

  Widget _buildCardList(
    BuildContext context,
    WidgetRef ref,
    List<ScannedCard> filtered,
    ValueNotifier<Set<String>> selectedIds,
    ValueNotifier<bool> selectionMode,
  ) {
    // Flat items: String = section header, ScannedCard = kart
    final items = <Object>[];
    String? lastLetter;
    for (final card in filtered) {
      final raw = card.fullName?.trim() ?? '';
      final letter = raw.isNotEmpty ? raw[0].toUpperCase() : '#';
      if (letter != lastLetter) {
        items.add(letter);
        lastLetter = letter;
      }
      items.add(card);
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        if (item is String) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: Text(
              item,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            ),
          );
        }
        final card = item as ScannedCard;
        final isSelected = selectedIds.value.contains(card.id);
        return Row(
          children: [
            if (selectionMode.value)
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Icon(
                  isSelected
                      ? CupertinoIcons.checkmark_circle_fill
                      : CupertinoIcons.circle,
                  color: isSelected ? CupertinoColors.activeBlue : null,
                ),
              ),
            Expanded(
              child: ScannedCardListTile(
                card: card,
                onTap: () {
                  if (selectionMode.value) {
                    final next = {...selectedIds.value};
                    isSelected ? next.remove(card.id) : next.add(card.id);
                    selectedIds.value = next;
                  } else {
                    context.push('/scanned-card/${card.id}');
                  }
                },
                onMore: () => _openCardActions(context, ref, card),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _importVcf(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final userId = ref.read(authStateChangesProvider).value?.id;
      if (userId == null) return;
      final count = await pickAndImportVcf(
        userId,
        ref.read(scannedCardRepositoryProvider),
        ref.read(storageRepositoryProvider),
      );
      if (!context.mounted) return;
      if (count == -1) return; // iptal
      if (count == 0) {
        await showErrorDialog(context, StateError(l10n.importVcfEmpty));
        return;
      }
      await showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          title: Text(l10n.importSuccess(count)),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.commonOk),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  Future<void> _openBulkActions(
    BuildContext context,
    WidgetRef ref,
    List<ScannedCard> selectedCards,
    ValueNotifier<Set<String>> selectedIds,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (selectedCards.isEmpty) return;
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('group'),
            child: Text(l10n.bulkAssignGroup),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('csv'),
            child: Text(l10n.bulkExportCsv),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('vcard'),
            child: Text(l10n.bulkExportVCard),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('contacts'),
            child: Text(l10n.cardActionSaveToContacts),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('google_contacts'),
            child: const Text('Google Kişilere Ekle'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('share'),
            child: Text(l10n.homeShareCard),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('sms'),
            child: Text(l10n.bulkSms),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('email'),
            child: Text(l10n.bulkEmail),
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
    if (!context.mounted || action == null) return;
    try {
      switch (action) {
        case 'group':
          for (final card in selectedCards) {
            if (context.mounted) {
              await showAssignGroupsSheet(context, ref, cardId: card.id);
            }
          }
          break;
        case 'csv':
          await exportCardsAsCsv(selectedCards);
          break;
        case 'vcard':
          await exportCardsAsVCardZip(selectedCards);
          break;
        case 'contacts':
          await saveCardsToContactsBulk(selectedCards);
          break;
        case 'google_contacts':
          final count = await addCardsToGoogleContacts(selectedCards);
          if (context.mounted) {
            if (count == -1) {
              await showErrorDialog(context, StateError('Google hesabına giriş yapılamadı.'));
            } else {
              await showCupertinoDialog<void>(
                context: context,
                builder: (ctx) => CupertinoAlertDialog(
                  title: const Text('Google Kişilere Eklendi'),
                  content: Text('$count kişi Google Contacts\'a eklendi.'),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text('Tamam'),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
              );
            }
          }
          break;
        case 'share':
          await shareCardsBulk(selectedCards);
          break;
        case 'sms':
          await composeBulkSms(selectedCards);
          break;
        case 'email':
          await composeBulkEmail(selectedCards);
          break;
        case 'delete':
          for (final card in selectedCards) {
            await ref.read(scannedCardRepositoryProvider).softDeleteCard(card.id);
          }
          selectedIds.value = {};
          break;
      }
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final query = useState('');
    final sort = useState(ScannedCardSort.date);
    final selectionMode = useState(false);
    final gridView = useState(false);
    final selectedIds = useState<Set<String>>({});
    final cardsAsync = ref.watch(scannedCardsProvider(sort.value));

    // Uygulama açılışında Google bağlı değilse bir kez uyarı göster.
    useEffect(() {
      Future<void> checkGoogle() async {
        final signedIn = await isGoogleSignedIn();
        if (!signedIn && context.mounted) {
          await showCupertinoDialog<void>(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: const Text('Google Hesabı Gerekli'),
              content: const Text(
                'Kartvizitleri otomatik olarak Google Kişilerinize eklemek için '
                'Google hesabınızla giriş yapmanız gerekmektedir.\n\n'
                'Ayarlar → Hesap bölümünden Google hesabınızı bağlayabilirsiniz.',
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text('Daha Sonra'),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
                CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await ensureGoogleSignedIn();
                  },
                  child: const Text('Google ile Bağlan'),
                ),
              ],
            ),
          );
        }
      }
      unawaited(checkGoogle());
      return null;
    }, const []);

    final allCards = cardsAsync.value ?? [];
    final filtered = allCards.where((c) => _matchesQuery(c, query.value)).toList();
    final allSelected =
        filtered.isNotEmpty && filtered.every((c) => selectedIds.value.contains(c.id));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: selectionMode.value
            ? CupertinoButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  selectionMode.value = false;
                  selectedIds.value = {};
                },
                child: Text(l10n.commonCancel),
              )
            : const NotificationBellButton(),
        middle: Text(l10n.tabCards),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () {
            if (selectionMode.value && allSelected) {
              // Tüm seçimleri kaldır
              selectedIds.value = {};
            } else {
              // Seçim moduna gir ve tümünü seç
              selectionMode.value = true;
              selectedIds.value = filtered.map((c) => c.id).toSet();
            }
          },
          child: Text(selectionMode.value && allSelected ? 'Seçimi Kaldır' : 'Tümünü Seç'),
        ),
      ),
      child: SafeArea(
        child: cardsAsync.when(
          data: (allCards) {
            final filtered = allCards.where((c) => _matchesQuery(c, query.value)).toList();
            final selectedCards =
                filtered.where((c) => selectedIds.value.contains(c.id)).toList();
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: CupertinoSearchTextField(
                    placeholder: l10n.cardsSearchPlaceholder,
                    onChanged: (v) => query.value = v,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.cardsAllCardsCount(filtered.length),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        onPressed: () => context.push('/groups'),
                        child: Text(l10n.cardsGroupsButton),
                      ),
                      CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        onPressed: () async {
                          final result =
                              await showManageSheet(context, currentSort: sort.value);
                          if (result != null && context.mounted) {
                            await _handleManageResult(
                                context, ref, result, sort, selectionMode, gridView, selectedIds, query);
                          }
                        },
                        child: Text(l10n.cardsManageButton),
                      ),
                    ],
                  ),
                ),
                if (selectionMode.value)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(l10n.bulkSelectedCount(selectedIds.value.length)),
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () =>
                              _openBulkActions(context, ref, selectedCards, selectedIds),
                          child: Text(l10n.bulkActions),
                        ),
                      ],
                    ),
                  ),
                Expanded(
                  child: filtered.isEmpty
                      ? EmptyState(
                          icon: CupertinoIcons.rectangle_stack,
                          title: l10n.cardsEmptyTitle,
                          message: l10n.cardsEmptyMessage,
                        )
                      : gridView.value
                          ? GridView.builder(
                              padding: const EdgeInsets.all(12),
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 0.9,
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                              ),
                              itemCount: filtered.length,
                              itemBuilder: (context, index) {
                                final card = filtered[index];
                                return ScannedCardGridTile(
                                  card: card,
                                  selected: selectedIds.value.contains(card.id),
                                  selectionMode: selectionMode.value,
                                  onTap: () {
                                    if (selectionMode.value) {
                                      final next = {...selectedIds.value};
                                      next.contains(card.id)
                                          ? next.remove(card.id)
                                          : next.add(card.id);
                                      selectedIds.value = next;
                                    } else {
                                      context.push('/scanned-card/${card.id}');
                                    }
                                  },
                                );
                              },
                            )
                          : _buildCardList(context, ref, filtered, selectedIds, selectionMode),
                ),
              ],
            );
          },
          loading: () => const Center(child: CupertinoActivityIndicator()),
          error: (_, _) => Center(child: Text(l10n.commonError)),
        ),
      ),
    );
  }
}
