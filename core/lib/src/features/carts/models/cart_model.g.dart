// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks

part of 'cart_model.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$CartModel {
  CartModel get _self => this as CartModel;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartModel &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.owner == other.owner &&
          _self.members == other.members &&
          _self.isPublic == other.isPublic &&
          _self.title == other.title;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.owner.hashCode);
    hashCode = $hashCombine(hashCode, _self.members.hashCode);
    hashCode = $hashCombine(hashCode, _self.isPublic.hashCode);
    hashCode = $hashCombine(hashCode, _self.title.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('CartModel')
        ..add('id', _self.id)
        ..add('owner', _self.owner)
        ..add('members', _self.members)
        ..add('isPublic', _self.isPublic)
        ..add('title', _self.title))
      .toString();
}

mixin _$CartItemModel {
  CartItemModel get _self => this as CartItemModel;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemModel &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.product == other.product &&
          _self.quantity == other.quantity &&
          _self.buyers == other.buyers &&
          _self.ingredientsRemoved == other.ingredientsRemoved &&
          _self.ingredientsAdded == other.ingredientsAdded &&
          _self.levels == other.levels;
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
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('CartItemModel')
        ..add('id', _self.id)
        ..add('product', _self.product)
        ..add('quantity', _self.quantity)
        ..add('buyers', _self.buyers)
        ..add('ingredientsRemoved', _self.ingredientsRemoved)
        ..add('ingredientsAdded', _self.ingredientsAdded)
        ..add('levels', _self.levels))
      .toString();
}
