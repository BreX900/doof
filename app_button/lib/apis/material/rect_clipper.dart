import 'package:flutter/rendering.dart';

class RectClipper extends CustomClipper<Rect> {
  final double? top;
  final double? height;

  const RectClipper({
    this.top,
    this.height,
  });

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, top ?? 0, size.width, height ?? size.height);

  @override
  bool shouldReclip(covariant RectClipper oldClipper) =>
      top != oldClipper.top || height != oldClipper.height;
}
