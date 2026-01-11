import 'package:app_button/apis/riverpod/riverpod_utils.dart';
import 'package:app_button/features/products/widgets/product_tile.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:app_button/shared/widgets/sliver_order_status_bar.dart';
import 'package:app_button/shared/widgets/store_drawer.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';

final _stateProvider = FutureProvider.family((ref, String organizationId) {
  final userState = ref.watch(UsersProviders.currentAuth);
  final organizationState = ref.watch(OrganizationsProviders.single(organizationId));
  final productsState = ref.watch(ProductsProviders.all(organizationId));

  IList<OrderModel> pendingOrders;
  try {
    pendingOrders = ref
        .watch(OrdersProviders.all((organizationId, whereNotStatusIn: [OrderStatus.delivered])))
        .requireValue;
  } on MissingCredentialsFailure {
    pendingOrders = const IListConst([]);
  }

  return (
    user: userState.requireValue,
    organization: organizationState.requireValue,
    categorizedProducts: productsState.requireValue
        .groupIListsBy((e) => e.category)
        .withConfig(const ConfigMap(sort: true))
        .map((key, value) => MapEntry(key, value.addAll(value))),
    pendingOrders: pendingOrders,
  );
});

class ProductsScreen extends ConsumerStatefulWidget {
  final String organizationId;

  const ProductsScreen({super.key, required this.organizationId});

  @override
  ConsumerState<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends ConsumerState<ProductsScreen> {
  FutureProvider<
    ({
      IMap<CategoryDto, IList<ProductModel>> categorizedProducts,
      OrganizationDto organization,
      IList<OrderModel> pendingOrders,
      User? user,
    })
  >
  get _provider => _stateProvider(widget.organizationId);

  int _tabIndex = 0;

  void _updateTab(int index) => setState(() => _tabIndex = index);

  Widget _buildBody({required IMap<CategoryDto, IList<ProductModel>> categorizedProducts}) {
    final formats = AppFormats.of(context);

    return IndexedStack(
      index: _tabIndex,
      children: categorizedProducts.values.map((e) {
        return CustomScrollView(
          slivers: [
            Builder(
              builder: (context) {
                return SliverOverlapInjector(
                  handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                );
              },
            ),
            SliverPadding(
              padding: const EdgeInsets.all(16.0),
              sliver: SliverList.separated(
                itemCount: e.length,
                separatorBuilder: (context, index) => const SizedBox(height: 16.0),
                itemBuilder: (context, index) {
                  final product = e[index];

                  final ProductModel(:imageUrl) = product;

                  return ProductTile(
                    onTap: () => ProductRoute(widget.organizationId, product.id).go(context),
                    leading: imageUrl != null ? CachedImage(imageUrl) : null,
                    label: Text(product.category.title),
                    title: Text(product.title),
                    subtitle: Text(formats.formatPrice(product.price)),
                    footers: [
                      if (product.ingredients.isNotEmpty)
                        ProductParagraphTile(
                          title: const Text('Ingredients'),
                          content: Text(product.ingredients.map((e) => e.title).join(', ')),
                        ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final data = state.value;
    final organization = data?.organization;
    final categories = data?.categorizedProducts.keys.toList() ?? const [];
    final pendingOrders = data?.pendingOrders ?? const IListConst([]);

    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    final tabBar = TabBar(
      indicatorColor: colors.primary,
      labelColor: colors.onBackground,
      onTap: _updateTab,
      tabs: categories.map((category) {
        return Tab(text: category.title);
      }).toList(),
    );
    final bottomHeight = tabBar.preferredSize.height;

    final flexibleSpace = FlexibleOrderStatusBar(
      bottomHeight: bottomHeight,
      stepIndexes: pendingOrders
          .map((order) => order.status.toStatusBarIndex(shippable: order.shippable))
          .nonNulls
          .toList(),
    );

    final child = NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverAppBar(
              pinned: true,
              collapsedHeight: kToolbarHeight,
              expandedHeight: kToolbarHeight + bottomHeight + flexibleSpace.height,
              title: DotsText.or(organization?.name),
              flexibleSpace: flexibleSpace.height > 0.0 ? flexibleSpace : null,
              bottom: PreferredSize(
                preferredSize: tabBar.preferredSize,
                child: SizedBox.fromSize(
                  size: tabBar.preferredSize,
                  child: Material(child: categories.isEmpty ? null : tabBar),
                ),
              ),
            ),
          ),
        ];
      },
      body: state.buildView(
        onRefresh: () {},
        data: (data) => _buildBody(categorizedProducts: data.categorizedProducts),
      ),
    );

    return Scaffold(
      drawer: StoreDrawer(organizationId: widget.organizationId),
      body: DefaultTabController(length: categories.length, child: child),
    );
  }
}
