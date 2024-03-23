import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/shared/widgets/text_icon.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T data);

class ProductItemListTile extends StatelessWidget {
  final VoidCallback? onTap;
  final ProductItem item;
  final Widget? trailing;

  const ProductItemListTile({
    super.key,
    this.onTap,
    required this.item,
    this.trailing,
  });

  String _buildTitle() {
    final buyers = item.buyers;

    final buffer = StringBuffer();
    if (item.levels.isNotEmpty) {
      buffer.writeln(
          item.levels.entries.map((e) => '${e.key.title}  ${e.value * e.key.max}').join(', '));
    }
    if (item.ingredientsAdded.isNotEmpty) {
      buffer.writeln(item.ingredientsAdded.map((e) => e.title).join(' - '));
    }
    buffer.write('Ordinato da: ');
    buffer.write(buyers.map((e) => e.displayName).join(' - '));

    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final formats = AppFormats.of(context);
    final product = item.product;

    return ListTile(
      onTap: onTap,
      leading: TextIcon('${item.quantity}'),
      title: Text('${formats.formatPrice(item.totalCost)} - ${product.title}'),
      subtitle: Text(_buildTitle()),
      trailing: trailing,
    );
  }

  static Iterable<Widget> buildLists<T extends ProductItem>({
    required String? userId,
    required Iterable<T> items,
    required ItemWidgetBuilder<T> builder,
  }) sync* {
    if (userId == null) {
      yield _buildItems(items, builder);
      return;
    }

    final dividedItems = items.groupListsBy((e) {
      return e.buyers.any((e) => e.id == userId);
    });
    final myItems = dividedItems[true] ?? const [];
    final theirItems = dividedItems[false] ?? const [];

    if (myItems.isNotEmpty) {
      if (theirItems.isNotEmpty) yield _buildSectionTitle('My Products');
      yield _buildItems(myItems, builder);
    }
    if (theirItems.isNotEmpty) {
      if (myItems.isNotEmpty) yield const SliverToBoxAdapter(child: Divider());

      yield _buildSectionTitle('Their Products');
      yield _buildItems(theirItems, builder);
    }
  }

  static Widget _buildSectionTitle(String text) {
    return Builder(builder: (context) {
      final theme = Theme.of(context);
      final textTheme = theme.textTheme;

      return SliverPadding(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
        sliver: SliverToBoxAdapter(
          child: Text(text, style: textTheme.titleLarge),
        ),
      );
    });
  }

  static Widget _buildItems<T>(Iterable<T> items, ItemWidgetBuilder<T> builder) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: items.length,
        (context, index) => builder(context, items.elementAt(index)),
      ),
    );
  }
}
