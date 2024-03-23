import 'dart:async';

import 'package:collection/collection.dart';
import 'package:core/src/features/additions/additions_providers.dart';
import 'package:core/src/features/additions/dto/addition_dto.dart';
import 'package:core/src/features/carts/dto/cart_dto.dart';
import 'package:core/src/features/carts/models/cart_model.dart';
import 'package:core/src/features/carts/repositories/cart_items_repository.dart';
import 'package:core/src/features/carts/repositories/carts_repository.dart';
import 'package:core/src/features/carts/repositories/local_cart_items_repository.dart';
import 'package:core/src/features/ingredients/ingredients_providers.dart';
import 'package:core/src/features/orders/repositories/order_items_repository.dart';
import 'package:core/src/features/orders/repositories/orders_repository.dart';
import 'package:core/src/features/products/products_providers.dart';
import 'package:core/src/features/products/repositories/products_repository.dart';
import 'package:core/src/features/users/dto/user_dto.dart';
import 'package:core/src/features/users/users_providers.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:core/src/utils/dart_utils.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pure_extensions/pure_extensions.dart';

abstract class CartsProviders {
  static final personal = FutureProvider.family((ref, String organizationId) async {
    final userId = await ref.watch(UsersProviders.currentId.future);
    if (userId == null) return CartModel.local;

    final carts = await ref.watch(all(organizationId).future);
    return carts.firstWhere((cart) => cart.isPersonal(userId));
  });

  static final first =
      FutureProvider.family((ref, (String organizationId, String cartId) args) async {
    final (organizationId, cartId) = args;
    final carts = await ref.watch(all(organizationId).future);
    return carts.firstWhereId(cartId);
  });

  static final all = FutureProvider.family((ref, String organizationId) async {
    final user = await ref.watch(UsersProviders.current.future);
    if (user == null) return const IListConst([CartModel.local]);

    final users = await ref.watch(UsersProviders.all.future);
    final carts = await ref.watch(_all(organizationId).future);

    var allCarts = carts.map((cart) {
      return CartModel(
        id: cart.id,
        owner: users.firstWhereId(cart.ownerId),
        members: users.whereIds(cart.membersIds).toIList(),
        isPublic: cart.isPublic,
        title: cart.title,
      );
    });

    if (!allCarts.any((e) => e.isPersonal(user.id))) {
      allCarts = [
        CartModel(
          id: CartModel.temporaryId,
          owner: user,
          members: [user].toIList(),
          isPublic: false,
          title: null,
        ),
        ...allCarts
      ];
    }

    return allCarts.toIList();
  });

  static final public =
      StreamProvider.family((ref, (String organizationId, String cartId) args) async* {
    final (organizationId, cartId) = args;

    final users = await ref.watch(UsersProviders.all.future);
    await for (final cart in CartsRepository.instance.watch(organizationId, cartId)) {
      yield CartModel(
        id: cart.id,
        owner: users.firstWhereId(cart.ownerId),
        members: users.whereIds(cart.membersIds).toIList(),
        isPublic: cart.isPublic,
        title: cart.title,
      );
    }
  });

  static Future<void> create(Ref ref, String organizationId, {required String title}) async {
    await CartsRepository.instance.create(organizationId, isPublic: true, title: title);
  }

  static Future<void> sendOrder(
    Ref ref,
    String organizationId, {
    required CartModel cart,
    required Iterable<CartItemModel> items,
    String? place,
  }) async {
    final userId = await ref.read(UsersProviders.currentId.future);
    if (userId == null) throw MissingCredentialsFailure();

    final total = items.fold(Decimal.zero, (total, e) => total + e.totalCost);

    final orderId = await OrdersRepository.instance.create(
      organizationId,
      payerId: userId,
      cartId: cart.id,
      membersIds: items.expand((e) => e.buyers.map((e) => e.id)).toList(),
      place: place?.nullIfEmpty(),
      payedAmount: total,
    );
    await Future.wait(items.map((e) async {
      final product = await ProductsRepository.instance.fetch(organizationId, e.product.id);

      await OrderItemsRepository.instance.create(
        orderId,
        payedAmount: e.totalCost,
        levels: e.levels,
        ingredientsRemoved: e.ingredientsRemoved,
        ingredientsAdded: e.ingredientsAdded,
        buyers: e.buyers,
        product: product,
        quantity: e.quantity,
      );
    }));

    await Future.wait(items.map((e) async {
      await CartItemsRepository.instance.remove(cart.id, e.id);
    }));
  }

