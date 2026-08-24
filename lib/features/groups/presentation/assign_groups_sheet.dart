import 'package:flutter/cupertino.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/backend_providers.dart';
import '../../../core/domain/entities/card_group.dart';
import '../../../core/widgets/error_dialog.dart';
import '../../../l10n/gen/app_localizations.dart';
import '../application/groups_provider.dart';

/// Tek bir kartın gruplarını yönetmek için alttan sheet: her grup bir
/// switch ile açılıp kapatılır (addCardToGroup / removeCardFromGroup).
Future<void> showAssignGroupsSheet(
  BuildContext context,
  WidgetRef ref, {
  required String cardId,
}) async {
  final l10n = AppLocalizations.of(context)!;
  final groups = await ref.read(groupsProvider.future);
  final currentGroupIds =
      (await ref.read(groupRepositoryProvider).getGroupIdsForCard(cardId)).toSet();

  if (!context.mounted) return;

  await showCupertinoModalPopup<void>(
    context: context,
    builder: (context) => _AssignGroupsContent(
      title: l10n.cardActionManageGroups,
      groups: groups,
      initialSelected: currentGroupIds,
      onToggle: (groupId, selected) async {
        try {
          if (selected) {
            await ref
                .read(groupRepositoryProvider)
                .addCardToGroup(groupId: groupId, cardId: cardId);
          } else {
            await ref
                .read(groupRepositoryProvider)
                .removeCardFromGroup(groupId: groupId, cardId: cardId);
          }
        } catch (e) {
          if (context.mounted) await showErrorDialog(context, e);
        }
      },
    ),
  );
}

class _AssignGroupsContent extends StatefulWidget {
  const _AssignGroupsContent({
    required this.title,
    required this.groups,
    required this.initialSelected,
    required this.onToggle,
  });

  final String title;
  final List<CardGroup> groups;
  final Set<String> initialSelected;
  final Future<void> Function(String groupId, bool selected) onToggle;

  @override
  State<_AssignGroupsContent> createState() => _AssignGroupsContentState();
}

class _AssignGroupsContentState extends State<_AssignGroupsContent> {
  late final Set<String> _selected = {...widget.initialSelected};

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(middle: Text(widget.title)),
      child: SafeArea(
        child: ListView(
          children: [
            CupertinoListSection.insetGrouped(
              children: [
                for (final group in widget.groups)
                  CupertinoListTile(
                    title: Text(group.name),
                    trailing: CupertinoSwitch(
                      value: _selected.contains(group.id),
                      onChanged: (value) {
                        setState(() {
                          if (value) {
                            _selected.add(group.id);
                          } else {
                            _selected.remove(group.id);
                          }
                        });
                        widget.onToggle(group.id, value);
                      },
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
