import 'package:flutter/material.dart';

class Paragraph extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final Widget title;
  final Widget child;

  const Paragraph({
    super.key,
    this.padding = EdgeInsets.zero,
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: DefaultTextStyle(
            style: textTheme.titleSmall!,
            child: title,
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
          child: Padding(
            padding: padding,
            child: child,
          ),
        ),
      ],
    );
  }
}

class ParagraphTile extends StatelessWidget {
  final Widget title;
  final Widget trailing;

  const ParagraphTile({
    super.key,
    required this.title,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: kMinInteractiveDimension),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        child: Row(
          children: [
            title,
            const Spacer(),
            trailing,
          ],
        ),
      ),
    );
  }
}
