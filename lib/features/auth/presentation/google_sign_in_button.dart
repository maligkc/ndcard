import 'dart:math';

import 'package:flutter/cupertino.dart';

class GoogleSignInButton extends StatelessWidget {
  const GoogleSignInButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
  });

  final bool isLoading;
  final VoidCallback onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(vertical: 14),
        color: CupertinoColors.white,
        borderRadius: BorderRadius.circular(10),
        onPressed: isLoading ? null : onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 22,
              height: 22,
              child: CustomPaint(painter: _GoogleGPainter()),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                color: CupertinoColors.black,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoogleGPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.44;
    final strokeW = size.width * 0.2;
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);

    Paint arc(Color color) => Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    // Gap: 330° → 30° (right side, mouth of G)
    // Green: 30° → 90°
    canvas.drawArc(rect, pi / 6, pi / 3, false, arc(const Color(0xFF34A853)));
    // Yellow: 90° → 150°
    canvas.drawArc(rect, pi / 2, pi / 3, false, arc(const Color(0xFFFBBC05)));
    // Red: 150° → 270°
    canvas.drawArc(rect, 5 * pi / 6, 2 * pi / 3, false, arc(const Color(0xFFEA4335)));
    // Blue: 270° → 330°
    canvas.drawArc(rect, 3 * pi / 2, pi / 3, false, arc(const Color(0xFF4285F4)));

    // Blue horizontal bar (the flat part of G)
    canvas.drawRect(
      Rect.fromLTRB(
        cx - strokeW * 0.1,
        cy - strokeW / 2,
        cx + r + strokeW / 2,
        cy + strokeW / 2,
      ),
      Paint()..color = const Color(0xFF4285F4),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
