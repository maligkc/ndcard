import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/backend_providers.dart';
import '../../../../core/domain/entities/digital_card.dart';
import '../../../../core/domain/repositories/storage_repository.dart';
import '../../../../core/widgets/form_sheet.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../application/photo_picker_helper.dart';
import '../card_updater.dart';

class InformationsTab extends ConsumerWidget {
  const InformationsTab({super.key, required this.card, required this.onChanged});

  final DigitalCard card;
  final CardUpdater onChanged;

  Future<void> _pickPhoto(BuildContext context, WidgetRef ref) async {
    final file = await pickAndCropSquareImage();
    if (file == null) return;
    try {
      final url = await uploadCardImage(
        storage: ref.read(storageRepositoryProvider),
        bucket: StorageBucket.avatars,
        userId: card.userId,
        fileName: '${card.id}.jpg',
        file: file,
      );
      onChanged((c) => c.copyWith(photoUrl: url));
    } catch (_) {
      // Yükleme başarısız olursa sessizce yoksayılır; kullanıcı tekrar deneyebilir.
    }
  }

  Future<void> _addExperience(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showFormSheet(
      context: context,
      title: l10n.experienceAdd,
      fields: [
        FormFieldSpec(key: 'company', label: l10n.experienceCompany),
        FormFieldSpec(key: 'title', label: l10n.experienceTitle),
        FormFieldSpec(key: 'startYear', label: l10n.experienceStartYear, keyboardType: TextInputType.number),
        FormFieldSpec(key: 'endYear', label: l10n.experienceEndYear, keyboardType: TextInputType.number),
        FormFieldSpec(key: 'isCurrent', label: l10n.experienceIsCurrent, type: FormFieldType.toggle),
      ],
    );
    if (result == null) return;
    final isCurrent = result['isCurrent'] == 'true';
    onChanged((c) => c.copyWith(experiences: [
          ...c.experiences,
          DigitalCardExperience(
            id: const Uuid().v4(),
            cardId: c.id,
            company: result['company'] ?? '',
            title: result['title'] ?? '',
            startDate: _yearToDate(result['startYear']),
            endDate: isCurrent ? null : _yearToDate(result['endYear']),
            isCurrent: isCurrent,
          ),
        ]));
  }

  void _removeExperience(String id) {
    onChanged((c) => c.copyWith(
          experiences: c.experiences.where((e) => e.id != id).toList(),
        ));
  }

