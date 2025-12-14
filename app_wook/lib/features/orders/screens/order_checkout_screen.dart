import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/orders/utils/orders_utils.dart';
import 'package:mek_gasol/features/products/utils/purchasable_products_utils.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:mekart/mekart.dart';

final _screenProvider = FutureProvider.autoDispose((ref) async {
  final cart = await ref.watch(CartsProviders.public((Env.organizationId, Env.cartId)).future);
  final items = await ref.watch(CartItemsProviders.all((Env.organizationId, Env.cartId)).future);
  final message = OrdersUtils.generateMessage(items);

  return (cart: cart, items: items, message: message);
});

class OrderCheckoutScreen extends SourceConsumerStatefulWidget {
  const OrderCheckoutScreen({super.key});

  @override
  SourceConsumerState<OrderCheckoutScreen> createState() => _OrderCheckoutScreenState();
}

class _OrderCheckoutScreenState extends SourceConsumerState<OrderCheckoutScreen> {
  FutureProvider<({CartModel cart, IList<CartItemModel> items, String message})> get _provider =>
      _screenProvider;

  VoidCallback? _bannerCartChangedCloser;
  bool _isCartOrdering = false;

  @override
  void initState() {
    super.initState();
    ref.listenManualFuture(_provider.future, (_) async {
      await _showCartUpdatedBanner();
    });
  }

  @override
  void dispose() {
    _bannerCartChangedCloser?.call();
    _bannerCartChangedCloser = null;
    super.dispose();
  }

  Future<void> _showCartUpdatedBanner() async {
    if (_bannerCartChangedCloser != null || _isCartOrdering) return;

    final controller = ScaffoldMessenger.of(context).showMaterialBanner(
      const MaterialBanner(
        content: Text(
          'Cart is updated! Please review your order.\n'
          'Close this banner to continue with order!',
        ),
        actions: [HideBannerButton()],
      ),
    );
    setState(() => _bannerCartChangedCloser = controller.close);

    await controller.closed;
    if (!mounted) return;

    setState(() => _bannerCartChangedCloser = null);
  }

  late final _placeOrder = ref.mutation(
    (ref, arg) async {
      final data = await ref.read(_screenProvider.future);
      return await CartsProviders.sendOrder(
        ref,
        Env.organizationId,
        cart: data.cart,
        items: data.items,
      );
    },
    onStart: (_) {
      _isCartOrdering = true;
    },
    onError: (_, error) {
      CoreUtils.showErrorSnackBar(context, error);
    },
    onSuccess: (_, orderId) {
      _isCartOrdering = false;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Order sent!')));
      Navigator.pop(context);
      OrderRoute(orderId, isNew: true).go(context);
    },
  );

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final items = state.value;

    final isIdle = !ref.watchIsMutating([_placeOrder]);

    return Scaffold(
      appBar: AppBar(title: const Text('Conferma invio ordine')),
      floatingActionButton: FixedFloatingActionButton.extended(
        onPressed: isIdle && items != null && _bannerCartChangedCloser == null
            ? () => _placeOrder(null)
            : null,
        icon: const Icon(Icons.send),
        label: const Text('Invia'),
      ),
      body: state.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_provider),
        data: (items) => _buildBody(context, items: items.items, message: items.message),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required IList<CartItemModel> items,
    required String message,
  }) {
    final totalCost = items.fold(Fixed.zero, (amount, e) => amount + e.totalCost);

    final formats = AppFormats.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total: ${formats.formatPrice(totalCost)}', style: textTheme.headlineSmall),
              Text(
                "L'invio dell'ordine non permetterà altre modifiche.",
                style: textTheme.bodySmall,
              ),
            ],
          ),
        ),
        ...items.map((item) {
          return ProductItemListTile(item: item);
        }),
        const FloatingActionButtonInjector(),
      ],
    );

    return SingleChildScrollView(child: content);
  }
}
