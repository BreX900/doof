import 'package:flutter/widgets.dart';

class PointedList extends StatelessWidget {
  final Widget title;
  final List<Widget> children;

  const PointedList({
    super.key,
    required this.title,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          title,
          const SizedBox(height: 6.0),
          ...children.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: e,
            );
          }),
        ],
      ),
    );
  }
}
