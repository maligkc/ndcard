import 'package:flutter/cupertino.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/card_group.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../core/widgets/form_sheet.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../application/groups_provider.dart';

class GroupsPage extends HookConsumerWidget {
  const GroupsPage({super.key});

  Future<void> _createGroup(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    final userId = ref.read(authStateChangesProvider).value?.id;
    if (userId == null) return;
    final result = await showFormSheet(
      context: context,
      title: l10n.groupsNewGroup,
      fields: [FormFieldSpec(key: 'name', label: l10n.groupsNamePlaceholder)],
    );
    final name = result?['name'];
    if (name == null || name.isEmpty) return;
    try {
      await ref.read(groupRepositoryProvider).createGroup(userId: userId, name: name);
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  Future<void> _renameGroup(BuildContext context, WidgetRef ref, CardGroup group) async {
    final l10n = AppLocalizations.of(context)!;
    final result = await showFormSheet(
      context: context,
      title: l10n.groupsRename,
      fields: [FormFieldSpec(key: 'name', label: l10n.groupsNamePlaceholder, initialText: group.name)],
    );
    final name = result?['name'];
    if (name == null || name.isEmpty) return;
    try {
      await ref.read(groupRepositoryProvider).renameGroup(id: group.id, name: name);
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  Future<void> _deleteGroup(BuildContext context, WidgetRef ref, CardGroup group) async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: Text(group.name),
        content: Text(l10n.groupsDeleteConfirm),
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
      await ref.read(groupRepositoryProvider).deleteGroup(group.id);
    } catch (e) {
      if (context.mounted) await showErrorDialog(context, e);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final query = useState('');
    final isEditing = useState(false);
    final groupsAsync = ref.watch(groupsProvider);
    final smartCountsAsync = ref.watch(smartGroupCountsProvider);

    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(l10n.cardsGroupsButton),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => isEditing.value = !isEditing.value,
          child: Text(isEditing.value ? l10n.commonSave : l10n.commonEdit),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: CupertinoSearchTextField(
                placeholder: l10n.groupsSearchPlaceholder,
                onChanged: (v) => query.value = v,
              ),
            ),
            Expanded(
              child: groupsAsync.when(
                data: (groups) {
                  final filtered = groups
                      .where((g) => g.name.toLowerCase().contains(query.value.toLowerCase()))
                      .toList();
                  return ListView(
                    children: [
                      CupertinoListSection.insetGrouped(
                        children: [
                          for (final group in filtered)
                            CupertinoListTile(
                              title: Text(group.name),
                              trailing: isEditing.value
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () => _renameGroup(context, ref, group),
                                          child: const Icon(CupertinoIcons.pencil),
                                        ),
                                        CupertinoButton(
                                          padding: EdgeInsets.zero,
                                          onPressed: () => _deleteGroup(context, ref, group),
                                          child: const Icon(CupertinoIcons.delete,
                                              color: CupertinoColors.destructiveRed),
                                        ),
                                      ],
                                    )
                                  : Text('${group.cardCount}'),
                              onTap: isEditing.value
                                  ? null
                                  : () => context.push(
                                        '/groups/${group.id}',
                                        extra: group.name,
                                      ),
                            ),
                          CupertinoListTile(
                            title: Text(l10n.groupsNewGroup),
                            leading: const Icon(CupertinoIcons.add_circled),
                            onTap: () => _createGroup(context, ref),
                          ),
                        ],
                      ),
                      smartCountsAsync.when(
                        data: (counts) => CupertinoListSection.insetGrouped(
                          header: Text(l10n.groupsSmartGroups),
                          children: [
                            CupertinoListTile(
                              title: Text(l10n.groupsRecentlyViewed),
                              trailing: Text('${counts.recentlyViewed}'),
                              onTap: () => context.push('/groups/smart/recently_viewed'),
                            ),
                            CupertinoListTile(
                              title: Text(l10n.groupsRecentlyAdded),
                              trailing: Text('${counts.recentlyAdded}'),
                              onTap: () => context.push('/groups/smart/recently_added'),
                            ),
                            CupertinoListTile(
                              title: Text(l10n.groupsUngrouped),
                              trailing: Text('${counts.ungrouped}'),
                              onTap: () => context.push('/groups/smart/ungrouped'),
                            ),
                          ],
                        ),
                        loading: () => const SizedBox.shrink(),
                        error: (_, _) => const SizedBox.shrink(),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CupertinoActivityIndicator()),
                error: (_, _) => Center(child: Text(l10n.commonError)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
