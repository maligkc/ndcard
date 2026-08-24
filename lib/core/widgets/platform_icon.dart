import 'package:flutter/cupertino.dart';

import '../utils/supported_platforms.dart';

/// Platform key'ine göre gerçek marka ikonu ya da fallback CupertinoIcon döner.
class PlatformIcon extends StatelessWidget {
  const PlatformIcon(this.platformKey, {super.key, this.size = 30, this.fallbackColor});

  final String platformKey;
  final double size;
  final Color? fallbackColor;

  @override
  Widget build(BuildContext context) {
    final w = size;
    final r = size / 4; // corner radius

    Widget circle(Color bg, Widget child) => _Tile(
          size: w, radius: w / 2, color: bg, child: child);

    Widget rounded(Color bg, Widget child) => _Tile(
          size: w, radius: r, color: bg, child: child);

    Widget iconW(IconData i, Color fg) =>
        Icon(i, size: w * 0.58, color: fg);

    Widget label(String t, Color fg,
            {double? fontSize, FontWeight fw = FontWeight.bold}) =>
        Text(t,
            style: TextStyle(
                color: fg,
                fontSize: fontSize ?? w * 0.42,
                fontWeight: fw,
                height: 1));

    switch (platformKey) {
      // ── Social ──────────────────────────────────────────────────────────────
      case 'instagram':
        return _InstagramIcon(size: w);

      case 'facebook':
        return circle(
          const Color(0xFF1877F2),
          label('f', CupertinoColors.white,
              fontSize: w * 0.52, fw: FontWeight.w900),
        );

      case 'x':
        return circle(
          CupertinoColors.black,
          label('𝕏', CupertinoColors.white, fontSize: w * 0.40),
        );

      case 'tiktok':
        return rounded(
          CupertinoColors.black,
          _TikTokIcon(size: w),
        );

      case 'snapchat':
        return rounded(
          const Color(0xFFFFFC00),
          label('👻', CupertinoColors.black, fontSize: w * 0.44),
        );

      case 'pinterest':
        return circle(
          const Color(0xFFE60023),
          label('P', CupertinoColors.white,
              fontSize: w * 0.48, fw: FontWeight.w900),
        );

      case 'threads':
        return circle(
          CupertinoColors.black,
          label('@', CupertinoColors.white, fontSize: w * 0.38),
        );

      case 'weibo':
        return circle(
          const Color(0xFFE6162D),
          label('W', CupertinoColors.white, fontSize: w * 0.40),
        );

      // ── Professional ────────────────────────────────────────────────────────
      case 'linkedin':
        return rounded(
          const Color(0xFF0A66C2),
          label('in', CupertinoColors.white, fontSize: w * 0.38),
        );

      case 'github':
        return circle(
          const Color(0xFF24292E),
          label('GH', CupertinoColors.white,
              fontSize: w * 0.28, fw: FontWeight.w800),
        );

      case 'behance':
        return rounded(
          const Color(0xFF1769FF),
          label('Bē', CupertinoColors.white, fontSize: w * 0.32),
        );

      case 'dribbble':
        return circle(
          const Color(0xFFEA4C89),
          label('Dr', CupertinoColors.white, fontSize: w * 0.30),
        );

      case 'xing':
        return rounded(
          const Color(0xFF006567),
          label('X', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w900),
        );

      // ── Messaging ───────────────────────────────────────────────────────────
      case 'whatsapp':
        return circle(
          const Color(0xFF25D366),
          iconW(CupertinoIcons.phone_fill, CupertinoColors.white),
        );

      case 'telegram':
        return circle(
          const Color(0xFF229ED9),
          iconW(CupertinoIcons.paperplane_fill, CupertinoColors.white),
        );

      case 'discord':
        return rounded(
          const Color(0xFF5865F2),
          label('D', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w800),
        );

      case 'wechat':
        return rounded(
          const Color(0xFF07C160),
          iconW(CupertinoIcons.chat_bubble_2_fill, CupertinoColors.white),
        );

      case 'line':
        return rounded(
          const Color(0xFF06C755),
          label('L', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w900),
        );

      case 'signal':
        return circle(
          const Color(0xFF3A76F0),
          iconW(CupertinoIcons.lock_fill, CupertinoColors.white),
        );

      case 'qq':
        return circle(
          const Color(0xFF12B7F5),
          label('QQ', CupertinoColors.white, fontSize: w * 0.28),
        );

      // ── Video ───────────────────────────────────────────────────────────────
      case 'youtube':
        return rounded(
          const Color(0xFFFF0000),
          iconW(CupertinoIcons.play_fill, CupertinoColors.white),
        );

      case 'twitch':
        return rounded(
          const Color(0xFF9146FF),
          label('t', CupertinoColors.white,
              fontSize: w * 0.48, fw: FontWeight.w900),
        );

      case 'vimeo':
        return circle(
          const Color(0xFF1AB7EA),
          label('v', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w700),
        );

      case 'brightcove':
        return circle(
          const Color(0xFF2F6EE8),
          iconW(CupertinoIcons.play_circle_fill, CupertinoColors.white),
        );

      // ── Music ───────────────────────────────────────────────────────────────
      case 'spotify':
        return circle(
          const Color(0xFF1DB954),
          iconW(CupertinoIcons.music_note, CupertinoColors.white),
        );

      case 'apple_music':
        return _AppleMusicIcon(size: w);

      case 'soundcloud':
        return circle(
          const Color(0xFFFF5500),
          iconW(CupertinoIcons.waveform, CupertinoColors.white),
        );

      // ── Payments ────────────────────────────────────────────────────────────
      case 'paypal':
        return rounded(
          const Color(0xFF003087),
          label('P', CupertinoColors.white,
              fontSize: w * 0.48, fw: FontWeight.w900),
        );

      case 'venmo':
        return rounded(
          const Color(0xFF3D95CE),
          label('V', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w700),
        );

      case 'cashapp':
        return rounded(
          const Color(0xFF00D632),
          label('\$', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w700),
        );

      case 'zelle':
        return circle(
          const Color(0xFF6D1ED4),
          label('Z', CupertinoColors.white,
              fontSize: w * 0.42, fw: FontWeight.w800),
        );

      // ── Business/Productivity ────────────────────────────────────────────────
      case 'zoom':
        return rounded(
          const Color(0xFF2D8CFF),
          iconW(CupertinoIcons.videocam_fill, CupertinoColors.white),
        );

      case 'teams':
        return rounded(
          const Color(0xFF5558AF),
          label('T', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w800),
        );

      case 'meet':
        return _GoogleMeetIcon(size: w);

      case 'skype':
        return circle(
          const Color(0xFF00AFF0),
          label('S', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w700),
        );

      case 'webex':
        return circle(
          const Color(0xFF00B140),
          label('W', CupertinoColors.white, fontSize: w * 0.38),
        );

      case 'calendly':
        return rounded(
          const Color(0xFF006BFF),
          iconW(CupertinoIcons.calendar, CupertinoColors.white),
        );

      case 'ms_bookings':
        return rounded(
          const Color(0xFF0078D4),
          iconW(CupertinoIcons.calendar_badge_plus, CupertinoColors.white),
        );

      case 'patreon':
        return circle(
          const Color(0xFFFF424D),
          label('P', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w900),
        );

      case 'yelp':
        return circle(
          const Color(0xFFAF0606),
          iconW(CupertinoIcons.star_fill, CupertinoColors.white),
        );

      // ── Gaming ──────────────────────────────────────────────────────────────
      case 'psn':
        return rounded(
          const Color(0xFF003791),
          label('PS', CupertinoColors.white, fontSize: w * 0.28),
        );

      case 'xbox_live':
        return circle(
          const Color(0xFF107C10),
          label('X', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w900),
        );

      case 'nintendo':
        return circle(
          const Color(0xFFE4000F),
          label('N', CupertinoColors.white,
              fontSize: w * 0.44, fw: FontWeight.w900),
        );

      // ── Generic/Fallback ────────────────────────────────────────────────────
      default:
        final platform = platformByKey(platformKey);
        return Icon(platform.icon, size: w * 0.75, color: fallbackColor);
    }
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _Tile extends StatelessWidget {
  const _Tile({
    required this.size,
    required this.radius,
    required this.color,
    required this.child,
  });

  final double size;
  final double radius;
  final Color color;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: child,
    );
  }
}

