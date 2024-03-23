import 'dart:async';

import 'package:app_button/features/products/widgets/product_tile.dart';
import 'package:app_button/shared/widgets/app_button_bar.dart';
import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';

final _stateProvider = FutureProvider.autoDispose
    .family((ref, (String organizationId, Either<String, String> id) args) async {
  final (organizationId, id) = args;

  final cart = await ref.watch(CartsProviders.personal(organizationId).future);

  final vls = await id.when((productId) async {
    return (
      product: await ref.watch(ProductsProviders.single((organizationId, productId)).future),
      cartItem: null,
    );
  }, (itemId) async {
    final cartItem =
        await ref.watch(CartItemsProviders.first((organizationId, cart.id, itemId)).future);
    return (
      product: cartItem.product,
      cartItem: cartItem,
    );
  });

  return (cart: cart, product: vls.product, cartItem: vls.cartItem);
});

class ProductScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  final String organizationId;
  final Either<String, String> id;

  ProductScreen({
    super.key,
    required this.organizationId,
    required String productId,
  }) : id = Either.left(productId);

  ProductScreen.fromCart({
    super.key,
    required this.organizationId,
    required String itemId,
  }) : id = Either.right(itemId);

  late final stateProvider = _stateProvider((organizationId, id));

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> with AsyncConsumerState {
  final _quantityFb = FieldBloc<int>(
    initialValue: 1,
    validator: const NumberValidation(greaterOrEqualThan: 1),
  );
  final _removableIngredientsFb = FieldBloc<IList<IngredientDto>>(
    initialValue: const IListConst([]),
  );
  final _addableIngredientsFb = FieldBloc<IList<IngredientDto>>(
    initialValue: const IListConst([]),
  );

  late final _formBloc = ListFieldBloc(fieldBlocs: [
    _quantityFb,
    _removableIngredientsFb,
    _addableIngredientsFb,
  ]);

  late final _upsertProduct = ref.mutation((ref, ({String cartId, String productId}) args) async {
    return await CartItemsProviders.upsert(
      ref,
      widget.organizationId,
      args.cartId,
      productId: args.productId,
      quantity: _quantityFb.state.value,
      ingredientsRemoved: _removableIngredientsFb.state.value,
      ingredientsAdded: _addableIngredientsFb.state.value,
    );
  }, onSuccess: (_, __) {
    context.pop();
  });

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  @override
  void dispose() {
    unawaited(_formBloc.close());
    super.dispose();
  }

  Future<void> _init() async {
    final (cart: _, product: _, :cartItem) = await ref.read(widget.stateProvider.futureOfData);

    if (cartItem == null) return;

    _quantityFb.updateValue(cartItem.quantity);
    _removableIngredientsFb.updateValue(cartItem.ingredientsRemoved);
    _addableIngredientsFb.updateValue(cartItem.ingredientsAdded);
  }

  Widget _buildBody({
    required ProductModel product,
    required CartModel cart,
    required CartItemModel? cartItem,
  }) {
    final formats = AppFormats.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    final isIdle = ref.watchIdle(mutations: [_upsertProduct]);
    final canSubmit = ref.watchCanSubmit(_formBloc);

    Widget buildQuantityField() {
      return FieldDropdown(
        fieldBloc: _quantityFb,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: const InputDecoration(labelText: 'Quantity'),
        items: [
          for (var i = 1; i <= 8; i++)
            DropdownMenuItem(
              value: i,
              child: Text('$i'),
            ),
        ],
      );
    }

    Widget buildIngredientsField({
      required FieldBloc<IList<IngredientDto>> fieldBloc,
      required IList<IngredientDto> ingredients,
      required String labelText,
    }) {
      if (ingredients.isEmpty) return const SizedBox.shrink();

      return FieldGroupBuilder(
        fieldBloc: fieldBloc,
        valuesCount: ingredients.length,
        decoration: InputDecoration(labelText: labelText),
        valueBuilder: (state, index) {
          final value = ingredients[index];

          return CheckboxListTile(
            splashRadius: 8.0,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            dense: true,
            contentPadding: EdgeInsets.zero,
            value: state.value.contains(value),
            visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
            enabled: state.isEnabled,
            onChanged: (isSelected) => state.fieldBloc.changeTogglingValue(isSelected, value),
            title: Text('${formats.formatPrice(value.price)} - ${value.title}'),
            subtitle: Text(value.description),
          );
        },
      );
    }

    final productImageUrl = product.imageUrl;

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              ProductTile(
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                leading: productImageUrl != null ? CachedImage(productImageUrl) : null,
                title: Text(product.title),
                label: Text(product.category.title),
                subtitle: Text(formats.formatPrice(product.price)),
                footers: [
                  if (product.ingredients.isNotEmpty)
                    ProductParagraphTile(
                      title: const Text('Ingredients'),
                      content: Text(product.ingredients.map((e) => e.title).join(', ')),
                    ),
                ],
              ),
              buildQuantityField(),
              const SizedBox(height: 24.0),
              buildIngredientsField(
                fieldBloc: _removableIngredientsFb,
                ingredients: product.removableIngredients,
                labelText: 'Remove Ingredients',
              ),
              const SizedBox(height: 24.0),
              buildIngredientsField(
                fieldBloc: _addableIngredientsFb,
                ingredients: product.addableIngredients,
                labelText: 'Extra Ingredients',
              ),
            ],
          ),
        ),
        SliverFillRemaining(
          hasScrollBody: false,
          child: AppButtonBar(
            child: Row(
              children: [
                Consumer(builder: (context, ref, child) {
                  final quantity =
                      ref.watch(_quantityFb.select((state) => state.value.toDecimal()));
                  final extras = ref.watch(_addableIngredientsFb
                      .select((state) => state.value.map((e) => e.price).toIList()));
                  final total = (product.price + extras.sum) * quantity;

                  return Text(formats.formatPrice(total), style: textTheme.labelLarge);
                }),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isIdle && canSubmit
                        ? () => _upsertProduct((cartId: cart.id, productId: product.id))
                        : null,
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final product = state.valueOrNull?.product;

    return Scaffold(
      appBar: AppBar(
        title: DotsText.or(product?.title),
      ),
      body: state.buildView(
        data: (data) => _buildBody(
          product: data.product,
          cart: data.cart,
          cartItem: data.cartItem,
        ),
      ),
    );
  }
}
