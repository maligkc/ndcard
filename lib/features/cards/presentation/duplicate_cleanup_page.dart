import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/scanned_card.dart';
import '../../../core/domain/repositories/scanned_card_repository.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../application/scanned_cards_provider.dart';

String _primaryPhone(ScannedCard card) {
  final fields = card.fields.where((f) => f.fieldType == 'mobile' || f.fieldType == 'phone');
  return fields.isEmpty ? '' : fields.first.value.replaceAll(RegExp(r'\s+'), '');
}

List<List<ScannedCard>> _findDuplicateGroups(List<ScannedCard> cards) {
  final groups = <String, List<ScannedCard>>{};
  for (final card in cards) {
    final name = (card.fullName ?? '').trim().toLowerCase();
    final phone = _primaryPhone(card);
    if (name.isEmpty || phone.isEmpty) continue;
    final key = '$name|$phone';
    groups.putIfAbsent(key, () => []).add(card);
  }
  return groups.values.where((g) => g.length > 1).toList();
}

/// Gruptaki tüm kartları tek bir karta birleştirir.
ScannedCard _mergeGroup(List<ScannedCard> group) {
  final base = group.first;

  // Metin alanları: ilk dolu değeri kullan
  String? pick(String? Function(ScannedCard) fn) {
    for (final c in group) {
      final v = fn(c);
      if (v != null && v.trim().isNotEmpty) return v;
    }
    return null;
  }

  // Alanları birleştir: (fieldType, value) çiftine göre tekilleştir
  final seen = <String>{};
  final mergedFields = <ScannedCardField>[];
  for (final card in group) {
    for (final field in card.fields) {
      final key = '${field.fieldType}|${field.value.trim().toLowerCase()}';
      if (seen.add(key)) {
        // cardId'yi base karta bağla, yeni id ver
        mergedFields.add(ScannedCardField(
          id: const Uuid().v4(),
          cardId: base.id,
          fieldType: field.fieldType,
          label: field.label,
          value: field.value,
          addressDetail: field.addressDetail,
          sortOrder: field.sortOrder,
        ));
      }
    }
  }

  return ScannedCard(
    id: base.id,
    userId: base.userId,
    profileImageUrl: pick((c) => c.profileImageUrl),
    frontImageUrl: pick((c) => c.frontImageUrl),
    backImageUrl: pick((c) => c.backImageUrl),
    fullName: pick((c) => c.fullName),
    company: pick((c) => c.company),
    department: pick((c) => c.department),
    jobTitle: pick((c) => c.jobTitle),
    sortByCompany: base.sortByCompany,
    fields: mergedFields,
  );
}

class DuplicateCleanupPage extends ConsumerWidget {
  const DuplicateCleanupPage({super.key});

  Future<void> _merge(BuildContext context, WidgetRef ref, List<ScannedCard> group) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      final merged = _mergeGroup(group);
      await ref.read(scannedCardRepositoryProvider).saveCard(merged);
      for (final card in group.skip(1)) {
        await ref.read(scannedCardRepositoryProvider).softDeleteCard(card.id);
      }
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
      return;
    }
    if (context.mounted) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          content: Text(l10n.duplicatesMerged),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.commonOk),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    }
  }

  Future<void> _keepOnlyFirst(BuildContext context, WidgetRef ref, List<ScannedCard> group) async {
    final l10n = AppLocalizations.of(context)!;
    try {
      for (final card in group.skip(1)) {
        await ref.read(scannedCardRepositoryProvider).softDeleteCard(card.id);
      }
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
      return;
    }
    if (context.mounted) {
      await showCupertinoDialog<void>(
        context: context,
        builder: (ctx) => CupertinoAlertDialog(
          content: Text(l10n.duplicatesMerged),
          actions: [
            CupertinoDialogAction(
              child: Text(l10n.commonOk),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final cardsAsync = ref.watch(scannedCardsProvider(ScannedCardSort.date));

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(l10n.duplicatesTitle)),
      child: SafeArea(
        child: cardsAsync.when(
          data: (cards) {
            final groups = _findDuplicateGroups(cards);
            if (groups.isEmpty) {
              return EmptyState(
                icon: CupertinoIcons.checkmark_circle,
                title: l10n.duplicatesNone,
                message: '',
              );
            }
            return ListView(
              children: [
                for (final group in groups)
                  CupertinoListSection.insetGrouped(
                    header: Text(group.first.fullName ?? ''),
                    footer: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: CupertinoColors.activeBlue,
                              onPressed: () => _merge(context, ref, group),
                              child: const Text('Birleştir', style: TextStyle(fontSize: 15)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: CupertinoButton(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              color: CupertinoColors.systemGrey4,
                              onPressed: () => _keepOnlyFirst(context, ref, group),
                              child: Text(l10n.duplicatesKeepFirst,
                                  style: const TextStyle(fontSize: 15, color: CupertinoColors.black)),
                            ),
                          ),
                        ],
                      ),
                    ),
                    children: [
                      for (final card in group)
                        CupertinoListTile(
                          title: Text(card.fullName ?? ''),
                          subtitle: Text([card.company, card.jobTitle]
                              .whereType<String>()
                              .where((s) => s.isNotEmpty)
                              .join(' · ')),
                          additionalInfo: Text('${card.fields.length} alan'),
                        ),
                    ],
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
