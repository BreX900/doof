import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AppButtonBar extends StatelessWidget {
  final Widget child;

  const AppButtonBar({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.paddingOf(context);

    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: safePadding + const EdgeInsets.symmetric(vertical: 32.0, horizontal: 16.0),
        child: SizedBox(
          width: double.infinity,
          child: child,
        ),
      ),
    );
  }
}
