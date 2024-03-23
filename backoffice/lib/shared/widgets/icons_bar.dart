import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

class IconsBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onSelected;
  final List<Widget> icons;

  const IconsBar({
    super.key,
    required this.currentIndex,
    required this.onSelected,
    required this.icons,
  });

  @override
  Widget build(BuildContext context) {
    final onSelected = this.onSelected;

    final theme = Theme.of(context);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: icons.mapIndexed((index, e) {
        return IconButton(
          color: currentIndex == index ? theme.colorScheme.primary : null,
          onPressed: onSelected != null ? () => onSelected(index) : null,
          icon: e,
        );
      }).toList(),
    );
  }
}
