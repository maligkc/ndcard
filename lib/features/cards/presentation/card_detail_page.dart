import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/card_note.dart';
import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/utils/supported_platforms.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../../core/widgets/toast.dart';
import '../application/card_notes_provider.dart';
import '../application/contacts_helper.dart';
import '../application/google_contacts_helper.dart';
import '../application/scanned_cards_provider.dart';
import '../application/share_scanned_card.dart';

String _addressMapsUrl(String value) =>
    'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(value)}';

Future<void> _openField(BuildContext context, ScannedCardField field) async {
  switch (field.fieldType) {
    case 'mobile':
    case 'phone':
    case 'fax':
      await launchUrlString(Uri(scheme: 'tel', path: field.value).toString());
      return;
    case 'email':
      await launchUrlString(Uri(scheme: 'mailto', path: field.value).toString());
      return;
    case 'address':
      await launchUrlString(_addressMapsUrl(field.value), mode: LaunchMode.externalApplication);
      return;
    default:
      final value = field.value.startsWith('http') ? field.value : 'https://${field.value}';
      await launchUrlString(value, mode: LaunchMode.externalApplication);
  }
}

class CardDetailPage extends HookConsumerWidget {
  const CardDetailPage({super.key, required this.cardId});

  final String cardId;

  Future<void> _openMoreActions(BuildContext context, WidgetRef ref, ScannedCard card) async {
    final l10n = AppLocalizations.of(context)!;
    final action = await showCupertinoModalPopup<String>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('contacts'),
            child: Text(l10n.cardActionSaveToContacts),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('google_contacts'),
            child: const Text('Google Kişilere Ekle'),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('reminder'),
            child: Text(l10n.cardActionAddReminder),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop('edit'),
            child: Text(l10n.commonEdit),
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
    switch (action) {
      case 'contacts':
        try {
          final saved = await saveScannedCardToContacts(card);
          if (context.mounted) {
            showToast(
              context,
              saved ? 'Rehbere eklendi' : l10n.cardContactsPermissionDenied,
              success: saved,
            );
          }
        } catch (e) {
          if (context.mounted) await showErrorDialog(context, e);
        }
        break;
      case 'google_contacts':
        final gcError = await addCardToGoogleContacts(card);
        if (context.mounted) {
          showToast(
            context,
            gcError == null ? 'Google Kişilere eklendi' : 'Hata: $gcError',
            success: gcError == null,
          );
        }
        break;
      case 'reminder':
        context.push('/scanned-card/${card.id}/reminder');
        break;
      case 'edit':
        context.push('/scanned-card/edit/${card.id}');
        break;
    }
  }

