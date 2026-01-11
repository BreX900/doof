import 'dart:async';

import 'package:app_button/apis/riverpod/riverpod_utils.dart';
import 'package:app_button/features/products/widgets/product_tile.dart';
import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:app_button/shared/widgets/app_button_bar.dart';
import 'package:app_button/shared/widgets/app_info_view.dart';
import 'package:app_button/shared/widgets/store_drawer.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mek/mek.dart';

final _stateProvider = FutureProvider.family((ref, String organizationId) {
  final signStatusState = ref.watch(UsersProviders.currentStatus);
  final organizationState = ref.watch(OrganizationsProviders.single(organizationId));
  final cartState = ref.watch(CartsProviders.personal(organizationId));
  final itemsState = ref.watch(CartItemsProviders.all((organizationId, cartState.requireValue.id)));

  return (
    signStatus: signStatusState.requireValue,
    organization: organizationState.requireValue,
    cart: cartState.requireValue,
    items: itemsState.requireValue,
  );
});

class CartScreen extends SourceConsumerStatefulWidget {
  final String organizationId;

  const CartScreen({super.key, required this.organizationId});

  @override
  SourceConsumerState<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends SourceConsumerState<CartScreen> {
  FutureProvider<
    ({
      CartModel cart,
      IList<CartItemModel> items,
      OrganizationDto organization,
      SignStatus signStatus,
    })
  >
  get _provider => _stateProvider(widget.organizationId);

  late final _removeItem = ref.mutation(
    (ref, (String cartId, String itemId) args) => CartItemsProviders.remove(ref, args.$1, args.$2),
    onError: (_, error) => CoreUtils.showErrorSnackBar(context, error),
  );

  Future<void> _checkout({required SignStatus signStatus}) async {
    switch (signStatus) {
      case SignStatus.none:
        final isLogged = await SignInPhoneNumberRoute(
          organizationId: widget.organizationId,
        ).push<bool>(context);
        if (!mounted) return;
        if (!(isLogged ?? false)) return;
        CartCheckoutRoute(widget.organizationId).go(context);
      case SignStatus.full:
        CartCheckoutRoute(widget.organizationId).go(context);
      case SignStatus.partial:
      case SignStatus.unverified:
        throw UnsupportedError('checkout action on $signStatus');
    }
  }

  Widget _buildBody({
    required SignStatus signStatus,
    required CartModel cart,
    required IList<CartItemModel> items,
  }) {
    final isIdle = !ref.watchIsMutating([_removeItem]);

    final formats = AppFormats.of(context);

    if (items.isEmpty) {
      return AppInfoView(
        header: SvgPicture.asset(R.svgsCartEmpty),
        title: const Text('Lista vuota'),
        subtitle: const Text('aggiungi un prodotto dal menu'),
        action: ElevatedButton(
          onPressed: () => ProductsRoute(widget.organizationId).go(context),
          child: const Text('ORDINA ORA'),
        ),
      );
    }

    final itemsView = SliverList.separated(
      itemCount: items.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16.0),
      itemBuilder: (context, index) {
        final item = items[index];
        final product = item.product;

        final ProductModel(:imageUrl) = item.product;

        return ProductTile(
          onTap: () => CartItemRoute(widget.organizationId, item.id).go(context),
          leading: imageUrl != null ? CachedImage(imageUrl) : null,
          title: Text('${item.quantity}x ${product.title}'),
          label: Text(product.category.title),
          subtitle: Text(formats.formatPrice(item.totalCost)),
          trailing: IconButton(
            onPressed: isIdle ? () => _removeItem((cart.id, item.id)) : null,
            icon: const Icon(Icons.delete_outline),
          ),
          footers: [
            if (item.ingredientsRemoved.isNotEmpty)
              ProductParagraphTile(
                title: const Text('Removed Ingredients'),
                content: Text(item.ingredientsRemoved.map((e) => e.title).join(', ')),
              ),
            if (item.ingredientsAdded.isNotEmpty)
              ProductParagraphTile(
                title: const Text('Extra Ingredients'),
                content: Text(item.ingredientsAdded.map((e) => e.title).join(', ')),
              ),
          ],
        );
      },
    );

    final checkoutButton = ElevatedButton(
      onPressed: () => unawaited(_checkout(signStatus: signStatus)),
      child: const Text('CHECKOUT'),
    );

    return CustomScrollView(
      slivers: [
        SliverPadding(padding: const EdgeInsets.all(16.0), sliver: itemsView),
        SliverFillRemaining(hasScrollBody: false, child: AppButtonBar(child: checkoutButton)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final data = state.value;

    return Scaffold(
      drawer: StoreDrawer(organizationId: widget.organizationId),
      appBar: AppBar(title: DotsText.or(data?.organization.name ?? '...')),
      body: state.buildView(
        onRefresh: () {},
        data: (data) => _buildBody(signStatus: data.signStatus, cart: data.cart, items: data.items),
      ),
    );
  }
}
