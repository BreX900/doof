import 'package:app_button/apis/material/rect_clipper.dart';
import 'package:app_button/shared/widgets/step_bar.dart';
import 'package:flutter/material.dart';

class FlexibleOrderStatusBar extends StatelessWidget {
  static const double _titleHeight = 40.0;
  static const double _stepBarHeight = 76.0;

  final double bottomHeight;
  final List<int> stepIndexes;

  const FlexibleOrderStatusBar({
    super.key,
    this.bottomHeight = 0,
    required this.stepIndexes,
  });

  double get height {
    if (stepIndexes.isEmpty) return 0.0;
    return _titleHeight + stepIndexes.length * _stepBarHeight;
  }

  @override
  Widget build(BuildContext context) {
    if (stepIndexes.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final child = Material(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minHeight: _titleHeight),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 22.0, 0.0, 4.0),
              child: Text('Ordin${stepIndexes.length > 1 ? 'i' : 'e'} in corso',
                  style: textTheme.titleSmall),
            ),
          ),
          ...stepIndexes.map((stepIndex) {
            const margin = EdgeInsets.fromLTRB(16.0, 4.0, 16.0, 8.0);

            return Card(
              elevation: 3.0,
              margin: margin,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: _stepBarHeight - margin.vertical),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: StepBar(
                    currentStep: stepIndex,
                    items: const [
                      StepBarItem(
                        title: Text('In revisione'),
                      ),
                      StepBarItem(
                        title: Text('In preparazione'),
                      ),
                      StepBarItem(
                        title: Text('In arrivo'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
    final settings = context.dependOnInheritedWidgetOfExactType<FlexibleSpaceBarSettings>()!;

    return LayoutBuilder(builder: (context, constraints) {
      final appBarExtent = settings.maxExtent - settings.minExtent;

      return ClipRect(
        child: Stack(
          children: [
            Positioned(
              top: settings.currentExtent - appBarExtent - bottomHeight,
              height: settings.maxExtent,
              width: constraints.maxWidth,
              child: ClipRect(
                clipper: RectClipper(top: settings.maxExtent - settings.currentExtent),
                child: child,
              ),
            ),
          ],
        ),
      );
    });
  }
}
