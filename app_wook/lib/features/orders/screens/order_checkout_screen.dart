import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/orders/utils/orders_utils.dart';
import 'package:mek_gasol/features/products/utils/purchasable_products_utils.dart';
import 'package:mek_gasol/shared/widgets/bottom_button_bar.dart';
import 'package:mek_gasol/shared/widgets/hide_banner_button.dart';

final _stateProvider = FutureProvider.autoDispose((ref) async {
  final cart = await ref.watch(CartsProviders.public((Env.organizationId, Env.cartId)).future);
  final items = await ref.watch(CartItemsProviders.all((Env.organizationId, Env.cartId)).future);
  final message = OrdersUtils.generateMessage(items);

  return (cart: cart, items: items, message: message);
});

class OrderCheckoutScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  OrderCheckoutScreen({
    super.key,
  });

  late final stateProvider = _stateProvider;

  @override
  ConsumerState<OrderCheckoutScreen> createState() => _OrderCheckoutScreenState();

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;
}

class _OrderCheckoutScreenState extends ConsumerState<OrderCheckoutScreen> with AsyncConsumerState {
  VoidCallback? _bannerCartChangedCloser;
  bool _isCartOrdering = false;

  @override
  void initState() {
    super.initState();
    ref.listenManualFuture(widget.stateProvider.future, (_) async {
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

    final controller = ScaffoldMessenger.of(context).showMaterialBanner(const MaterialBanner(
      content: Text('Cart is updated! Please review your order.\n'
          'Close this banner to continue with order!'),
      actions: [HideBannerButton()],
    ));
    setState(() => _bannerCartChangedCloser = controller.close);

    await controller.closed;
    if (!mounted) return;

    setState(() => _bannerCartChangedCloser = null);
  }

  late final _placeOrder = ref.mutation((ref, arg) async {
    final data = await ref.read(_stateProvider.future);
    await CartsProviders.sendOrder(
      ref,
      Env.organizationId,
      cart: data.cart,
      items: data.items,
    );
  }, onStart: (_) {
    _isCartOrdering = true;
  }, onSuccess: (_, __) {
    _isCartOrdering = false;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: colors.primary,
      content: const Text('Order sent!'),
    ));
    Navigator.pop(context);
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final items = state.valueOrNull;

    final isIdle = ref.watchIdle(mutations: [_placeOrder]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conferma invio ordine'),
      ),
      body: state.buildView(
        data: (items) => _buildBody(
          context,
          items: items.items,
          message: items.message,
        ),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Annulla'),
            ),
          ),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: isIdle && items != null && _bannerCartChangedCloser == null
                  ? () => _placeOrder(null)
                  : null,
              child: const Text('Invia'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    BuildContext context, {
    required IList<CartItemModel> items,
    required String message,
  }) {
    final totalCost = items.fold(Decimal.zero, (amount, e) => amount + e.totalCost);

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
              Text(
                'Total: ${formats.formatPrice(totalCost)}',
                style: textTheme.headlineSmall,
              ),
              Text("L'invio dell'ordine non permetterà altre modifiche.",
                  style: textTheme.bodySmall),
            ],
          ),
        ),
        ...items.map((item) {
          return ProductItemListTile(
            item: item,
          );
        }),
      ],
    );

    return SingleChildScrollView(
      child: content,
    );
  }
}
