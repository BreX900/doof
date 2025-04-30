import 'dart:async';

import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mek_gasol/shared/widgets/field_padding.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:mekart/mekart.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _screenProvider =
    FutureProvider.autoDispose.family((ref, (String?, String?, String?) items) async {
  ProductModel product;
  CartModel? cart;
  CartItemModel? cartItem;

  if (items.$1 != null) {
    product = await ref.watch(ProductsProviders.first((Env.organizationId, items.$1!)).future);
    cart = null;
    cartItem = null;
  } else {
    cart = await ref.watch(CartsProviders.first((Env.organizationId, items.$2!)).future);
    cartItem = await ref
        .watch(CartItemsProviders.first((Env.organizationId, items.$2!, items.$3!)).future);
    product = cartItem!.product;
  }

  return (
    product: product,
    carts: IList([await ref.watch(CartsProviders.public((Env.organizationId, Env.cartId)).future)]),
    cart: cart,
    cartItem: cartItem,
    user: ref.watch(UsersProviders.current).valueOrNull,
  );
});

class ProductScreen extends ConsumerStatefulWidget {
  final String? productId;
  final String? cartId;
  final String? cartItemId;
  final OrderModel? order;
  final OrderItemModel? orderItem;

  const ProductScreen({
    super.key,
    required String this.productId,
    this.order,
    this.orderItem,
  })  : cartId = null,
        cartItemId = null;

  const ProductScreen.fromCart({
    super.key,
    required String this.cartItemId,
  })  : productId = null,
        order = null,
        orderItem = null,
        cartId = Env.cartId;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> {
  AutoDisposeFutureProvider<
      ({
        CartModel? cart,
        CartItemModel? cartItem,
        IList<CartModel> carts,
        ProductModel product,
        UserDto? user
      })> get _provider => _screenProvider((widget.productId, widget.cartId, widget.cartItemId));

  final _cartFb = FormControlTypedOptional<CartModel>(
    validators: [ValidatorsTyped.required()],
  );
  final _buyersFb = FormControlTyped<ISet<UserDto>>(
    initialValue: const ISet.empty(),
    validators: [ValidatorsTyped.iterable(minLength: 1)],
  );
  final _quantityFb = FormControlTyped<int>(initialValue: 1);
  final _ingredientsAddableFb = FormControlTyped<IList<IngredientDto>>(
    initialValue: const IListConst([]),
  );
  final _levelsFb = FormMap<AbstractControl<double>, double>({});

  late final _form = FormArray<void>([_cartFb, _quantityFb, _ingredientsAddableFb, _levelsFb]);

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
    final (:user, :product, :carts, :cart, :cartItem) = await ref.read(_provider.futureOfData);
    final levels = product.levels;

    final order = widget.order;
    final orderItem = widget.orderItem;
    final orderCart = carts.firstWhereIdOrNull(order?.id);
    final orderItemBuyers = orderCart != null ? orderItem?.buyers : null;

    _cartFb.updateValue(cart ?? orderCart ?? carts.singleOrNull);
    if (user != null) {
      _buyersFb.updateValue((cartItem?.buyers ?? orderItemBuyers)?.toISet() ?? ISet([user]));
    }
    _quantityFb.updateValue(cartItem?.quantity ?? orderItem?.quantity);
    _ingredientsAddableFb.updateValue(cartItem?.ingredientsAdded ?? orderItem?.ingredientsAdded);

    final prevIngredients = cartItem?.levels ?? orderItem?.levels;
    double resolveInitialIngredientValue(LevelDto ingredient) {
      final prevEntry = prevIngredients?.entries.firstWhereOrNull((e) => e.key.id == ingredient.id);
      if (prevEntry != null) return prevEntry.value;
      return ingredient.initialOffset;
    }

    _levelsFb.addAll({
      for (final ingredient in levels)
        ingredient.id: FormControlTyped(
          initialValue: resolveInitialIngredientValue(ingredient),
        ),
    });

    if (user != null) _form.add(_buyersFb);
  }

