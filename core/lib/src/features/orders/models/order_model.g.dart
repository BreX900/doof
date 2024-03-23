// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks

part of 'order_model.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$OrderModel {
  OrderModel get _self => this as OrderModel;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModel &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.originCartId == other.originCartId &&
          _self.createdAt == other.createdAt &&
          _self.updatedAt == other.updatedAt &&
          _self.payer == other.payer &&
          _self.members == other.members &&
          _self.shippable == other.shippable &&
          _self.status == other.status &&
          _self.place == other.place &&
          _self.payedAmount == other.payedAmount;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.originCartId.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdAt.hashCode);
    hashCode = $hashCombine(hashCode, _self.updatedAt.hashCode);
    hashCode = $hashCombine(hashCode, _self.payer.hashCode);
    hashCode = $hashCombine(hashCode, _self.members.hashCode);
    hashCode = $hashCombine(hashCode, _self.shippable.hashCode);
    hashCode = $hashCombine(hashCode, _self.status.hashCode);
    hashCode = $hashCombine(hashCode, _self.place.hashCode);
    hashCode = $hashCombine(hashCode, _self.payedAmount.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('OrderModel')
        ..add('id', _self.id)
        ..add('originCartId', _self.originCartId)
        ..add('createdAt', _self.createdAt)
        ..add('updatedAt', _self.updatedAt)
        ..add('payer', _self.payer)
        ..add('members', _self.members)
        ..add('shippable', _self.shippable)
        ..add('status', _self.status)
        ..add('place', _self.place)
        ..add('payedAmount', _self.payedAmount))
      .toString();
}

mixin _$OrderItemModel {
  OrderItemModel get _self => this as OrderItemModel;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemModel &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.product == other.product &&
          _self.quantity == other.quantity &&
          _self.buyers == other.buyers &&
          _self.ingredientsRemoved == other.ingredientsRemoved &&
          _self.ingredientsAdded == other.ingredientsAdded &&
          _self.levels == other.levels &&
          _self.payedAmount == other.payedAmount;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.product.hashCode);
    hashCode = $hashCombine(hashCode, _self.quantity.hashCode);
    hashCode = $hashCombine(hashCode, _self.buyers.hashCode);
    hashCode = $hashCombine(hashCode, _self.ingredientsRemoved.hashCode);
    hashCode = $hashCombine(hashCode, _self.ingredientsAdded.hashCode);
    hashCode = $hashCombine(hashCode, _self.levels.hashCode);
    hashCode = $hashCombine(hashCode, _self.payedAmount.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('OrderItemModel')
        ..add('id', _self.id)
        ..add('product', _self.product)
        ..add('quantity', _self.quantity)
        ..add('buyers', _self.buyers)
        ..add('ingredientsRemoved', _self.ingredientsRemoved)
        ..add('ingredientsAdded', _self.ingredientsAdded)
        ..add('levels', _self.levels)
        ..add('payedAmount', _self.payedAmount))
      .toString();
}
