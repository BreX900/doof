// ignore: implementation_imports, depend_on_referenced_packages
import 'package:cloud_firestore_platform_interface/src/method_channel/utils/auto_id_generator.dart';
import 'package:core/src/features/carts/dto/cart_dto.dart';
import 'package:core/src/shared/instances.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mekart/mekart.dart';

extension on BinSession {
  BinStore<IMap<String, CartItemDto>> get cartItems {
    return BinStore(
      session: this,
      name: 'cart_items',
      serializer: (data) => data.map((key, value) {
        return MapEntry(key, {...value.toJson()}..remove('id'));
      }).unlockView,
      deserializer: (data) => (data as Map<String, dynamic>).map((key, data) {
        return MapEntry(key, CartItemDto.fromJson({...data as Map<String, dynamic>, 'id': key}));
      }).lockUnsafe,
      fallbackData: const IMap<String, CartItemDto>.empty(),
    );
  }
}

class LocalCartItemsRepository {
  static BinStore<IMap<String, CartItemDto>> get _itemsBin => Instances.bins.cartItems;

  static LocalCartItemsRepository get instance => LocalCartItemsRepository._();
  LocalCartItemsRepository._();

  Future<IList<CartItemDto>> fetchAll() async {
    final entries = await _itemsBin.read();
    return entries.values.toIList();
  }

  Stream<IList<CartItemDto>> watchAll() {
    return _itemsBin.stream.map((event) => event.values.toIList());
  }

  Future<void> add(CartItemDto item) async {
    await _itemsBin.set(item.id.nullIfEmpty ?? AutoIdGenerator.autoId(), item);
  }

  Future<void> remove(String itemId) async {
    await _itemsBin.remove(itemId);
  }

  Future<void> clear() async {
    await _itemsBin.delete();
  }
}