  late final _upsertProduct = ref.mutation((ref, ProductModel product) async {
    await CartItemsProviders.upsert(
      ref,
      Env.organizationId,
      _cartFb.value!.id,
      itemId: widget.cartItemId,
      buyers: _buyersFb.value,
      productId: product.id,
      quantity: _quantityFb.value,
      ingredientsAdded: _ingredientsAddableFb.value,
      levels: _levelsFb.value.lockUnsafe.cast(),
    );
  }, onError: (_, error) {
    CoreUtils.showErrorSnackBar(context, error);
  }, onSuccess: (product, __) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${product.title} has been added to your shopping cart!'),
      action: SnackBarAction(
        onPressed: () => const CartsRoute().go(context),
        label: 'Cart',
      ),
    ));
    context.pop();
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_provider);
    final items = state.valueOrNull;
    final isIdle = !ref.watchIsMutating([_upsertProduct]);

    return HarmonicScaffold(
      appBar: AppBar(
        title: Text(state.valueOrNull?.product.title ?? 'Product...'),
      ),
      floatingActionButton: FixedFloatingActionButton.extended(
        onPressed: isIdle && items != null ? () => _upsertProduct(items.product) : null,
        icon: widget.cartItemId == null ? const Icon(Icons.add) : const Icon(Icons.edit),
        label: Text(widget.cartItemId == null ? 'Add to Cart' : 'Update Cart Item'),
      ),
      body: state.buildView(
        onRefresh: () => ref.invalidateWithAncestors(_provider),
        data: (items) => _buildBody(
          context,
          items.product.addableIngredients,
          items.product.levels,
          items.carts,
        ),
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    IList<IngredientDto> addableIngredients,
    IList<LevelDto> levels,
    IList<CartModel> carts,
  ) {
    final t = AppFormats.of(context);

    Widget buildCartField() {
      return FieldPadding(ReactiveDropdownField(
        formControl: _cartFb,
        decoration: const InputDecoration(labelText: 'Cart'),
        items: carts.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e.displayTitle),
          );
        }).toList(),
      ));
    }

    Widget buildBuyersField(IList<UserDto> users) {
      return FieldPadding(ReactivePopupMenuButton<UserDto>.withChip(
        formControl: _buyersFb,
        decoration: const InputDecoration(labelText: 'Buyers'),
        itemBuilder: (field) => users.map((user) {
          return CheckedPopupMenuItem(
            value: user,
            checked: field.value.contains(user),
            child: Text(user.displayName!),
          );
        }).toList(),
      ));
    }

    Widget buildQuantityField() {
      return FieldPadding(ReactiveDropdownField(
        formControl: _quantityFb,
        decoration: const InputDecoration(labelText: 'Quantity'),
        items: [
          for (var i = 1; i <= 8; i++)
            DropdownMenuItem(
              value: i,
              child: Text('$i'),
            ),
        ],
      ));
    }

    Widget buildLevelsFields(Map<String, FormControl<double>> fieldBlocs) {
      return Column(
        children: fieldBlocs.entries.mapTo((ingredientId, fieldBloc) {
          final ingredient = levels.firstWhereOrNull((e) => e.id == ingredientId);
          if (ingredient == null) return const SizedBox.shrink();

          final divisions = ingredient.offset;
          return FieldPadding(ReactiveDecoratedSlider(
            formControl: fieldBloc,
            divisions: divisions,
            decoration: InputDecoration(labelText: ingredient.title),
            labelBuilder: (value) => (divisions * value).toStringAsFixed(0),
          ));
        }).toList(),
      );
    }

    Widget buildIngredientsField() {
      if (addableIngredients.isEmpty) return const SizedBox.shrink();

      return FieldPadding(ReactiveFormFieldDecorated(
        formControl: _ingredientsAddableFb,
        decoration: const InputDecoration(
          labelText: 'Additions',
        ),
        builder: (field) => Column(
          children: addableIngredients.map((value) {
            return CheckboxListTile(
              value: field.value?.contains(value),
              enabled: field.control.enabled,
              onChanged: (isSelected) => field.didToggle(isSelected, value),
              title: Text('${t.formatPrice(value.price)} - ${value.title}'),
              subtitle: Text(value.description),
            );
          }).toList(),
        ),
      ));
    }

    return HarmonicSingleChildScrollView(
      child: Column(
        children: [
          if (carts.length > 1) buildCartField(),
          Consumer(builder: (context, ref, _) {
            final members = ref.watch(_cartFb.provider.value)?.members ?? const IListConst([]);
            if (members.length <= 1) return const SizedBox.shrink();
            return buildBuyersField(members);
          }),
          buildQuantityField(),
          Consumer(builder: (context, ref, _) {
            final fieldBlocs = ref.watch(_levelsFb.provider.controls);
            return buildLevelsFields(fieldBlocs.cast());
          }),
          buildIngredientsField(),
        ],
      ),
    );
  }
}
