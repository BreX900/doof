import 'package:flutter/widgets.dart';

class AdminBodyLayout extends StatelessWidget {
  final List<Widget> slivers;

  const AdminBodyLayout({
    super.key,
    required this.slivers,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 576.0 * 3),
        child: CustomScrollView(
          slivers: slivers,
        ),
      ),
    );
  }
}