  static Future<void> join(Ref ref, String organizationId, String cartId) async {
    final user = await ref.read(UsersProviders.current.future);
    if (user == null) throw MissingCredentialsFailure();
    await CartsRepository.instance.addMember(organizationId, cartId, userId: user.id);
  }

  static final _all = StreamProvider.family((ref, String organizationId) async* {
    final user = await ref.watch(UsersProviders.current.future);
    if (user == null) throw MissingCredentialsFailure();
    yield* CartsRepository.instance.watchAll(organizationId, userId: user.id);
  });
}

abstract class CartItemsProviders {
  static final first = FutureProvider.family(
      (ref, (String organizationId, String cartId, String itemId) args) async {
    final (organizationId, cartId, itemId) = args;

    final products = await ref.watch(all((organizationId, cartId)).future);
    return products.firstWhereId(itemId);
  });

  static final all =
      FutureProvider.family((ref, (String organizationId, String cartId) args) async {
    final (organizationId, cartId) = args;

    final users = await ref.watch(UsersProviders.all.future);
    final products = await ref.watch(ProductsProviders.all(organizationId).future);
    final cartItems = await ref.watch(_all(cartId).future);

    return await FutureUtils.map(cartItems, (e) async {
      final ingredients = await ref.watch(IngredientsProviders.all(organizationId).future);
      final levels = await ref.watch(LevelsProviders.all((organizationId,)).future);

      return CartItemModel(
        id: e.id,
        product: products.firstWhereId(e.productId),
        quantity: e.quantity,
        buyers: users.whereIds(e.buyers).sortedBy((e) => e.displayName!).toIList(),
        ingredientsRemoved:
            e.ingredientsRemoved.map(ingredients.firstWhereId).sortedBy((e) => e.title).toIList(),
        ingredientsAdded:
            e.ingredientsAdded.map(ingredients.firstWhereId).sortedBy((e) => e.title).toIList(),
        levels: IMap.fromEntries(e.levels.mapTo((key, value) {
          return MapEntry(levels.firstWhereId(key), value);
        }).sortedBy((e) => e.key.title)),
      );
    });
  });

  static Future<void> upsert(
    Ref ref,
    String organizationId,
    String cartId, {
    String? itemId,
    required String productId,
    Iterable<UserDto> buyers = const [],
    int quantity = 1,
    Iterable<IngredientDto> ingredientsAdded = const [],
    Iterable<IngredientDto> ingredientsRemoved = const [],
    IMap<String, double> levels = const IMapConst({}),
  }) async {
    final item = CartItemDto(
      id: itemId ?? '',
      productId: productId,
      buyers: buyers.map((e) => e.id).toIList(),
      quantity: quantity,
      ingredientsRemoved: ingredientsRemoved.map((e) => e.id).toIList(),
      ingredientsAdded: ingredientsAdded.map((e) => e.id).toIList(),
      levels: levels,
    );
    var targetCartId = cartId;
    if (targetCartId == CartModel.localId) {
      await LocalCartItemsRepository.instance.add(item);
      return;
    }
    if (targetCartId == CartModel.temporaryId) {
      targetCartId =
          await CartsRepository.instance.create(organizationId, isPublic: false, title: null);
    }
    await CartItemsRepository.instance.upsert(targetCartId, item);
  }

  static Future<void> remove(Ref ref, String cartId, String itemId) async {
    if (cartId == CartModel.localId) {
      await LocalCartItemsRepository.instance.remove(itemId);
      return;
    }
    assert(cartId != CartModel.temporaryId, 'Item not exist in cart because it is temporary item');
    await CartItemsRepository.instance.remove(cartId, itemId);
  }

  static final _all = StreamProvider.family((ref, String cartId) {
    if (cartId == CartModel.localId) {
      return LocalCartItemsRepository.instance.watchAll();
    }
    if (cartId == CartModel.temporaryId) {
      return Stream.value(const IListConst<CartItemDto>([]));
    }
    return CartItemsRepository.instance.watchAll(cartId);
  });
}
