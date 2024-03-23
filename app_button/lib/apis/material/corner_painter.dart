import 'package:flutter/material.dart';

class CornerPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double length;
  final double width;

  const CornerPainter({
    this.color = Colors.black,
    required this.radius,
    required this.length,
    this.width = 1.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final sh = size.height; // for convenient shortage
    final sw = size.width; // for convenient shortage

    final paint = Paint()
      ..color = color
      ..strokeWidth = width
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path()
      // Top Left
      ..moveTo(radius + length, 0)
      ..relativeLineTo(-length, 0)
      ..quadraticBezierTo(0, 0, 0, radius)
      ..relativeLineTo(0, length)
      // Bottom Left
      ..moveTo(0, sh - radius - length)
      ..relativeLineTo(0, length)
      ..quadraticBezierTo(0, sh, radius, sh)
      ..relativeLineTo(length, 0)
      // Bottom Right
      ..moveTo(sw - radius - length, sh)
      ..relativeLineTo(length, 0)
      ..quadraticBezierTo(sw, sh, sw, sh - radius)
      ..relativeLineTo(0, -length)
      // Top Right
      ..moveTo(sw, radius + length)
      ..relativeLineTo(0, -length)
      ..quadraticBezierTo(sw, 0, sw - radius, 0)
      ..relativeLineTo(-length, 0);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CornerPainter oldDelegate) =>
      color != oldDelegate.color ||
      radius != oldDelegate.radius ||
      length != oldDelegate.length ||
      width != oldDelegate.width;

  @override
  bool shouldRebuildSemantics(CornerPainter oldDelegate) => false;
}
