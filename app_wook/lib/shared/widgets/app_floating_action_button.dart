import 'package:flutter/material.dart';

class AppFloatingActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;
  final Widget label;

  const AppFloatingActionButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return FloatingActionButton.extended(
      backgroundColor: colors.secondary.withOpacity(onPressed != null ? 1.0 : 0.5),
      onPressed: onPressed,
      icon: icon,
      label: label,
    );
  }
}
