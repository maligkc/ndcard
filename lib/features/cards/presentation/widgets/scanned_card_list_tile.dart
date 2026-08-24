import 'package:flutter/cupertino.dart';

import '../../../../core/domain/entities/scanned_card.dart';

class ScannedCardListTile extends StatelessWidget {
  const ScannedCardListTile({
    super.key,
    required this.card,
    required this.onTap,
    required this.onMore,
  });

  final ScannedCard card;
  final VoidCallback onTap;
  final VoidCallback onMore;

  @override
  Widget build(BuildContext context) {
    final name = card.fullName?.isNotEmpty == true ? card.fullName! : '—';
    final jobTitle = card.jobTitle?.isNotEmpty == true ? card.jobTitle : null;
    final company = card.company?.isNotEmpty == true ? card.company : null;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            // Kartvizit fotoğrafı — business card oranı (1.6:1)
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 120,
                height: 75,
                child: card.frontImageUrl != null
                    ? Image.network(
                        card.frontImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _placeholder(context),
                      )
                    : card.profileImageUrl != null
                        ? Image.network(
                            card.profileImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => _placeholder(context),
                          )
                        : _placeholder(context),
              ),
            ),
            const SizedBox(width: 12),
            // Metin
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                    ),
                  ),
                  if (jobTitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      jobTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                  if (company != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      company,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        color: CupertinoColors.secondaryLabel.resolveFrom(context),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            // Daha fazla butonu
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onMore,
              child: const Icon(CupertinoIcons.ellipsis, size: 20),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(BuildContext context) {
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
          ? Text(
              letters,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: CupertinoColors.secondaryLabel.resolveFrom(context),
              ),
            )
          : Icon(
              CupertinoIcons.person_alt,
              size: 28,
              color: CupertinoColors.secondaryLabel.resolveFrom(context),
            ),
    );
  }
}
