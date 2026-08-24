import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/domain/entities/digital_card.dart';
import '../../../../core/utils/supported_platforms.dart';
import '../../../../core/widgets/form_sheet.dart';
import '../../../../core/widgets/platform_icon.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../card_updater.dart';
import '../field_picker_page.dart';

class FieldsTab extends StatelessWidget {
  const FieldsTab({super.key, required this.card, required this.onChanged});

  final DigitalCard card;
  final CardUpdater onChanged;

  Future<void> _addField(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final platform = await Navigator.of(context).push<SupportedPlatform>(
      CupertinoPageRoute(builder: (_) => const FieldPickerPage()),
    );
    if (platform == null || !context.mounted) return;
    final result = await showFormSheet(
      context: context,
      title: platformLabel(l10n, platform),
      fields: [
        FormFieldSpec(
          key: 'value',
          label: platformLabel(l10n, platform),
          keyboardType: switch (platform.inputType) {
            PlatformInputType.email => TextInputType.emailAddress,
            PlatformInputType.phone => TextInputType.phone,
            _ => TextInputType.text,
          },
        ),
        FormFieldSpec(key: 'label', label: l10n.fieldLabel),
      ],
    );
    if (result == null) return;
    final value = result['value'] ?? '';
    if (value.isEmpty) return;
    onChanged((c) => c.copyWith(fields: [
          ...c.fields,
          DigitalCardField(
            id: const Uuid().v4(),
            cardId: c.id,
            platform: platform.key,
            label: result['label'] ?? '',
            value: value,
            sortOrder: c.fields.length,
          ),
        ]));
  }

  Future<void> _editField(BuildContext context, DigitalCardField field) async {
    final l10n = AppLocalizations.of(context)!;
    final platform = platformByKey(field.platform);
    final result = await showFormSheet(
      context: context,
      title: platformLabel(l10n, platform),
      fields: [
        FormFieldSpec(
          key: 'value',
          label: platformLabel(l10n, platform),
          initialText: field.value,
          keyboardType: switch (platform.inputType) {
            PlatformInputType.email => TextInputType.emailAddress,
            PlatformInputType.phone => TextInputType.phone,
            _ => TextInputType.text,
          },
        ),
        FormFieldSpec(key: 'label', label: l10n.fieldLabel, initialText: field.label),
      ],
    );
    if (result == null) return;
    onChanged((c) => c.copyWith(
          fields: c.fields
              .map((f) => f.id == field.id
                  ? f.copyWith(value: result['value'], label: result['label'])
                  : f)
              .toList(),
        ));
  }

  void _removeField(String id) {
    onChanged((c) => c.copyWith(fields: c.fields.where((f) => f.id != id).toList()));
  }

  void _move(String id, int direction) {
    onChanged((c) {
      final fields = [...c.fields];
      final index = fields.indexWhere((f) => f.id == id);
      final target = index + direction;
      if (index < 0 || target < 0 || target >= fields.length) return c;
      final item = fields.removeAt(index);
      fields.insert(target, item);
      final reordered = [
        for (var i = 0; i < fields.length; i++) fields[i].copyWith(sortOrder: i),
      ];
      return c.copyWith(fields: reordered);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final sorted = [...card.fields]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return ListView(
      children: [
        CupertinoListSection.insetGrouped(
          children: [
            for (final field in sorted)
              CupertinoListTile(
                leading: PlatformIcon(field.platform),
                title: Text(
                  field.label.isNotEmpty
                      ? '${platformLabel(l10n, platformByKey(field.platform))} · ${field.label}'
                      : platformLabel(l10n, platformByKey(field.platform)),
                ),
                subtitle: Text(field.value),
                onTap: () => _editField(context, field),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _move(field.id, -1),
                      child: const Icon(CupertinoIcons.chevron_up, size: 18),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _move(field.id, 1),
                      child: const Icon(CupertinoIcons.chevron_down, size: 18),
                    ),
                    CupertinoButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => _removeField(field.id),
                      child: const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed),
                    ),
                  ],
                ),
              ),
            CupertinoListTile(
              title: Text(l10n.fieldAdd),
              leading: const Icon(CupertinoIcons.add_circled),
              onTap: () => _addField(context),
            ),
          ],
        ),
      ],
    );
  }
}
