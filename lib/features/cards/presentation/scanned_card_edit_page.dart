import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/domain/repositories/storage_repository.dart';
import '../../../core/utils/supported_platforms.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../core/widgets/form_sheet.dart';
import '../../../core/widgets/toast.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../../digital_card/application/photo_picker_helper.dart';
import '../application/google_contacts_helper.dart';
import '../../digital_card/presentation/field_picker_page.dart';
import '../application/scanned_cards_provider.dart';
import 'photo_edit_page.dart';
import 'widgets/scanned_card_field_group.dart';

class ScannedCardEditPage extends ConsumerWidget {
  const ScannedCardEditPage({super.key, this.cardId, this.initialDraft});

  final String? cardId;
  final ScannedCard? initialDraft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    if (initialDraft != null) {
      // Tarayıcıdan gelen yeni kart → otomatik Google Contacts
      return _EditBody(initial: initialDraft!, isFromScan: true);
    }
    final userId = ref.watch(authStateChangesProvider).value?.id;
    if (cardId == null) {
      if (userId == null) {
        return CupertinoPageScaffold(child: Center(child: Text(l10n.commonError)));
      }
      return _EditBody(initial: ScannedCard(id: const Uuid().v4(), userId: userId));
    }
    final existingAsync = ref.watch(scannedCardByIdProvider(cardId!));
    return existingAsync.when(
      data: (existing) => existing == null
          ? CupertinoPageScaffold(child: Center(child: Text(l10n.commonError)))
          : _EditBody(initial: existing),
      loading: () =>
          const CupertinoPageScaffold(child: Center(child: CupertinoActivityIndicator())),
      error: (_, _) => CupertinoPageScaffold(child: Center(child: Text(l10n.commonError))),
    );
  }
}

class _EditBody extends HookConsumerWidget {
  const _EditBody({required this.initial, this.isFromScan = false});

  final ScannedCard initial;
  final bool isFromScan;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final draft = useState(initial);
    final isSaving = useState(false);
    final isUploadingProfile = useState(false);

    void update(ScannedCard Function(ScannedCard) updater) {
      draft.value = updater(draft.value);
    }

    Future<void> save() async {
      isSaving.value = true;
      try {
        final saved = await ref.read(scannedCardRepositoryProvider).saveCard(draft.value);
        // Sadece tarayıcıdan gelen yeni kartlarda otomatik Google Contacts'a ekle.
        // pop() öncesinde await ediyoruz: iOS'ta sayfa kapandıktan sonra
        // Google sign-in diyaloğu sunulamıyor.
        if (isFromScan) {
          final error = await addCardToGoogleContacts(saved);
          if (context.mounted) {
            showToast(
              context,
              error == null ? 'Google Kişilere eklendi' : 'Hata: $error',
              success: error == null,
            );
          }
        }
        if (context.mounted) context.pop();
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      } finally {
        isSaving.value = false;
      }
    }

