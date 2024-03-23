import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TextIcon extends StatelessWidget {
  final String text;

  const TextIcon(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    final iconTheme = IconTheme.of(context);

    return SizedBox(
      width: 40.0,
      height: 40.0,
      child: Center(
        child: Text(text, style: TextStyle(fontSize: iconTheme.size ?? 24.0)),
      ),
    );
  }
}
