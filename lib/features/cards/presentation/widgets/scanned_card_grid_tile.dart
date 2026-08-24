import 'package:flutter/cupertino.dart';

import '../../../../core/domain/entities/scanned_card.dart';

class ScannedCardGridTile extends StatelessWidget {
  const ScannedCardGridTile({
    super.key,
    required this.card,
    required this.selected,
    required this.selectionMode,
    required this.onTap,
  });

  final ScannedCard card;
  final bool selected;
  final bool selectionMode;
  final VoidCallback onTap;

  Widget _gridPlaceholder(BuildContext context) {
    final name = card.fullName?.trim() ?? '';
    final parts = name.split(' ').where((s) => s.isNotEmpty).toList();
    final letters = parts.length >= 2
        ? '${parts.first[0]}${parts.last[0]}'.toUpperCase()
        : name.isNotEmpty
            ? name[0].toUpperCase()
            : '';
    return Container(
      color: CupertinoColors.systemGrey5.resolveFrom(context),
      alignment: Alignment.center,
      child: letters.isNotEmpty
          ? Text(letters,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ))
          : Icon(CupertinoIcons.person_alt,
              size: 32, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected
                ? CupertinoColors.activeBlue.resolveFrom(context)
                : CupertinoColors.systemGrey4.resolveFrom(context),
            width: selected ? 2 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      card.frontImageUrl != null
                          ? Image.network(card.frontImageUrl!, fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => _gridPlaceholder(context))
                          : card.profileImageUrl != null
                              ? Image.network(card.profileImageUrl!, fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => _gridPlaceholder(context))
                              : _gridPlaceholder(context),
                      if (card.profileImageUrl != null)
                        Positioned(
                          bottom: 6,
                          left: 6,
                          child: ClipOval(
                            child: Image.network(
                              card.profileImageUrl!,
                              width: 32,
                              height: 32,
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const SizedBox.shrink(),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        card.fullName?.isNotEmpty == true ? card.fullName! : '—',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                      if (card.company != null && card.company!.isNotEmpty)
                        Text(
                          card.company!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel.resolveFrom(context)),
                        ),
                    ],
                  ),
                ),
              ],
            ),
            if (selectionMode)
              Positioned(
                right: 6,
                top: 6,
                child: Icon(
                  selected ? CupertinoIcons.checkmark_circle_fill : CupertinoIcons.circle,
                  color: selected ? CupertinoColors.activeBlue : CupertinoColors.white,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
