import 'dart:async';

import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/shared/navigation/areas/user_area.dart';
import 'package:mek_gasol/shared/widgets/bottom_button_bar.dart';

final _stateProvider =
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

class ProductScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  final String? productId;
  final String? cartId;
  final String? cartItemId;
  final OrderModel? order;
  final OrderItemModel? orderItem;

  ProductScreen({
    super.key,
    required String this.productId,
    this.order,
    this.orderItem,
  })  : cartId = null,
        cartItemId = null;

  ProductScreen.fromCart({
    super.key,
    required String this.cartItemId,
  })  : productId = null,
        order = null,
        orderItem = null,
        cartId = Env.cartId;

  late final stateProvider = _stateProvider((productId, cartId, cartItemId));

  @override
  ProviderBase<void> get asyncProvider => stateProvider;

  @override
  ConsumerState<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends ConsumerState<ProductScreen> with AsyncConsumerState {
  final _cartFb = FieldBloc<CartModel?>(
    initialValue: null,
    validator: const RequiredValidation<CartModel>(),
  );
  final _buyersFb = FieldBloc<IList<UserDto>>(
    initialValue: const IListConst([]),
    validator: const OptionsValidation<UserDto>(minLength: 1),
  );
  final _quantityFb = FieldBloc<int>(initialValue: 1);
  final _ingredientsAddableFb = FieldBloc<IList<IngredientDto>>(
    initialValue: const IListConst([]),
  );
  final _levelsFb = MapFieldBloc<String, double>();

  late final _form = ListFieldBloc<void>();

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  @override
  void dispose() {
    unawaited(_form.close());
    super.dispose();
  }

  Future<void> _init() async {
    final (:user, :product, :carts, :cart, :cartItem) =
        await ref.read(widget.stateProvider.futureOfData);
    final levels = product.levels;

    final order = widget.order;
    final orderItem = widget.orderItem;
    final orderCart = carts.firstWhereIdOrNull(order?.id);
    final orderItemBuyers = orderCart != null ? orderItem?.buyers : null;

    _cartFb.updateValue(cart ?? orderCart ?? carts.singleOrNull);
    if (user != null) _buyersFb.updateValue(cartItem?.buyers ?? orderItemBuyers ?? IList([user]));
    _quantityFb.updateValue(cartItem?.quantity ?? orderItem?.quantity);
    _ingredientsAddableFb.updateValue(cartItem?.ingredientsAdded ?? orderItem?.ingredientsAdded);

    final prevIngredients = cartItem?.levels ?? orderItem?.levels;
    double resolveInitialIngredientValue(LevelDto ingredient) {
      final prevEntry = prevIngredients?.entries.firstWhereOrNull((e) => e.key.id == ingredient.id);
      if (prevEntry != null) return prevEntry.value;
      return ingredient.initialOffset;
    }

    _levelsFb.updateFieldBlocs({
      for (final ingredient in levels)
        ingredient.id: FieldBloc(
          initialValue: resolveInitialIngredientValue(ingredient),
        ),
    }.toIMap());

    _form.updateFieldBlocs([
      _cartFb,
      if (user != null) _buyersFb,
      _quantityFb,
      _ingredientsAddableFb,
      _levelsFb,
    ]);
  }

  late final _upsertProduct = ref.mutation((ref, ProductModel product) async {
    await CartItemsProviders.upsert(
      ref,
      Env.organizationId,
      _cartFb.state.value!.id,
      itemId: widget.cartItemId,
      buyers: _buyersFb.state.value,
      productId: product.id,
      quantity: _quantityFb.state.value,
      ingredientsAdded: _ingredientsAddableFb.state.value,
      levels: _levelsFb.state.value,
    );
  }, onError: (_, error) {
    DataBuilders.listenError(context, error);
  }, onSuccess: (product, __) {
    final tabBloc = ref.read(UserArea.tab.notifier);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('${product.title} has been added to your shopping cart!'),
      action: SnackBarAction(
        onPressed: () => tabBloc.state = UserAreaTab.carts,
        label: 'Cart',
      ),
    ));
    context.pop();
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final items = state.valueOrNull;
    final isIdle = ref.watchIdle(mutations: [_upsertProduct]);

    return Scaffold(
      appBar: AppBar(
        title: Text(state.valueOrNull?.product.title ?? 'Product...'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isIdle && items != null ? () => _upsertProduct(items.product) : null,
              icon: widget.cartItemId == null ? const Icon(Icons.add) : const Icon(Icons.edit),
              label: Text(widget.cartItemId == null ? 'Add to Cart' : 'Update Cart Item'),
            ),
          ),
        ],
      ),
      body: AsyncViewBuilder(
        state: state,
        refreshableScroll: true,
        builder: (context, items) => _buildBody(
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
      return FieldDropdown(
        fieldBloc: _cartFb,
        decoration: const InputDecoration(labelText: 'Cart'),
        items: carts.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e.displayTitle),
          );
        }).toList(),
      );
    }

    Widget buildBuyersField(IList<UserDto> users) {
      return FieldChipsInput<UserDto>(
        fieldBloc: _buyersFb,
        decoration: const InputDecoration(labelText: 'Buyers'),
        findSuggestions: (query) {
          return users.where((user) {
            return user.displayName!.toLowerCase().contains(query.toLowerCase());
          }).toList();
        },
        suggestionBuilder: (context, suggestion) => ListTile(title: Text(suggestion.displayName!)),
        chipBuilder: (context, state, value) {
          return Chip(
            onDeleted: () => state.deleteChip(value),
            label: Text(value.displayName!),
          );
        },
      );
    }

    Widget buildQuantityField() {
      return FieldDropdown(
        fieldBloc: _quantityFb,
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

    Widget buildLevelsFields(IMap<String, FieldBlocRule<double>> fieldBlocs) {
      return Column(
        children: fieldBlocs.entries.mapTo((ingredientId, fieldBloc) {
          final ingredient = levels.firstWhereOrNull((e) => e.id == ingredientId);
          if (ingredient == null) return const SizedBox.shrink();

          final divisions = ingredient.offset;
          return FieldSlider(
            fieldBloc: fieldBloc,
            divisions: divisions,
            decoration: InputDecoration(labelText: ingredient.title),
            labelBuilder: (value) => (divisions * value).toStringAsFixed(0),
          );
        }).toList(),
      );
    }

    Widget buildIngredientsField() {
      if (addableIngredients.isEmpty) return const SizedBox.shrink();

      return FieldGroupBuilder(
        fieldBloc: _ingredientsAddableFb,
        valuesCount: addableIngredients.length,
        decoration: const InputDecoration(
          labelText: 'Additions',
        ),
        valueBuilder: (state, index) {
          final value = addableIngredients[index];

          return CheckboxListTile(
            value: state.value.contains(value),
            enabled: state.isEnabled,
            onChanged: (isSelected) => state.fieldBloc.changeTogglingValue(isSelected, value),
            title: Text('${t.formatPrice(value.price)} - ${value.title}'),
            subtitle: Text(value.description),
          );
        },
      );
    }

    return SingleChildScrollView(
      child: Column(
        children: [
          if (carts.length > 1) buildCartField(),
          Consumer(builder: (context, ref, _) {
            final members =
                ref.watch(_cartFb.select((state) => state.value?.members ?? const IListConst([])));
            if (members.length <= 1) return const SizedBox.shrink();
            return buildBuyersField(members);
          }),
          buildQuantityField(),
          Consumer(builder: (context, ref, _) {
            final fieldBlocs = ref.watch(_levelsFb.select((state) => state.fieldBlocs));
            return buildLevelsFields(fieldBlocs);
          }),
          buildIngredientsField(),
        ],
      ),
    );
  }
}
