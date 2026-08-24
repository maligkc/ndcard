import 'package:flutter/cupertino.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/domain/entities/digital_card.dart';
import '../../../../core/widgets/platform_icon.dart';
import '../../domain/card_theme_preset.dart';

/// NDCard paylaşım linki için yer tutucu domain. Gerçek bir genel kart
/// görüntüleme sayfası (web) yayına alındığında burası güncellenmelidir.
String shareUrlForSlug(String slug) => 'https://ndcard.app/c/$slug';

String _initials(String fullName) {
  final parts = fullName.trim().split(RegExp(r'\s+'));
  if (parts.isEmpty || parts.first.isEmpty) return '';
  if (parts.length == 1) return parts.first[0].toUpperCase();
  return (parts.first[0] + parts.last[0]).toUpperCase();
}

class DigitalCardView extends StatelessWidget {
  const DigitalCardView({super.key, required this.card, this.height = 200});

  final DigitalCard card;
  final double height;

  @override
  Widget build(BuildContext context) {
    final theme = cardThemeByKey(card.theme);
    final shareUrl = card.shareSlug != null ? shareUrlForSlug(card.shareSlug!) : null;

    return Container(
      height: height,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.background,
        borderRadius: BorderRadius.circular(20),
        gradient: theme.gradient != null
            ? LinearGradient(
                colors: theme.gradient!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        boxShadow: const [
          BoxShadow(color: Color(0x22000000), blurRadius: 12, offset: Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (card.company != null && card.company!.isNotEmpty)
                  Text(
                    card.company!,
                    style: TextStyle(
                      color: theme.foreground.withValues(alpha: 0.8),
                      fontSize: 13,
                    ),
                  ),
                const SizedBox(height: 6),
                Text(
                  card.fullName,
                  style: TextStyle(
                    color: theme.foreground,
                    fontSize: 20,
                    fontWeight: theme.fontWeight,
                  ),
                ),
                if (card.jobTitle != null && card.jobTitle!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    card.jobTitle!,
                    style: TextStyle(
                      color: theme.foreground.withValues(alpha: 0.8),
                      fontSize: 14,
                    ),
                  ),
                ],
                if (card.fields.isNotEmpty) ...[
                  const SizedBox(height: 10),
                  _FieldIconsRow(card: card, theme: theme),
                ],
              ],
            ),
          ),
          _AvatarWidget(card: card, theme: theme),
          const SizedBox(width: 12),
          if (shareUrl != null)
            ColoredBox(
              color: CupertinoColors.white,
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: QrImageView(data: shareUrl, size: height - 40, gapless: true),
              ),
            ),
        ],
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  const _AvatarWidget({required this.card, required this.theme});

  final DigitalCard card;
  final CardThemePreset theme;

  @override
  Widget build(BuildContext context) {
    if (card.photoUrl != null && card.photoUrl!.isNotEmpty) {
      return ClipOval(
        child: Image.network(
          card.photoUrl!,
          width: 56,
          height: 56,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => _InitialsCircle(card: card, theme: theme),
        ),
      );
    }

    return _InitialsCircle(card: card, theme: theme);
  }
}

class _FieldIconsRow extends StatelessWidget {
  const _FieldIconsRow({required this.card, required this.theme});
  final DigitalCard card;
  final CardThemePreset theme;

  @override
  Widget build(BuildContext context) {
    final sorted = [...card.fields]
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    // Maksimum 6 ikon göster, fazlası için "+N" badge
    const maxVisible = 6;
    final visible = sorted.take(maxVisible).toList();
    final extra = sorted.length - maxVisible;

    return Row(
      children: [
        for (final field in visible) ...[
          PlatformIcon(field.platform, size: 22, fallbackColor: theme.foreground),
          const SizedBox(width: 6),
        ],
        if (extra > 0)
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: theme.foreground.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              '+$extra',
              style: TextStyle(
                color: theme.foreground,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
      ],
    );
  }
}

class _InitialsCircle extends StatelessWidget {
  const _InitialsCircle({required this.card, required this.theme});

  final DigitalCard card;
  final CardThemePreset theme;

  @override
  Widget build(BuildContext context) {
    final initials = _initials(card.fullName);
    if (initials.isEmpty) return const SizedBox(width: 56, height: 56);

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.foreground.withValues(alpha: 0.15),
      ),
      alignment: Alignment.center,
      child: Text(
        initials,
        style: TextStyle(
          color: theme.foreground,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
