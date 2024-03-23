import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SvgIcon extends StatelessWidget {
  final String name;

  const SvgIcon.asset(this.name, {super.key});

  @override
  Widget build(BuildContext context) {
    final theme = IconTheme.of(context);
    final color = theme.color;

    return SvgPicture.asset(
      name,
      height: theme.size,
      width: theme.size,
      colorFilter: color != null ? ColorFilter.mode(color, BlendMode.srcIn) : null,
    );
  }
}
