import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SliverFieldsLayout extends StatelessWidget {
  final List<Widget> children;

  const SliverFieldsLayout({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.all(16.0),
      sliver: SliverAlignedGrid.extent(
        crossAxisSpacing: 8.0,
        mainAxisSpacing: 8.0,
        maxCrossAxisExtent: 576.0,
        itemCount: children.length,
        itemBuilder: (context, index) => Align(
          alignment: Alignment.bottomCenter,
          child: children[index],
        ),
      ),
    );
  }
}
