import 'package:flutter/material.dart';

class CrosshairPainter extends CustomPainter {
  const CrosshairPainter({
    this.xPosition,
    this.dots = const [],
  });

  final double? xPosition;
  final List<({Offset position, Color color})> dots;

  @override
  void paint(Canvas canvas, Size size) {
    final x = xPosition;
    if (x == null || !x.isFinite) {
      return;
    }

    final linePaint = Paint()
      ..color = Colors.black45
      ..strokeWidth = 1.0;
    const dashHeight = 5.0;
    const dashSpace = 4.0;
    double y = 0;
    while (y < size.height) {
      canvas.drawLine(
        Offset(x, y),
        Offset(x, (y + dashHeight).clamp(0, size.height)),
        linePaint,
      );
      y += dashHeight + dashSpace;
    }

    for (final dot in dots) {
      if (!dot.position.dx.isFinite || !dot.position.dy.isFinite) {
        continue;
      }
      canvas.drawCircle(
        dot.position,
        5.0,
        Paint()
          ..color = dot.color
          ..style = PaintingStyle.fill,
      );
      canvas.drawCircle(
        dot.position,
        5.0,
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.0,
      );
    }
  }

  @override
  bool shouldRepaint(CrosshairPainter old) => old.xPosition != xPosition || old.dots != dots;
}
