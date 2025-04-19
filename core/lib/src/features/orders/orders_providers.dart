import 'dart:async';

import 'package:core/src/features/orders/dto/order_dto.dart';
import 'package:core/src/features/orders/models/order_model.dart';
import 'package:core/src/features/orders/repositories/order_items_repository.dart';
import 'package:core/src/features/orders/repositories/orders_repository.dart';
import 'package:core/src/features/products/products_providers.dart';
import 'package:core/src/features/users/dto/user_dto.dart';
import 'package:core/src/features/users/users_providers.dart';
import 'package:core/src/shared/core_utils.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

abstract class OrdersProviders {
  static final all = StreamProvider.family(
      (ref, (String organizationId, {List<OrderStatus> whereNotStatusIn}) args) async* {
    final (organizationId, :whereNotStatusIn) = args;
    final userId = await ref.watch(UsersProviders.currentId.future);
    if (userId == null) throw MissingCredentialsFailure();
    final users = await ref.watch(UsersProviders.all.future);

    await for (final orders in OrdersRepository.instance.watchAll(
      organizationId,
      userId: userId,
      whereNotStatusIn: whereNotStatusIn,
    )) {
      yield orders.map((order) => _modelFrom(order, users: users)).toIList();
    }
  });

  static Future<void> delete(MutationRef ref, String organizationId, OrderModel order) async {
    if (order.status != OrderStatus.accepting) throw StateError('Cant delete draft order');

    final items = await ref.read(OrderItemsProviders.all((organizationId, order.id)).future);

    await Future.wait(items.map((e) async {
      await OrderItemsRepository.instance.delete(order.id, e.id);
    }));
    await OrdersRepository.instance.delete(organizationId, order.id);
  }

  /// ========== ADMIN

  static final pageCursor = StateNotifierProvider<CursorBloc, CursorState>((ref) {
    return CursorBloc(size: CoreUtils.tableSize);
  });

  static final page = StreamProvider.family((ref, (String organiationId,) args) async* {
    final (organizationId,) = args;
    final users = await ref.watch(UsersProviders.all.future);
    final cursor = ref.watch(pageCursor.select((value) => value.pageCursor));

    final onPage = OrdersRepository.instance.watchPage(organizationId, cursor);

    await for (final page in onPage) {
      ref.read(pageCursor.notifier).registerOffsets(page.ids, page: cursor.page);
      yield page.map((e) => _modelFrom(e, users: users)).toList();
    }
  });

  static final single =
      FutureProvider.autoDispose.family((ref, (String organizationId, String orderId) args) async {
    final (organizationId, orderId) = args;
    final users = await ref.watch(UsersProviders.all.future);
    final order = await OrdersRepository.instance.fetch(organizationId, orderId);

    return _modelFrom(order, users: users);
  });

  static Future<void> update(
    MutationRef ref,
    String organizationId,
    String orderId, {
    required OrderStatus status,
  }) async {
    await OrdersRepository.instance.update(organizationId, orderId, OrderUpdateDto(status: status));
  }
}

abstract class OrderItemsProviders {
  static final single = FutureProvider.family(
      (ref, (String orderId, String itemId, {String organizationId}) args) async {
    final (orderId, itemId, :organizationId) = args;
    final products = await ref.watch(all((organizationId, orderId)).future);
    return products.firstWhere((product) => product.id == itemId);
  });

  static final all =
      FutureProvider.family((ref, (String organizationId, String orderId) args) async {
    final (organizationId, orderId) = args;
    final users = await ref.watch(UsersProviders.all.future);
    final items = await OrderItemsRepository.instance.fetchAll(orderId);
    final products = await ref.watch(ProductsProviders.all(organizationId).future);

    return items.map((item) {
      return OrderItemModel(
        id: item.id,
        buyers: users.whereIds(item.buyers).toIList(),
        product: products.firstWhereId(item.product.id),
        quantity: item.quantity,
        ingredientsRemoved:
            item.ingredients.where((e) => !e.value).map((e) => e.ingredient).toIList(),
        ingredientsAdded: item.ingredients.where((e) => e.value).map((e) => e.ingredient).toIList(),
        levels: IMap.fromEntries(item.levels.map((e) {
          return MapEntry(e.level, e.value);
        })),
        payedAmount: item.payedAmount,
      );
    }).toIList();
  });
}

OrderModel _modelFrom(OrderDto order, {required Iterable<UserDto> users}) {
  return OrderModel(
    id: order.id,
    originCartId: order.originCartId,
    createdAt: order.createdAt,
    updatedAt: order.updatedAt,
    payer: users.firstWhereId(order.payerId),
    members: users.whereIds(order.membersIds).toIList(),
    shippable: order.shippable,
    status: order.status,
    place: order.place,
    payedAmount: order.payedAmount,
  );
}
