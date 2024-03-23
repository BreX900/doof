import 'package:flutter/material.dart';

class AppInfoView extends StatelessWidget {
  final Widget header;
  final Widget title;
  final Widget? subtitle;
  final Widget? action;

  const AppInfoView({
    super.key,
    required this.header,
    required this.title,
    this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = this.subtitle;
    final action = this.action;

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Padding(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 3),
          header,
          const Spacer(),
          DefaultTextStyle(
            style: textTheme.titleLarge!,
            textAlign: TextAlign.center,
            child: title,
          ),
          const Spacer(),
          if (subtitle != null)
            DefaultTextStyle(
              style: textTheme.titleMedium!,
              textAlign: TextAlign.center,
              child: subtitle,
            ),
          const Spacer(),
          if (action != null) action,
          const Spacer(flex: 4),
        ],
      ),
    );
  }
}
