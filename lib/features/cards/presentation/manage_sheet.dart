import 'package:flutter/cupertino.dart';

import '../../../core/domain/repositories/scanned_card_repository.dart';
import '../../../l10n/gen/app_localizations.dart';

/// "Yönet" alttan sheet: Sıralama / Toplu Seçim / Kartvizit Yönetimi.
/// Dönüş değeri [ManageSheetResult] — CardsPage sonucu işler.
enum ManageAction {
  bulkSelect,
  import,
  dedup,
  browse,
  highAccuracy,
  recycleBin,
}

class ManageSheetResult {
  const ManageSheetResult.sort(this.sort) : action = null;
  const ManageSheetResult.action(ManageAction this.action) : sort = null;

  final ScannedCardSort? sort;
  final ManageAction? action;
}

Future<ManageSheetResult?> showManageSheet(
  BuildContext context, {
  required ScannedCardSort currentSort,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showCupertinoModalPopup<ManageSheetResult>(
    context: context,
    builder: (context) => CupertinoActionSheet(
      title: Text(l10n.cardsManageButton),
      message: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: Text(l10n.cardsSortTitle, style: const TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      actions: [
        _sortAction(context, l10n.cardsSortByDate, ScannedCardSort.date, currentSort),
        _sortAction(context, l10n.cardsSortByName, ScannedCardSort.name, currentSort),
        _sortAction(context, l10n.cardsSortByCompany, ScannedCardSort.company, currentSort),
        CupertinoActionSheetAction(
          onPressed: () =>
              Navigator.of(context).pop(const ManageSheetResult.action(ManageAction.bulkSelect)),
          child: Text(l10n.manageBulkSelect),
        ),
        CupertinoActionSheetAction(
          onPressed: () =>
              Navigator.of(context).pop(const ManageSheetResult.action(ManageAction.import)),
          child: Text(l10n.manageImport),
        ),
        CupertinoActionSheetAction(
          onPressed: () =>
              Navigator.of(context).pop(const ManageSheetResult.action(ManageAction.dedup)),
          child: Text(l10n.manageDedup),
        ),
        CupertinoActionSheetAction(
          onPressed: () =>
              Navigator.of(context).pop(const ManageSheetResult.action(ManageAction.browse)),
          child: Text(l10n.manageBrowse),
        ),
        CupertinoActionSheetAction(
          onPressed: () => Navigator.of(context)
              .pop(const ManageSheetResult.action(ManageAction.highAccuracy)),
          child: Text(l10n.manageHighAccuracy),
        ),
        CupertinoActionSheetAction(
          onPressed: () =>
              Navigator.of(context).pop(const ManageSheetResult.action(ManageAction.recycleBin)),
          child: Text(l10n.manageRecycleBin),
        ),
      ],
      cancelButton: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () => Navigator.of(context).pop(),
        child: Text(l10n.commonCancel),
      ),
    ),
  );
}

CupertinoActionSheetAction _sortAction(
  BuildContext context,
  String label,
  ScannedCardSort value,
  ScannedCardSort current,
) {
  return CupertinoActionSheetAction(
    onPressed: () => Navigator.of(context).pop(ManageSheetResult.sort(value)),
    child: Text(value == current ? '✓ $label' : label),
  );
}
