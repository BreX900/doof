import 'package:flutter/widgets.dart';

class FieldPadding extends Padding {
  const FieldPadding(
    Widget child, {
    super.key,
    super.padding = const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
  }) : super(child: child);
}
