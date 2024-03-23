import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/products/widgets/products_list.dart';
import 'package:pure_extensions/pure_extensions.dart';

final _stateProvider = FutureProvider.autoDispose((ref) async {
  final categories = await ref.watch(CategoriesProviders.all(Env.organizationId).future);
  final products = await ref.watch(ProductsProviders.all(Env.organizationId).future);

  return categories.map((category) {
    return MapEntry(category, products.where((e) => e.category.id == category.id).toList());
  }).toMap();
});

class ProductsScreen extends AsyncConsumerWidget {
  ProductsScreen({super.key});

  late final stateProvider = _stateProvider;

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    final items = state.valueOrNull;

    PreferredSizeWidget? tabBar;
    if (items != null) {
      tabBar = TabBar(
        isScrollable: items.length > 3,
        tabs: items.keys.map((e) {
          return Tab(
            text: e.title,
          );
        }).toList(),
      );
    }

    Widget child = Scaffold(
      appBar: AppBar(
        title: const Text('Menu'),
        bottom: tabBar,
      ),
      body: AsyncViewBuilder(
        state: state,
        builder: _buildBody,
      ),
    );

    if (items != null) {
      child = DefaultTabController(
        length: items.length,
        child: child,
      );
    }
    return child;
  }

  Widget _buildBody(
      BuildContext context, Map<CategoryDto, List<ProductModel>> categorizedProducts) {
    return TabBarView(
      children: categorizedProducts.values.map((products) {
        return ProductsList(
          products: products,
        );
      }).toList(),
    );
  }
}
