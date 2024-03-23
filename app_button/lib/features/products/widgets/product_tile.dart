import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  final EdgeInsetsGeometry margin;
  final VoidCallback? onTap;
  final Widget? leading;
  final Widget title;
  final Widget label;
  final Widget subtitle;
  final Widget? trailing;
  final List<Widget> footers;

  const ProductTile({
    super.key,
    this.margin = EdgeInsets.zero,
    this.onTap,
    this.leading,
    required this.title,
    required this.label,
    required this.subtitle,
    this.trailing,
    required this.footers,
  });

  @override
  Widget build(BuildContext context) {
    final leading = this.leading;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;

    final children = [
      if (leading != null) ...[
        const SizedBox(width: 8.0),
        ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10000.0)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 64.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: FittedBox(
                fit: BoxFit.cover,
                child: leading,
              ),
            ),
          ),
        ),
      ],
      const SizedBox(width: 16.0),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DefaultTextStyle(
            style: textTheme.titleMedium!,
            child: title,
          ),
          const SizedBox(height: 2.0),
          DefaultTextStyle(
            style: textTheme.bodySmall!,
            child: label,
          ),
          const SizedBox(height: 2.0),
          DefaultTextStyle(
            style: textTheme.titleSmall!.copyWith(
              color: colors.primary,
              fontWeight: FontWeight.bold,
            ),
            child: subtitle,
          ),
        ],
      ),
      if (trailing != null) ...[
        const Spacer(),
        trailing!,
      ],
    ];

    return Card(
      margin: margin,
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: const BoxConstraints(minHeight: 64.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: children,
                ),
              ),
              if (footers.isNotEmpty) ...[
                const Divider(),
                ...footers,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ProductParagraphTile extends StatelessWidget {
  final Widget title;
  final Widget content;

  const ProductParagraphTile({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return ListTile(
      dense: true,
      minVerticalPadding: 0,
      titleTextStyle: textTheme.labelMedium,
      subtitleTextStyle: textTheme.bodySmall,
      title: title,
      subtitle: content,
    );
  }
}