// ─── Custom brand icons ────────────────────────────────────────────────────────

class _InstagramIcon extends StatelessWidget {
  const _InstagramIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 4),
        gradient: const LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [
            Color(0xFF833AB4),
            Color(0xFFE1306C),
            Color(0xFFF77737),
            Color(0xFFFCAF45),
          ],
        ),
      ),
      child: Icon(
        CupertinoIcons.camera,
        size: size * 0.52,
        color: CupertinoColors.white,
      ),
    );
  }
}

class _TikTokIcon extends StatelessWidget {
  const _TikTokIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          right: size * 0.18,
          child: Icon(CupertinoIcons.music_note,
              size: size * 0.52, color: const Color(0xFF69C9D0)),
        ),
        Positioned(
          left: size * 0.18,
          child: Icon(CupertinoIcons.music_note,
              size: size * 0.52, color: const Color(0xFFEE1D52)),
        ),
        Icon(CupertinoIcons.music_note,
            size: size * 0.52, color: CupertinoColors.white),
      ],
    );
  }
}

class _AppleMusicIcon extends StatelessWidget {
  const _AppleMusicIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size / 4),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFC5C7D), Color(0xFF6A3093)],
        ),
      ),
      child: Icon(
        CupertinoIcons.music_note_list,
        size: size * 0.52,
        color: CupertinoColors.white,
      ),
    );
  }
}

class _GoogleMeetIcon extends StatelessWidget {
  const _GoogleMeetIcon({required this.size});
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(size / 4),
        border: Border.all(
          color: CupertinoColors.systemGrey4.resolveFrom(context),
        ),
      ),
      child: CustomPaint(
        painter: _MeetPainter(),
      ),
    );
  }
}

class _MeetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final colors = [
      const Color(0xFF4285F4),
      const Color(0xFF34A853),
      const Color(0xFFFBBC04),
      const Color(0xFFEA4335),
    ];
    final r = size.width * 0.14;
    final cx = size.width / 2;
    final cy = size.height / 2;
    final offsets = [
      Offset(cx - r, cy - r),
      Offset(cx + r, cy - r),
      Offset(cx + r, cy + r),
      Offset(cx - r, cy + r),
    ];
    for (var i = 0; i < 4; i++) {
      canvas.drawCircle(
          offsets[i], r * 0.9, Paint()..color = colors[i]);
    }
  }

  @override
  bool shouldRepaint(_) => false;
}
