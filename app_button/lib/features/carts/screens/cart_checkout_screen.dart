import 'package:app_button/shared/widgets/app_button_bar.dart';
import 'package:app_button/shared/widgets/paragraph.dart';
import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _stateProvider = FutureProvider.autoDispose.family((ref, (String organizaionId,) args) async {
  final (organizationId,) = args;

  final user = await ref.watch(UsersProviders.currentAuth.future);
  final cart = await ref.watch(CartsProviders.personal(organizationId).future);
  final cartItems = await ref.watch(CartItemsProviders.all((organizationId, cart.id)).future);

  return (user: user, cart: cart, cartItems: cartItems);
});

class CartCheckoutScreen extends ConsumerStatefulWidget {
  final String organizationId;

  CartCheckoutScreen({super.key, required this.organizationId});

  late final stateProvider = _stateProvider((organizationId,));

  @override
  ConsumerState<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends ConsumerState<CartCheckoutScreen> {
  final _placeFb = FormControlTyped(initialValue: '');

  late final _form = FormArray([_placeFb]);

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  late final _checkout = ref.mutation((
    ref,
    ({CartModel cart, IList<CartItemModel> cartItems}) arg,
  ) async {
    await CartsProviders.sendOrder(
      ref,
      widget.organizationId,
      cart: arg.cart,
      items: arg.cartItems,
      place: _placeFb.value,
    );
  });

  Widget _buildBody({
    required User? user,
    required CartModel cart,
    required IList<CartItemModel> cartItems,
  }) {
    final formats = AppFormats.of(context);

    final isIdle = !ref.watchIsMutating([_checkout]);
    final total = cartItems.fold(Decimal.zero, (total, item) => total + item.totalCost);

    return Column(
      children: [
        const SizedBox(height: 16.0),
        Paragraph(
          title: const Text('Ombrellone'),
          child: ReactiveTextField(
            formControl: _placeFb,
            decoration: InputDecorations.borderless.copyWith(
              prefixIcon: const Icon(Icons.tag_outlined),
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        Paragraph(
          title: const Text('Totale'),
          child: Column(
            children: [
              ParagraphTile(
                title: const Text('Importo'),
                trailing: Text(formats.formatPrice(total)),
              ),
              const Divider(),
              ParagraphTile(
                title: const Text('Totale'),
                trailing: Text(formats.formatPrice(total)),
              ),
            ],
          ),
        ),
        const Spacer(),
        AppButtonBar(
          child: ElevatedButton(
            onPressed: isIdle ? () => _checkout((cart: cart, cartItems: cartItems)) : null,
            child: const Text('PLACE ORDER'),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: state.buildView(
        data: (data) => _buildBody(user: data.user, cart: data.cart, cartItems: data.cartItems),
      ),
    );
  }
}
