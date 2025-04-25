import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mek_gasol/features/sheet/models/heart_model.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class InvoicesStatisticsView extends StatelessWidget {
  final IList<LifeBar> lifeBars;

  const InvoicesStatisticsView({super.key, required this.lifeBars});

  @override
  Widget build(BuildContext context) {
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);
    final textStyle = DefaultTextStyle.of(context);
    final formats = AppFormats.of(context);

    final columns = [
      const Text('Username'),
      const Text('Life'),
      const Text('Presence'),
      ...Job.values.reversed.map((job) => Text(job.label)),
    ];
    final rows = lifeBars.map((lifeBar) {
      final life = lifeBar.data;
      return [
        Text('${lifeBar.user.displayName}'),
        Text(formats.formatPercent(lifeBar.data.life)),
        Text('${life.presenceCount}'),
        ...Job.values.reversed.map((job) {
          final count = life.jobs[job];
          return Text('${count ?? 0}');
        }),
      ];
    }).toList();

    return TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.free,
      verticalDetails: const ScrollableDetails.vertical(
        physics: ClampingScrollPhysics(),
      ),
      horizontalDetails: const ScrollableDetails.horizontal(
        physics: ClampingScrollPhysics(),
      ),
      columnCount: columns.length,
      rowCount: rows.length + 1,
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      columnBuilder: (index) => TableSpan(
        extent: index == 0 ? const FixedSpanExtent(128.0) : const FixedSpanExtent(64.0),
        padding: const SpanPadding.all(8.0),
        backgroundDecoration: SpanDecoration(
          border: SpanBorder(
            trailing: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.1)),
          ),
        ),
      ),
      rowBuilder: (index) => TableSpan(
        extent: const FixedSpanExtent(48.0),
        backgroundDecoration: SpanDecoration(
          color: index.isEven ? null : colorScheme.surfaceContainer,
        ),
      ),
      cellBuilder: (context, vicinity) {
        Widget child;
        if (vicinity.row == 0) {
          child = columns[vicinity.column];
        } else {
          child = rows[vicinity.row - 1][vicinity.column];
        }
        return TableViewCell(
          child: Align(
            alignment: vicinity.column == 0 ? Alignment.centerLeft : Alignment.center,
            child: DefaultTextStyle(
              style: textStyle.style,
              textAlign: TextAlign.center,
              child: child,
            ),
          ),
        );
      },
    );
  }
}