  Future<void> _showAddMoreInfoSheet(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final kind = await showCupertinoModalPopup<DigitalCardExtraKind>(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text(l10n.extraAddMore),
        actions: [
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(DigitalCardExtraKind.pdf),
            child: Text(l10n.extraKindPdf),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(DigitalCardExtraKind.education),
            child: Text(l10n.extraKindEducation),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(DigitalCardExtraKind.honorAward),
            child: Text(l10n.extraKindHonorAward),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(DigitalCardExtraKind.other),
            child: Text(l10n.extraKindOther),
          ),
          CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context).pop(DigitalCardExtraKind.cardImage),
            child: Text(l10n.extraKindCardImage),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDestructiveAction: true,
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.commonCancel),
        ),
      ),
    );
    if (kind == null || !context.mounted) return;
    await _addExtra(context, ref, kind);
  }

  Future<void> _addExtra(BuildContext context, WidgetRef ref, DigitalCardExtraKind kind) async {
    final l10n = AppLocalizations.of(context)!;
    Map<String, dynamic>? payload;

    switch (kind) {
      case DigitalCardExtraKind.pdf:
        final result = await showFormSheet(
          context: context,
          title: l10n.extraKindPdf,
          fields: [FormFieldSpec(key: 'title', label: l10n.extraPdfTitle)],
        );
        if (result == null) break;
        payload = {'title': result['title'], 'url': ''};
        break;
      case DigitalCardExtraKind.education:
        final result = await showFormSheet(
          context: context,
          title: l10n.extraKindEducation,
          fields: [
            FormFieldSpec(key: 'school', label: l10n.extraEducationSchool),
            FormFieldSpec(key: 'department', label: l10n.extraEducationDepartment),
            FormFieldSpec(key: 'year', label: l10n.extraEducationYear, keyboardType: TextInputType.number),
          ],
        );
        if (result == null) break;
        payload = result;
        break;
      case DigitalCardExtraKind.honorAward:
        final result = await showFormSheet(
          context: context,
          title: l10n.extraKindHonorAward,
          fields: [
            FormFieldSpec(key: 'title', label: l10n.extraHonorTitle),
            FormFieldSpec(key: 'year', label: l10n.extraHonorYear, keyboardType: TextInputType.number),
            FormFieldSpec(key: 'description', label: l10n.extraHonorDescription),
          ],
        );
        if (result == null) break;
        payload = result;
        break;
      case DigitalCardExtraKind.other:
        final result = await showFormSheet(
          context: context,
          title: l10n.extraKindOther,
          fields: [
            FormFieldSpec(key: 'title', label: l10n.extraOtherTitle),
            FormFieldSpec(key: 'text', label: l10n.extraOtherText),
          ],
        );
        if (result == null) break;
        payload = result;
        break;
      case DigitalCardExtraKind.cardImage:
        final file = await pickImage();
        if (file == null) break;
        final id = const Uuid().v4();
        final url = await uploadCardImage(
          storage: ref.read(storageRepositoryProvider),
          bucket: StorageBucket.cardImages,
          userId: card.userId,
          fileName: '$id.jpg',
          file: file,
        );
        payload = {'url': url};
        break;
    }

    if (payload == null || !context.mounted) return;
    onChanged((c) => c.copyWith(extras: [
          ...c.extras,
          DigitalCardExtra(id: const Uuid().v4(), cardId: c.id, kind: kind, payload: payload!),
        ]));
  }

  void _removeExtra(String id) {
    onChanged((c) => c.copyWith(extras: c.extras.where((e) => e.id != id).toList()));
  }

  String _extraSubtitle(DigitalCardExtra extra) {
    switch (extra.kind) {
      case DigitalCardExtraKind.pdf:
        return extra.payload['title'] as String? ?? '';
      case DigitalCardExtraKind.education:
        return [extra.payload['school'], extra.payload['department'], extra.payload['year']]
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .join(' · ');
      case DigitalCardExtraKind.honorAward:
        return [extra.payload['title'], extra.payload['year']]
            .whereType<String>()
            .where((s) => s.isNotEmpty)
            .join(' · ');
      case DigitalCardExtraKind.other:
        return extra.payload['title'] as String? ?? '';
      case DigitalCardExtraKind.cardImage:
        return extra.payload['url'] as String? ?? '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return ListView(
      children: [
        const SizedBox(height: 12),
        Center(
          child: GestureDetector(
            onTap: () => _pickPhoto(context, ref),
            child: Stack(
              children: [
                ClipOval(
                  child: card.photoUrl != null && card.photoUrl!.isNotEmpty
                      ? Image.network(card.photoUrl!, width: 88, height: 88, fit: BoxFit.cover)
                      : Container(
                          width: 88,
                          height: 88,
                          color: CupertinoColors.systemGrey5.resolveFrom(context),
                          child: Icon(CupertinoIcons.person_fill, size: 40,
                              color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: CupertinoColors.activeBlue,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(CupertinoIcons.camera_fill, size: 14, color: CupertinoColors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        CupertinoListSection.insetGrouped(
          header: Text(l10n.infoPersonal),
          children: [
            CupertinoTextFormFieldRow(
              placeholder: '${l10n.infoFirstName} *',
              initialValue: card.firstName,
              onChanged: (v) => onChanged((c) => c.copyWith(firstName: v)),
            ),
            CupertinoTextFormFieldRow(
              placeholder: '${l10n.infoLastName} *',
              initialValue: card.lastName,
              onChanged: (v) => onChanged((c) => c.copyWith(lastName: v)),
            ),
          ],
        ),
        CupertinoListSection.insetGrouped(
          header: Text(l10n.infoAffiliation),
          children: [
            CupertinoTextFormFieldRow(
              placeholder: '${l10n.infoJobTitle} *',
              initialValue: card.jobTitle,
              onChanged: (v) => onChanged((c) => c.copyWith(jobTitle: v)),
            ),
            CupertinoTextFormFieldRow(
              placeholder: l10n.infoDepartment,
              initialValue: card.department,
              onChanged: (v) => onChanged((c) => c.copyWith(department: v)),
            ),
            CupertinoTextFormFieldRow(
              placeholder: '${l10n.infoCompany} *',
              initialValue: card.company,
              onChanged: (v) => onChanged((c) => c.copyWith(company: v)),
            ),
            CupertinoTextFormFieldRow(
              placeholder: l10n.infoHeadline,
              initialValue: card.headline,
              onChanged: (v) => onChanged((c) => c.copyWith(headline: v)),
            ),
          ],
        ),
        CupertinoListSection.insetGrouped(
          header: Text(l10n.infoExperience),
          children: [
            for (final exp in card.experiences)
              CupertinoListTile(
                title: Text('${exp.title} · ${exp.company}'),
                subtitle: Text(exp.isCurrent ? l10n.experienceIsCurrent : ''),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _removeExperience(exp.id),
                  child: const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed),
                ),
              ),
            CupertinoListTile(
              title: Text(l10n.experienceAdd),
              leading: const Icon(CupertinoIcons.add_circled),
              onTap: () => _addExperience(context),
            ),
          ],
        ),
        CupertinoListSection.insetGrouped(
          header: Text(l10n.extraSectionTitle),
          children: [
            for (final extra in card.extras)
              CupertinoListTile(
                title: Text(_extraKindLabel(l10n, extra.kind)),
                subtitle: Text(_extraSubtitle(extra)),
                trailing: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _removeExtra(extra.id),
                  child: const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed),
                ),
              ),
            CupertinoListTile(
              title: Text(l10n.extraAddMore),
              leading: const Icon(CupertinoIcons.add_circled),
              onTap: () => _showAddMoreInfoSheet(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  String _extraKindLabel(AppLocalizations l10n, DigitalCardExtraKind kind) {
    switch (kind) {
      case DigitalCardExtraKind.pdf:
        return l10n.extraKindPdf;
      case DigitalCardExtraKind.education:
        return l10n.extraKindEducation;
      case DigitalCardExtraKind.honorAward:
        return l10n.extraKindHonorAward;
      case DigitalCardExtraKind.other:
        return l10n.extraKindOther;
      case DigitalCardExtraKind.cardImage:
        return l10n.extraKindCardImage;
    }
  }
}

DateTime? _yearToDate(String? year) {
  if (year == null || year.isEmpty) return null;
  final parsed = int.tryParse(year);
  if (parsed == null) return null;
  return DateTime(parsed);
}