    Future<void> pickProfilePhoto() async {
      final action = await showCupertinoModalPopup<String>(
        context: context,
        builder: (ctx) => CupertinoActionSheet(
          title: Text(l10n.profilePhoto),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () => Navigator.of(ctx).pop('pick'),
              child: Text(l10n.profilePhotoAdd),
            ),
            if (draft.value.profileImageUrl != null)
              CupertinoActionSheetAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.of(ctx).pop('remove'),
                child: Text(l10n.profilePhotoRemove),
              ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.commonCancel),
          ),
        ),
      );
      if (action == 'remove') {
        draft.value = ScannedCard(
          id: draft.value.id,
          userId: draft.value.userId,
          profileImageUrl: null,
          frontImageUrl: draft.value.frontImageUrl,
          backImageUrl: draft.value.backImageUrl,
          fullName: draft.value.fullName,
          company: draft.value.company,
          department: draft.value.department,
          jobTitle: draft.value.jobTitle,
          fields: draft.value.fields,
        );
        return;
      }
      if (action != 'pick') return;

      final file = await pickImage();
      if (file == null || !context.mounted) return;
      isUploadingProfile.value = true;
      try {
        final url = await ref.read(storageRepositoryProvider).uploadFile(
              bucket: StorageBucket.cardImages,
              userId: draft.value.userId,
              file: file,
              fileName: '${draft.value.id}-profile-${DateTime.now().millisecondsSinceEpoch}.jpg',
            );
        draft.value = draft.value.copyWith(profileImageUrl: url);
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      } finally {
        isUploadingProfile.value = false;
      }
    }

    Future<void> deleteCard() async {
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
      if (confirmed != true) return;
      try {
        await ref.read(scannedCardRepositoryProvider).softDeleteCard(draft.value.id);
        if (context.mounted) context.pop();
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      }
    }

    Future<void> addOtherField() async {
      final platform = await Navigator.of(context).push<SupportedPlatform>(
        CupertinoPageRoute(builder: (_) => const FieldPickerPage()),
      );
      if (platform == null || !context.mounted) return;
      final result = await showFormSheet(
        context: context,
        title: platformLabel(l10n, platform),
        fields: [
          FormFieldSpec(key: 'value', label: platformLabel(l10n, platform)),
          FormFieldSpec(key: 'label', label: l10n.fieldLabel),
        ],
      );
      final value = result?['value'];
      if (value == null || value.isEmpty) return;
      update((c) => c.copyWith(fields: [
            ...c.fields,
            ScannedCardField(
              id: const Uuid().v4(),
              cardId: c.id,
              fieldType: platform.key,
              label: result?['label'] ?? '',
              value: value,
            ),
          ]));
    }

    void removeField(String id) {
      update((c) => c.copyWith(fields: c.fields.where((f) => f.id != id).toList()));
    }

    final card = draft.value;
    final knownTypes = {'mobile', 'email', 'url', 'address'};
    final otherFields = card.fields.where((f) => !knownTypes.contains(f.fieldType)).toList();

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.commonEdit),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isSaving.value ? null : save,
          child: isSaving.value ? const CupertinoActivityIndicator() : Text(l10n.commonSave),
        ),
      ),
      child: SafeArea(
        child: ListView(
          children: [
            // Profil fotoğrafı
            GestureDetector(
              onTap: isUploadingProfile.value ? null : pickProfilePhoto,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Stack(
                    children: [
                      ClipOval(
                        child: isUploadingProfile.value
                            ? Container(
                                width: 80,
                                height: 80,
                                color: CupertinoColors.systemGrey5.resolveFrom(context),
                                child: const CupertinoActivityIndicator(),
                              )
                            : card.profileImageUrl != null
                                ? Image.network(
                                    card.profileImageUrl!,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, _, _) => _ProfilePlaceholder(name: card.fullName),
                                  )
                                : _ProfilePlaceholder(name: card.fullName),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: CupertinoColors.activeBlue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(CupertinoIcons.camera, size: 13, color: CupertinoColors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Kartvizit fotoğrafı
            GestureDetector(
              onTap: () async {
                final updated = await Navigator.of(context).push<ScannedCard>(
                  CupertinoPageRoute(builder: (_) => PhotoEditPage(card: card)),
                );
                if (updated != null) draft.value = updated;
              },
              child: AspectRatio(
                aspectRatio: 1.6,
                child: card.frontImageUrl != null
                    ? Image.network(card.frontImageUrl!, fit: BoxFit.cover)
                    : Builder(
                        builder: (context) => Container(
                          color: CupertinoColors.systemGrey5.resolveFrom(context),
                          child: Icon(CupertinoIcons.photo, size: 40,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                      ),
              ),
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoTextFormFieldRow(
                  placeholder: l10n.infoFullName,
                  initialValue: card.fullName,
                  onChanged: (v) => update((c) => c.copyWith(fullName: v)),
                ),
              ],
            ),
            ScannedCardFieldGroup(
              title: l10n.fieldPhoneMobile,
              fieldType: 'mobile',
              keyboardType: TextInputType.phone,
              card: card,
              onChanged: update,
            ),
            ScannedCardFieldGroup(
              title: l10n.scanWorkEmail,
              fieldType: 'email',
              keyboardType: TextInputType.emailAddress,
              card: card,
              onChanged: update,
            ),
            CupertinoListSection.insetGrouped(
              header: Text(l10n.infoAffiliation),
              children: [
                CupertinoTextFormFieldRow(
                  placeholder: l10n.infoCompany,
                  initialValue: card.company,
                  onChanged: (v) => update((c) => c.copyWith(company: v)),
                ),
                CupertinoTextFormFieldRow(
                  placeholder: l10n.infoDepartment,
                  initialValue: card.department,
                  onChanged: (v) => update((c) => c.copyWith(department: v)),
                ),
                CupertinoTextFormFieldRow(
                  placeholder: l10n.infoJobTitle,
                  initialValue: card.jobTitle,
                  onChanged: (v) => update((c) => c.copyWith(jobTitle: v)),
                ),
              ],
            ),
            ScannedCardFieldGroup(
              title: l10n.fieldWebsite,
              fieldType: 'url',
              keyboardType: TextInputType.url,
              card: card,
              onChanged: update,
            ),
            ScannedCardFieldGroup(
              title: l10n.fieldAddress,
              fieldType: 'address',
              keyboardType: TextInputType.streetAddress,
              card: card,
              onChanged: update,
              isAddress: true,
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text(l10n.scanSortByCompany),
                  trailing: CupertinoSwitch(
                    value: card.sortByCompany,
                    onChanged: (v) => update((c) => c.copyWith(sortByCompany: v)),
                  ),
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              header: Text(l10n.extraSectionTitle),
              children: [
                for (final field in otherFields)
                  CupertinoListTile(
                    leading: Icon(platformByKey(field.fieldType).icon),
                    title: Text(platformLabel(l10n, platformByKey(field.fieldType))),
                    subtitle: Text(field.value),
                    onTap: () async {
                      final result = await showFormSheet(
                        context: context,
                        title: platformLabel(l10n, platformByKey(field.fieldType)),
                        fields: [
                          FormFieldSpec(
                            key: 'value',
                            label: platformLabel(l10n, platformByKey(field.fieldType)),
                            initialText: field.value,
                          ),
                          FormFieldSpec(
                            key: 'label',
                            label: l10n.fieldLabel,
                            initialText: field.label,
                          ),
                        ],
                      );
                      final value = result?['value'];
                      if (value == null || value.isEmpty) return;
                      update((c) => c.copyWith(
                            fields: c.fields
                                .map((f) => f.id == field.id
                                    ? ScannedCardField(
                                        id: f.id,
                                        cardId: f.cardId,
                                        fieldType: f.fieldType,
                                        label: result?['label'] ?? f.label,
                                        value: value,
                                      )
                                    : f)
                                .toList(),
                          ));
                    },
                    trailing: CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => removeField(field.id),
                      child:
                          const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed),
                    ),
                  ),
                CupertinoListTile(
                  title: Text(l10n.scanAddMoreInfo),
                  leading: const Icon(CupertinoIcons.add_circled),
                  onTap: addOtherField,
                ),
              ],
            ),
            CupertinoListSection.insetGrouped(
              children: [
                CupertinoListTile(
                  title: Text(l10n.scanAddBackSide),
                  leading: const Icon(CupertinoIcons.rectangle_stack),
                  onTap: () async {
                    final updated = await Navigator.of(context).push<ScannedCard>(
                      CupertinoPageRoute(builder: (_) => PhotoEditPage(card: card, isBack: true)),
                    );
                    if (updated != null) draft.value = updated;
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: CupertinoButton(
                color: CupertinoColors.destructiveRed,
                onPressed: deleteCard,
                child: Text(l10n.scanDeleteCard),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePlaceholder extends StatelessWidget {
  const _ProfilePlaceholder({this.name});
  final String? name;

  @override
  Widget build(BuildContext context) {
    final trimmed = name?.trim() ?? '';
    final parts = trimmed.split(' ').where((s) => s.isNotEmpty).toList();
    final letters = parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : trimmed.isNotEmpty
            ? trimmed[0].toUpperCase()
            : '';

    return Container(
      width: 80,
      height: 80,
      color: CupertinoColors.systemGrey5.resolveFrom(context),
      alignment: Alignment.center,
      child: letters.isNotEmpty
          ? Text(letters,
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ))
          : Icon(CupertinoIcons.person_alt,
              size: 36, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
    );
  }
}

