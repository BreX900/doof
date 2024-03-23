import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

@immutable
class StepBarStyle extends ThemeExtension<StepBarStyle> {
  final Color inactiveColor;
  final Color activeColor;
  final double connectorSize;
  final double connectorsGap;
  final IconThemeData middleStyle;
  final double verticalGap;
  final TextStyle titleStyle;

  const StepBarStyle({
    required this.connectorSize,
    required this.connectorsGap,
    required this.inactiveColor,
    required this.activeColor,
    required this.middleStyle,
    required this.verticalGap,
    required this.titleStyle,
  });

  static StepBarStyle? maybeOf(BuildContext context) {
    return Theme.of(context).extension<StepBarStyle>();
  }

  factory StepBarStyle.from(ThemeData theme) {
    final colors = theme.colorScheme;

    return StepBarStyle(
      connectorSize: 4.0,
      connectorsGap: -4.0,
      inactiveColor: colors.outline,
      activeColor: colors.primary,
      middleStyle: const IconThemeData(size: 14.0),
      verticalGap: 2.0,
      titleStyle: theme.textTheme.titleSmall ?? const TextStyle(),
    );
  }

  @override
  StepBarStyle copyWith({
    double? connectorSize,
    double? connectorsGap,
    Color? inactiveColor,
    Color? activeColor,
    IconThemeData? middleStyle,
    double? verticalGap,
    TextStyle? titleStyle,
  }) {
    return StepBarStyle(
      connectorSize: connectorSize ?? this.connectorSize,
      connectorsGap: connectorsGap ?? this.connectorsGap,
      inactiveColor: inactiveColor ?? this.inactiveColor,
      activeColor: activeColor ?? this.activeColor,
      middleStyle: middleStyle ?? this.middleStyle,
      verticalGap: verticalGap ?? this.verticalGap,
      titleStyle: titleStyle ?? this.titleStyle,
    );
  }

  @override
  ThemeExtension<StepBarStyle> lerp(covariant StepBarStyle? other, double t) => this;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StepBarStyle &&
          runtimeType == other.runtimeType &&
          inactiveColor == other.inactiveColor &&
          activeColor == other.activeColor &&
          connectorSize == other.connectorSize &&
          connectorsGap == other.connectorsGap &&
          middleStyle == other.middleStyle &&
          verticalGap == other.verticalGap &&
          titleStyle == other.titleStyle;

  @override
  int get hashCode =>
      inactiveColor.hashCode ^
      activeColor.hashCode ^
      connectorSize.hashCode ^
      connectorsGap.hashCode ^
      middleStyle.hashCode ^
      verticalGap.hashCode ^
      titleStyle.hashCode;
}

class StepBar extends StatelessWidget {
  final int currentStep;
  final Axis direction;
  final bool reverse;
  final StepBarStyle? style;
  final List<Widget> items;

  const StepBar({
    super.key,
    required this.currentStep,
    this.direction = Axis.horizontal,
    this.reverse = false,
    this.style,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final style = this.style;
    final items = reverse ? this.items.reversed : this.items;

    final child = Flex(
      direction: direction,
      children: items.mapIndexed((index, item) {
        return Expanded(
          child: StepBarItemInfo(
            direction: direction,
            currentStep: currentStep,
            step: index,
            lastStep: items.length - 1,
            child: item,
          ),
        );
      }).toList(),
    );
    if (style == null) return child;
    final theme = Theme.of(context);
    return Theme(
      data: theme.copyWith(
        extensions: theme.extensions.values.followedBy([style]),
      ),
      child: child,
    );
  }
}

class StepBarItemInfo extends InheritedWidget {
  final Axis direction;
  final int currentStep;
  final int step;
  final int lastStep;

  const StepBarItemInfo({
    super.key,
    required this.direction,
    required this.currentStep,
    required this.step,
    required this.lastStep,
    required super.child,
  });

  static StepBarItemInfo of(BuildContext context) {
    final result = context.dependOnInheritedWidgetOfExactType<StepBarItemInfo>();
    assert(result != null, 'No StepScope found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(StepBarItemInfo oldWidget) =>
      direction != oldWidget.direction ||
      currentStep != oldWidget.currentStep ||
      step != oldWidget.step ||
      lastStep != oldWidget.lastStep;
}

class StepBarItem extends StatelessWidget {
  final Color? color;
  final Color? activeColor;
  final double? connectorSize;
  final double? connectorsGap;
  final IconThemeData? middleStyle;
  final double? verticalGap;
  final TextStyle? titleStyle;
  final Widget? leading;
  final Widget? middle;
  final Widget? trailing;
  final Widget? title;

  const StepBarItem({
    super.key,
    this.color,
    this.activeColor,
    this.connectorSize,
    this.connectorsGap,
    this.middleStyle,
    this.verticalGap,
    this.titleStyle,
    this.leading,
    this.middle,
    this.trailing,
    this.title,
  });

  StepBarStyle _themeOf(BuildContext context) {
    return (StepBarStyle.maybeOf(context) ?? StepBarStyle.from(Theme.of(context))).copyWith(
      inactiveColor: color,
      activeColor: activeColor,
      connectorsGap: connectorsGap,
      connectorSize: connectorSize,
      middleStyle: middleStyle,
      verticalGap: verticalGap,
      titleStyle: titleStyle,
    );
  }

  Widget _buildConnection(StepBarItemInfo info, StepBarStyle theme, double index) {
    final size = theme.connectorSize;

    final child = SizedBox(
      height: info.direction == Axis.horizontal ? size : null,
      width: info.direction == Axis.vertical ? size : null,
    );
    if (index < 0 || index > info.lastStep) return child;

    final color = index <= info.currentStep ? theme.activeColor : theme.inactiveColor;

    return DecoratedBox(
      decoration: BoxDecoration(color: color),
      child: child,
    );
  }

  Widget _buildMiddle(IconThemeData iconTheme) {
    return SizedBox.square(
      dimension: iconTheme.size ?? 14.0,
      child: DecoratedBox(
        decoration: BoxDecoration(color: iconTheme.color, shape: BoxShape.circle),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final info = StepBarItemInfo.of(context);
    final theme = _themeOf(context);
    final title = this.title;

    final iconTheme = theme.middleStyle.copyWith(
      size: 14.0,
      color: info.step <= info.currentStep ? theme.activeColor : theme.inactiveColor,
    );

    return Flex(
      direction: flipAxis(info.direction),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Stack(
          children: [
            Positioned.fill(
              child: Flex(
                direction: info.direction,
                children: [
                  Expanded(
                    child: leading ?? _buildConnection(info, theme, info.step - 0.5),
                  ),
                  if (theme.connectorsGap > 0) SizedBox(width: theme.connectorsGap * 2),
                  Expanded(
                    child: trailing ?? _buildConnection(info, theme, info.step + 0.5),
                  ),
                ],
              ),
            ),
            Positioned(
              child: Center(
                child: IconTheme(
                  data: iconTheme,
                  child: middle ?? _buildMiddle(iconTheme),
                ),
              ),
            ),
          ],
        ),
        if (title != null) ...[
          if (theme.verticalGap > 0) SizedBox(height: theme.verticalGap),
          Center(
            child: DefaultTextStyle(
              style: theme.titleStyle,
              textAlign: TextAlign.center,
              child: title,
            ),
          ),
        ],
      ],
    );
  }
}
