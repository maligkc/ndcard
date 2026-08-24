import 'package:flutter/cupertino.dart';

import '../../../../core/domain/entities/digital_card.dart';
import '../../../../l10n/gen/app_localizations.dart';
import '../../domain/card_theme_preset.dart';
import '../card_updater.dart';
import '../widgets/digital_card_view.dart';

class DisplayTab extends StatelessWidget {
  const DisplayTab({super.key, required this.card, required this.onChanged});

  final DigitalCard card;
  final CardUpdater onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(l10n.displayThemeGallery, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),
        for (final theme in kCardThemes)
          Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: GestureDetector(
              onTap: () => onChanged((c) => c.copyWith(theme: theme.key)),
              child: Stack(
                children: [
                  DigitalCardView(card: card.copyWith(theme: theme.key), height: 140),
                  if (card.theme == theme.key)
                    const Positioned(
                      right: 12,
                      top: 12,
                      child: Icon(
                        CupertinoIcons.check_mark_circled_solid,
                        color: CupertinoColors.activeGreen,
                        size: 24,
                      ),
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
