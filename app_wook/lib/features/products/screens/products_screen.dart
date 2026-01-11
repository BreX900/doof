import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/products/widgets/products_list.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:mekart/mekart.dart';

final _screenProvider = FutureProvider.autoDispose((ref) {
  final categoriesState = ref.watch(CategoriesProviders.all(Env.organizationId));
  final productsState = ref.watch(ProductsProviders.all(Env.organizationId));

  return categoriesState.requireValue.map((category) {
    return MapEntry(
      category,
      productsState.requireValue.where((e) => e.category.id == category.id).toList(),
    );
  }).toMap();
});

class ProductsScreen extends ConsumerStatefulWidget {
  const ProductsScreen({super.key});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  FutureProvider<Map<CategoryDto, List<ProductModel>>> get _provider => _screenProvider;

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final items = state.value;

    PreferredSizeWidget? tabBar;
    if (items != null) {
      tabBar = TabBar(
        isScrollable: items.length > 3,
        tabs: items.keys.map((e) {
          return Tab(text: e.title);
        }).toList(),
      );
    }

    Widget child = Scaffold(
      appBar: AppBar(title: const Text('Menu'), bottom: tabBar),
      body: state.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_provider),
        data: _buildBody,
      ),
    );

    if (items != null) {
      child = DefaultTabController(length: items.length, child: child);
    }
    return child;
  }

  Widget _buildBody(Map<CategoryDto, List<ProductModel>> categorizedProducts) {
    return TabBarView(
      children: categorizedProducts.values.map((products) {
        return ProductsList(products: products);
      }).toList(),
    );
  }
}
