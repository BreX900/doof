import 'dart:async';

import 'package:app_button/apis/riverpod/riverpod_utils.dart';
import 'package:app_button/features/products/widgets/product_tile.dart';
import 'package:app_button/shared/widgets/app_button_bar.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _stateProvider = FutureProvider.autoDispose.family((
  ref,
  (String, Either<String, String>) args,
) {
  final (organizationId, id) = args;

  final cartState = ref.watch(CartsProviders.personal(organizationId));

  final vls = id.when(
    (productId) {
      return (
        product: ref.watch(ProductsProviders.single((organizationId, productId))).requireValue,
        cartItem: null,
      );
    },
    (itemId) {
      final cartItemState = ref.watch(
        CartItemsProviders.first((organizationId, cartState.requireValue.id, itemId)),
      );
      return (product: cartItemState.requireValue.product, cartItem: cartItemState.requireValue);
    },
  );

  return (cart: cartState.requireValue, product: vls.product, cartItem: vls.cartItem);
});

class ProductScreen extends SourceConsumerStatefulWidget {
  final String organizationId;
  final Either<String, String> id;

  ProductScreen({super.key, required this.organizationId, required String productId})
    : id = Either.left(productId);

  ProductScreen.fromCart({super.key, required this.organizationId, required String itemId})
    : id = Either.right(itemId);

  @override
  SourceConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends SourceConsumerState<ProductScreen> {
  FutureProvider<({CartModel cart, CartItemModel? cartItem, ProductModel product})> get _provider =>
      _stateProvider((widget.organizationId, widget.id));

  final _quantityFb = FormControlTyped<int>(
    initialValue: 1,
    validators: [ValidatorsTyped.comparable(greaterOrEqualThan: 1)],
  );
  final _removableIngredientsFb = FormControlTyped<IList<IngredientDto>>(
    initialValue: const IListConst([]),
  );
  final _addableIngredientsFb = FormControlTyped<IList<IngredientDto>>(
    initialValue: const IListConst([]),
  );

  late final _form = FormArray([_quantityFb, _removableIngredientsFb, _addableIngredientsFb]);

  late final _upsertProduct = ref.mutation(
    (ref, ({String cartId, String productId}) args) async {
      return await CartItemsProviders.upsert(
        ref,
        widget.organizationId,
        args.cartId,
        productId: args.productId,
        quantity: _quantityFb.value,
        ingredientsRemoved: _removableIngredientsFb.value,
        ingredientsAdded: _addableIngredientsFb.value,
      );
    },
    onError: (_, error) => CoreUtils.showErrorSnackBar(context, error),
    onSuccess: (_, __) {
      context.pop();
    },
  );

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }

  Future<void> _init() async {
    final (cart: _, product: _, :cartItem) = await ref.futureOfData(_provider);

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

    final isIdle = !ref.watchIsMutating([_upsertProduct]);
    final upsertProduct = _form.handleSubmitWith(_upsertProduct);

    Widget buildQuantityField() {
      return ReactiveDropdownField(
        formControl: _quantityFb,
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: const InputDecoration(labelText: 'Quantity'),
        items: [for (var i = 1; i <= 8; i++) DropdownMenuItem(value: i, child: Text('$i'))],
      );
    }

    Widget buildIngredientsField({
      required FormControl<IList<IngredientDto>> fieldBloc,
      required IList<IngredientDto> ingredients,
      required String labelText,
    }) {
      if (ingredients.isEmpty) return const SizedBox.shrink();

      return ReactiveFormFieldDecorated(
        formControl: fieldBloc,
        decoration: InputDecoration(labelText: labelText),
        builder: (field) {
          final selection = field.value ?? const IList<IngredientDto>.empty();
          return Column(
            children: ingredients.map((value) {
              return CheckboxListTile(
                splashRadius: 8.0,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                dense: true,
                contentPadding: EdgeInsets.zero,
                value: selection.contains(value),
                visualDensity: const VisualDensity(vertical: VisualDensity.minimumDensity),
                enabled: field.control.enabled,
                onChanged: (isSelected) =>
                    field.didChange(isSelected! ? selection.add(value) : selection.remove(value)),
                title: Text('${formats.formatPrice(value.price)} - ${value.title}'),
                subtitle: Text(value.description),
              );
            }).toList(),
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
                SourceBuilder(
                  builder: (context, ref, child) {
                    final quantity = Fixed.fromInt(ref.watchSource(_quantityFb.source.value) ?? 0);
                    final extras =
                        ref.watchSource(_addableIngredientsFb.source.value)?.map((e) => e.price) ??
                        [];
                    final total = (product.price + extras.sum) * quantity;

                    return Text(formats.formatPrice(total), style: textTheme.labelLarge);
                  },
                ),
                const SizedBox(width: 12.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isIdle
                        ? () => upsertProduct((cartId: cart.id, productId: product.id))
                        : null,
                    child: const Text('Add to Cart'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final product = state.value?.product;

    return Scaffold(
      appBar: AppBar(title: DotsText.or(product?.title)),
      body: state.buildView(
        onRefresh: () {},
        data: (data) => _buildBody(product: data.product, cart: data.cart, cartItem: data.cartItem),
      ),
    );
  }
}
