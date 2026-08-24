import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/digital_card.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../application/digital_card_providers.dart';
import 'tabs/display_tab.dart';
import 'tabs/fields_tab.dart';
import 'tabs/informations_tab.dart';

class DigitalCardEditPage extends ConsumerWidget {
  const DigitalCardEditPage({super.key, this.cardId});

  final String? cardId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final userId = ref.watch(authStateChangesProvider).value?.id;

    if (userId == null) {
      return CupertinoPageScaffold(
        child: Center(child: Text(l10n.commonError)),
      );
    }

    if (cardId == null) {
      final cardsAsync = ref.watch(digitalCardsProvider);
      return cardsAsync.when(
        data: (cards) => _EditPageBody(
          initial: DigitalCard(
            id: const Uuid().v4(),
            userId: userId,
            firstName: '',
            lastName: '',
            isDefault: cards.isEmpty,
          ),
          isNew: true,
        ),
        loading: () => const CupertinoPageScaffold(
          child: Center(child: CupertinoActivityIndicator()),
        ),
        error: (_, _) => CupertinoPageScaffold(child: Center(child: Text(l10n.commonError))),
      );
    }

    final existingAsync = ref.watch(digitalCardByIdProvider(cardId!));
    return existingAsync.when(
      data: (existing) => _EditPageBody(
        initial: existing ??
            DigitalCard(id: cardId!, userId: userId, firstName: '', lastName: ''),
        isNew: false,
      ),
      loading: () => const CupertinoPageScaffold(
        child: Center(child: CupertinoActivityIndicator()),
      ),
      error: (_, _) => CupertinoPageScaffold(child: Center(child: Text(l10n.commonError))),
    );
  }
}

class _EditPageBody extends HookConsumerWidget {
  const _EditPageBody({required this.initial, required this.isNew});

  final DigitalCard initial;
  final bool isNew;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final draft = useState(initial);
    final tabIndex = useState(0);
    final isSaving = useState(false);

    void update(DigitalCard Function(DigitalCard) updater) {
      draft.value = updater(draft.value);
    }

    Future<void> save() async {
      final missing = <String>[];
      if (draft.value.firstName.trim().isEmpty) missing.add(l10n.infoFirstName);
      if (draft.value.lastName.trim().isEmpty) missing.add(l10n.infoLastName);
      if ((draft.value.jobTitle ?? '').trim().isEmpty) missing.add(l10n.infoJobTitle);
      if ((draft.value.company ?? '').trim().isEmpty) missing.add(l10n.infoCompany);

      if (missing.isNotEmpty) {
        tabIndex.value = 0;
        if (context.mounted) {
          await showCupertinoDialog<void>(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: Text(l10n.cardValidationTitle),
              content: Text(
                '${l10n.cardValidationMessage}\n\n${missing.map((f) => '• $f').join('\n')}',
              ),
              actions: [
                CupertinoDialogAction(
                  child: Text(l10n.commonOk),
                  onPressed: () => Navigator.of(ctx).pop(),
                ),
              ],
            ),
          );
        }
        return;
      }

      isSaving.value = true;
      try {
        await ref.read(digitalCardRepositoryProvider).saveCard(draft.value);
        if (context.mounted) Navigator.of(context).pop();
      } catch (e) {
        if (context.mounted) await showErrorDialog(context, e);
      } finally {
        isSaving.value = false;
      }
    }

    final tabs = [
      InformationsTab(card: draft.value, onChanged: update),
      FieldsTab(card: draft.value, onChanged: update),
      DisplayTab(card: draft.value, onChanged: update),
    ];

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(isNew ? l10n.homeCreateCardButton : l10n.commonEdit),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: isSaving.value ? null : save,
          child: isSaving.value
              ? const CupertinoActivityIndicator()
              : Text(l10n.commonSave),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: CupertinoSlidingSegmentedControl<int>(
                groupValue: tabIndex.value,
                children: {
                  0: Text(l10n.editTabInformations),
                  1: Text(l10n.editTabFields),
                  2: Text(l10n.editTabDisplay),
                },
                onValueChanged: (v) => tabIndex.value = v ?? 0,
              ),
            ),
            Expanded(child: tabs[tabIndex.value]),
          ],
        ),
      ),
    );
  }
}