  Future<void> _share(BuildContext context, ScannedCard card) async {
    try {
      await shareScannedCard(card);
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cardAsync = ref.watch(scannedCardByIdProvider(cardId));

    useEffect(() {
      ref.read(scannedCardRepositoryProvider).markViewed(cardId);
      return null;
    }, [cardId]);

    return cardAsync.when(
      loading: () =>
          const CupertinoPageScaffold(child: Center(child: CupertinoActivityIndicator())),
      error: (_, _) => CupertinoPageScaffold(child: Center(child: Text(l10n.commonError))),
      data: (card) {
        if (card == null) {
          return CupertinoPageScaffold(child: Center(child: Text(l10n.commonError)));
        }
        final notesAsync = ref.watch(cardNotesProvider(cardId));
        final addressFields = card.fields.where((f) => f.fieldType == 'address');
        final addressField = addressFields.isEmpty ? null : addressFields.first;
        final phoneFields =
            card.fields.where((f) => f.fieldType == 'mobile' || f.fieldType == 'phone');

        return CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            middle: Text(card.fullName ?? ''),
            trailing: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => _openMoreActions(context, ref, card),
              child: const Icon(CupertinoIcons.ellipsis_circle),
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: [
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          if (card.frontImageUrl != null)
                            AspectRatio(
                              aspectRatio: 1.6,
                              child: Image.network(card.frontImageUrl!, fit: BoxFit.cover),
                            )
                          else
                            const SizedBox(height: 16),
                          if (card.profileImageUrl != null)
                            Positioned(
                              bottom: card.frontImageUrl != null ? -36 : -16,
                              left: 16,
                              child: Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(color: CupertinoColors.white, width: 3),
                                ),
                                child: ClipOval(
                                  child: Image.network(
                                    card.profileImageUrl!,
                                    width: 72,
                                    height: 72,
                                    fit: BoxFit.cover,
                                  ),
                                ),
              ),
                            ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          card.profileImageUrl != null
                              ? (card.frontImageUrl != null ? 44 : 24)
                              : 16,
                          16,
                          0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              card.fullName ?? '',

                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                            ),
                            if (card.company != null && card.company!.isNotEmpty)
                              Text(card.company!),
                            if (card.jobTitle != null && card.jobTitle!.isNotEmpty)
                              Text(card.jobTitle!,
                                  style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                            if (addressField != null)
                              Text(addressField.value,
                                  style: TextStyle(color: CupertinoColors.secondaryLabel.resolveFrom(context))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _QuickAction(
                              icon: CupertinoIcons.phone,
                              label: l10n.cardActionCall,
                              onTap: phoneFields.isEmpty
                                  ? null
                                  : () => _openField(context, phoneFields.first),
                            ),
                            _QuickAction(
                              icon: CupertinoIcons.location,
                              label: l10n.fieldAddress,
                              onTap:
                                  addressField == null ? null : () => _openField(context, addressField),
                            ),
                            _QuickAction(
                              icon: CupertinoIcons.pencil_ellipsis_rectangle,
                              label: l10n.cardActionAddNote,
                              onTap: () => context.push(
                                '/scanned-card/${card.id}/note',
                                extra: card.fullName,
                              ),
                            ),
                            _QuickAction(
                              icon: CupertinoIcons.pencil,
                              label: l10n.commonEdit,
                              onTap: () => context.push('/scanned-card/edit/${card.id}'),
                            ),
                          ],
                        ),
                      ),
                      notesAsync.when(
                        data: (notes) => notes.isEmpty
                            ? const SizedBox.shrink()
                            : CupertinoListSection.insetGrouped(
                                header: Text(l10n.cardNotesSection),
                                children: [for (final note in notes) _NoteTile(note: note)],
                              ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                      CupertinoListSection.insetGrouped(
                        children: [
                          for (final field in card.fields)
                            CupertinoListTile(
                              leading: Icon(platformByKey(field.fieldType).icon),
                              title: Text(field.value),
                              subtitle: field.label.isNotEmpty ? Text(field.label) : null,
                              onTap: () => _openField(context, field),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: CupertinoButton.filled(
                    onPressed: () => _share(context, card),
                    child: Text(l10n.homeShareCard),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuickAction extends StatelessWidget {
  const _QuickAction({required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final disabled = onTap == null;
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 4),
      onPressed: onTap,
      child: Column(
        children: [
          Icon(icon, color: disabled ? CupertinoColors.systemGrey3.resolveFrom(context) : null),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: disabled ? CupertinoColors.systemGrey3.resolveFrom(context) : null),
          ),
        ],
      ),
    );
  }
}

class _NoteTile extends StatelessWidget {
  const _NoteTile({required this.note});

  final CardNote note;

  @override
  Widget build(BuildContext context) {
    final isVisitLog = note.noteType == CardNoteType.visitLog;
    final date = note.contactDate ?? note.createdAt;
    final dateStr = date != null
        ? '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}'
        : '';

    if (isVisitLog) {
      return CupertinoListTile(
        leading: const Icon(CupertinoIcons.person_2),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: CupertinoColors.systemBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Contact Log',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: CupertinoColors.systemBlue,
                ),
              ),
            ),
            if (note.wayOfContact != null) ...[
              const SizedBox(width: 6),
              Text(
                note.wayOfContact!,
                style: const TextStyle(
                  fontSize: 13,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
            ],
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.contactContent != null && note.contactContent!.isNotEmpty)
              Text(
                note.contactContent!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            if (dateStr.isNotEmpty)
              Text(
                dateStr,
                style: const TextStyle(
                  fontSize: 11,
                  color: CupertinoColors.secondaryLabel,
                ),
              ),
          ],
        ),
      );
    }

    return CupertinoListTile(
      leading: const Icon(CupertinoIcons.doc_text),
      title: Text(
        note.content,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: dateStr.isNotEmpty ? Text(dateStr) : null,
    );
  }
}
