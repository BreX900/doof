import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SliverCardsLayout extends StatelessWidget {
  final List<Widget> children;

  const SliverCardsLayout({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverMasonryGrid.extent(
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        maxCrossAxisExtent: 1024.0,
        childCount: children.length,
        itemBuilder: (context, index) => children[index],
      ),
    );
  }
}
