import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mekart/mekart.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class InvoiceExpensesView extends StatefulWidget {
  final IList<UserDto> users;
  final IList<InvoiceDto> invoices;

  const InvoiceExpensesView({super.key, required this.users, required this.invoices});

  @override
  State<InvoiceExpensesView> createState() => _InvoiceExpensesViewState();
}

class _InvoiceExpensesViewState extends State<InvoiceExpensesView> {
  int? _year = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);
    final textStyle = DefaultTextStyle.of(context);
    final formats = AppFormats.of(context);

    final expenses = Map.fromEntries(widget.invoices.where((e) {
      if (_year == null) return true;
      return e.createdAt.year == _year;
    }).expand((invoice) {
      return invoice.items.mapTo((userId, item) {
        return MapEntry(userId, MapEntry(invoice.createdAt, item.amount));
      });
    }).groupFolding(IList<MapEntry<DateTime, Decimal>>(), (e) => e.key, (total, e) {
      return total.add(e.value);
    }).mapTo((userId, items) {
      final total = items.groupFolding(Decimal.zero, (e) {
        if (_year == null) return e.key.copyDateWith(month: 1, day: 1);
        return e.key.copyDateWith(day: 1);
      }, (total, e) {
        return total + e.value;
      });
      return MapEntry(userId, total);
    }));

    final years = widget.invoices.map((invoice) {
      return invoice.createdAt.copyDateWith(month: 1, day: 1);
    }).toSet();

    final dates = [
      if (_year case final year?)
        for (var i = 0; i < 12; i++) DateTime(year, i + 1)
      else
        ...years,
    ];

    final columns = [
      const Text('User'),
      Text('${_year ?? 'All'}'),
      ...dates.map((date) {
        if (_year == null) return Text('${date.year}');
        return Text(formats.formatMonth(date));
      }),
    ];
    final rows = expenses.mapTo((userId, amounts) {
      final user = widget.users.firstWhere((e) => e.id == userId);
      return [
        Text(user.displayName!),
        Text(formats.formatPrice(amounts.values.sum)),
        ...dates.map((date) {
          final amount = amounts[date];
          return Text(amount != null ? formats.formatPrice(amount) : '');
        }),
      ];
    }).toList();

    final lastRows = <Widget>[
      const Text('Total'),
      Text(formats.formatPrice(expenses.values.expand((e) => e.values).sum)),
      ...dates.map((date) {
        final amount = expenses.values.map((e) => e[date] ?? Decimal.zero).sum;
        return Text(formats.formatPrice(amount));
      }),
    ];

    return Column(
      children: [
        Expanded(
          child: TableView.builder(
            diagonalDragBehavior: DiagonalDragBehavior.free,
            verticalDetails: const ScrollableDetails.vertical(
              physics: ClampingScrollPhysics(),
            ),
            horizontalDetails: const ScrollableDetails.horizontal(
              physics: ClampingScrollPhysics(),
            ),
            columnCount: columns.length,
            rowCount: rows.length + 1 + 1,
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
              } else if (vicinity.row > rows.length) {
                child = lastRows[vicinity.column];
              } else {
                child = rows[vicinity.row - 1][vicinity.column];
              }
              return TableViewCell(
                child: Align(
                  alignment: vicinity.column == 0 ? Alignment.centerLeft : Alignment.center,
                  child: DefaultTextStyle(
                    style: vicinity.row == 0 || vicinity.row > rows.length
                        ? textTheme.titleMedium!
                        : textStyle.style,
                    textAlign: TextAlign.center,
                    child: child,
                  ),
                ),
              );
            },
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Row(
            children: [null, ...years].map((date) {
              return (_year == date?.year ? FilledButton.new : TextButton.new)(
                onPressed: () => setState(() => _year = date?.year),
                child: Text('${date?.year ?? 'All'}'),
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}
