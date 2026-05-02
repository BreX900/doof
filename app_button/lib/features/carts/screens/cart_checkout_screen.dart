import 'package:app_button/apis/riverpod/riverpod_utils.dart';
import 'package:app_button/shared/widgets/app_button_bar.dart';
import 'package:app_button/shared/widgets/paragraph.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _stateProvider = FutureProvider.autoDispose.family((ref, (String organizaionId,) args) {
  final (organizationId,) = args;

  final userState = ref.watch(UsersProviders.currentAuth);
  final cartState = ref.watch(CartsProviders.personal(organizationId));
  final cartItemsState = ref.watch(
    CartItemsProviders.all((organizationId, cartState.requireValue.id)),
  );

  return (
    user: userState.requireValue,
    cart: cartState.requireValue,
    cartItems: cartItemsState.requireValue,
  );
});

class CartCheckoutScreen extends ConsumerStatefulWidget {
  final String organizationId;

  CartCheckoutScreen({super.key, required this.organizationId});

  late final stateProvider = _stateProvider((organizationId,));

  @override
  ConsumerState<CartCheckoutScreen> createState() => _CartCheckoutScreenState();
}

class _CartCheckoutScreenState extends ConsumerState<CartCheckoutScreen> {
  late final _mutation = MutationController(ref);

  final _placeFb = FormControlTyped(initialValue: '');

  late final _form = FormArray([_placeFb]);

  @override
  void dispose() {
    _form.dispose();
    _mutation.dispose();
    super.dispose();
  }

  void _checkout(CartModel cart, IList<CartItemModel> cartItems) {
    _mutation.call((ref) async {
      await CartsProviders.sendOrder(
        ref,
        widget.organizationId,
        cart: cart,
        items: cartItems,
        place: _placeFb.value,
      );
    }, onError: (error, _) => CoreUtils.showErrorSnackBar(context, error));
  }

  Widget _buildBody({
    required User? user,
    required CartModel cart,
    required IList<CartItemModel> cartItems,
  }) {
    final formats = AppFormats.of(context);

    final isIdle = ref.watch(_mutation.provider.isIdle);
    final total = cartItems.fold(Fixed.zero, (total, item) => total + item.totalCost);

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
            onPressed: isIdle ? () => _checkout(cart, cartItems) : null,
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
        onRefresh: () {},
        data: (data) => _buildBody(user: data.user, cart: data.cart, cartItems: data.cartItems),
      ),
    );
  }
}
