import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/domain/entities/scanned_card.dart';
import '../../../../l10n/gen/app_localizations.dart';

typedef ScannedCardUpdater = void Function(ScannedCard Function(ScannedCard current) updater);

/// Tekrarlanabilir alan grubu (Cep Telefonu, İş E-postası, Web Sitesi) veya
/// adres bloğu için ortak liste bölümü.
class ScannedCardFieldGroup extends StatelessWidget {
  const ScannedCardFieldGroup({
    super.key,
    required this.title,
    required this.fieldType,
    required this.keyboardType,
    required this.card,
    required this.onChanged,
    this.isAddress = false,
  });

  final String title;
  final String fieldType;
  final TextInputType keyboardType;
  final ScannedCard card;
  final ScannedCardUpdater onChanged;
  final bool isAddress;

  void _add() {
    onChanged((c) => c.copyWith(fields: [
          ...c.fields,
          ScannedCardField(
            id: const Uuid().v4(),
            cardId: c.id,
            fieldType: fieldType,
            label: '',
            value: '',
            addressDetail: isAddress ? const AddressDetail() : null,
          ),
        ]));
  }

  void _remove(String id) {
    onChanged((c) => c.copyWith(fields: c.fields.where((f) => f.id != id).toList()));
  }

  void _updateValue(String id, String value) {
    onChanged((c) => c.copyWith(
          fields: c.fields.map((f) => f.id == id ? f.copyWith(value: value) : f).toList(),
        ));
  }

  void _updateAddress(String id, AddressDetail Function(AddressDetail) updater) {
    onChanged((c) => c.copyWith(
          fields: c.fields.map((f) {
            if (f.id != id) return f;
            final current = f.addressDetail ?? const AddressDetail();
            final updated = updater(current);
            return f.copyWith(
              addressDetail: updated,
              value: [updated.street, updated.district, updated.city]
                  .whereType<String>()
                  .where((s) => s.isNotEmpty)
                  .join(', '),
            );
          }).toList(),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final fields = card.fields.where((f) => f.fieldType == fieldType).toList();

    return CupertinoListSection.insetGrouped(
      header: Text(title),
      children: [
        for (final field in fields)
          if (isAddress)
            _AddressBlock(
              key: ValueKey(field.id),
              field: field,
              onChanged: (updater) => _updateAddress(field.id, updater),
              onRemove: () => _remove(field.id),
            )
          else
            Row(
              key: ValueKey(field.id),
              children: [
                Expanded(
                  child: CupertinoTextFormFieldRow(
                    placeholder: title,
                    initialValue: field.value,
                    keyboardType: keyboardType,
                    onChanged: (v) => _updateValue(field.id, v),
                  ),
                ),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => _remove(field.id),
                  child: const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed),
                ),
              ],
            ),
        CupertinoListTile(
          title: Text(l10n.commonAdd),
          leading: const Icon(CupertinoIcons.add_circled),
          onTap: _add,
        ),
      ],
    );
  }
}

class _AddressBlock extends StatelessWidget {
  const _AddressBlock({super.key, required this.field, required this.onChanged, required this.onRemove});

  final ScannedCardField field;
  final void Function(AddressDetail Function(AddressDetail)) onChanged;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final detail = field.addressDetail ?? const AddressDetail();
    return Column(
      children: [
        CupertinoTextFormFieldRow(
          placeholder: l10n.addressStreet,
          initialValue: detail.street,
          onChanged: (v) => onChanged((d) => d.copyWith(street: v)),
        ),
        CupertinoTextFormFieldRow(
          placeholder: l10n.addressCity,
          initialValue: detail.city,
          onChanged: (v) => onChanged((d) => d.copyWith(city: v)),
        ),
        CupertinoTextFormFieldRow(
          placeholder: l10n.addressDistrict,
          initialValue: detail.district,
          onChanged: (v) => onChanged((d) => d.copyWith(district: v)),
        ),
        CupertinoTextFormFieldRow(
          placeholder: l10n.addressPostalCode,
          initialValue: detail.postalCode,
          onChanged: (v) => onChanged((d) => d.copyWith(postalCode: v)),
        ),
        Row(
          children: [
            Expanded(
              child: CupertinoTextFormFieldRow(
                placeholder: l10n.addressCountry,
                initialValue: detail.country,
                onChanged: (v) => onChanged((d) => d.copyWith(country: v)),
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onRemove,
              child: const Icon(CupertinoIcons.minus_circle, color: CupertinoColors.destructiveRed),
            ),
          ],
        ),
      ],
    );
  }
}
