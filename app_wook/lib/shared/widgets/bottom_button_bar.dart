import 'package:flutter/material.dart';

class BottomButtonBar extends StatelessWidget {
  final List<Widget> children;

  const BottomButtonBar({
    super.key,
    required this.children,
  });

  static final _buttonStyle = ButtonStyle(
    shape: MaterialStateProperty.all(const BeveledRectangleBorder()),
    minimumSize: MaterialStateProperty.all(const Size(0.0, kBottomNavigationBarHeight)),
  );

  @override
  Widget build(BuildContext context) {
    return ElevatedButtonTheme(
      data: ElevatedButtonThemeData(
        style: _buttonStyle.merge(ElevatedButtonTheme.of(context).style),
      ),
      child: TextButtonTheme(
        data: TextButtonThemeData(
          style: _buttonStyle.merge(TextButtonTheme.of(context).style),
        ),
        child: Row(
          children: children,
        ),
      ),
    );
  }
}
