import 'package:flutter/material.dart';

class TextIcon extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const TextIcon(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(fontSize: theme.size, color: theme.color),
    );
  }
}
