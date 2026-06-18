import 'package:flutter/material.dart';

/// Draws the marquee rectangle the user is dragging to zoom into. A semi
/// transparent fill with a solid border, matching the chart's accent color.
class SelectionBoxPainter extends CustomPainter {
  const SelectionBoxPainter({this.box});

  final Rect? box;

  @override
  void paint(Canvas canvas, Size size) {
    if (box == null) {
      return;
    }

    canvas.drawRect(
      box!,
      Paint()
        ..color = const Color(0x220078A8)
        ..style = PaintingStyle.fill,
    );
    canvas.drawRect(
      box!,
      Paint()
        ..color = const Color(0xFF0078A8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
    );
  }

  @override
  bool shouldRepaint(SelectionBoxPainter old) => old.box != box;
}
