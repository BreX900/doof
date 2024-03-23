import 'package:flutter/material.dart';

class BottomSheetPage<T> extends Page<T> {
  final WidgetBuilder builder;
  final Color? backgroundColor;
  final double? elevation;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final BoxConstraints? constraints;
  final Color? barrierColor;
  final bool isScrollControlled;
  final bool isDismissible;
  final bool enableDrag;
  final bool? showDragHandle;
  final bool useSafeArea;
  final RouteSettings? routeSettings;
  final AnimationController? transitionAnimationController;
  final Offset? anchorPoint;

  const BottomSheetPage({
    required this.builder,
    this.backgroundColor,
    this.elevation,
    this.shape,
    this.clipBehavior,
    this.constraints,
    this.barrierColor,
    this.isScrollControlled = false,
    this.isDismissible = true,
    this.enableDrag = true,
    this.showDragHandle,
    this.useSafeArea = false,
    this.routeSettings,
    this.transitionAnimationController,
    this.anchorPoint,
  });

  @override
  Route<T> createRoute(BuildContext context) {
    final localizations = MaterialLocalizations.of(context);

    return _ModalBottomSheetRoute(
      barrierLabel: localizations.scrimLabel,
      barrierOnTapHint: localizations.scrimOnTapHint(localizations.bottomSheetLabel),
      backgroundColor: backgroundColor,
      elevation: elevation,
      shape: shape,
      clipBehavior: clipBehavior,
      constraints: constraints,
      modalBarrierColor: barrierColor ?? Theme.of(context).bottomSheetTheme.modalBarrierColor,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      showDragHandle: showDragHandle,
      isScrollControlled: isScrollControlled,
      settings: this,
      transitionAnimationController: transitionAnimationController,
      anchorPoint: anchorPoint,
      useSafeArea: useSafeArea,
      builder: builder,
    );
  }
}

class _ModalBottomSheetRoute<T> extends ModalBottomSheetRoute<T> {
  /// A modal bottom sheet route.
  _ModalBottomSheetRoute({
    required super.builder,
    super.capturedThemes,
    super.barrierLabel,
    super.barrierOnTapHint,
    super.backgroundColor,
    super.elevation,
    super.shape,
    super.clipBehavior,
    super.constraints,
    super.modalBarrierColor,
    super.isDismissible = true,
    super.enableDrag = true,
    super.showDragHandle,
    required super.isScrollControlled,
    super.settings,
    super.transitionAnimationController,
    super.anchorPoint,
    super.useSafeArea = false,
  });

  @override
  Widget buildPage(
      BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation) {
    return SafeArea(
      child: super.buildPage(context, animation, secondaryAnimation),
    );
  }
}
