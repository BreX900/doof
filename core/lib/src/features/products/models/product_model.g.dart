// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks, unused_field

part of 'product_model.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$ProductModel {
  ProductModel get _self => this as ProductModel;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModel &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.category == other.category &&
          _self.imageUrl == other.imageUrl &&
          _self.title == other.title &&
          _self.description == other.description &&
          _self.price == other.price &&
          _self.ingredients == other.ingredients &&
          _self.removableIngredients == other.removableIngredients &&
          _self.addableIngredients == other.addableIngredients &&
          _self.levels == other.levels;

  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.category.hashCode);
    hashCode = $hashCombine(hashCode, _self.imageUrl.hashCode);
    hashCode = $hashCombine(hashCode, _self.title.hashCode);
    hashCode = $hashCombine(hashCode, _self.description.hashCode);
    hashCode = $hashCombine(hashCode, _self.price.hashCode);
    hashCode = $hashCombine(hashCode, _self.ingredients.hashCode);
    hashCode = $hashCombine(hashCode, _self.removableIngredients.hashCode);
    hashCode = $hashCombine(hashCode, _self.addableIngredients.hashCode);
    hashCode = $hashCombine(hashCode, _self.levels.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() =>
      (ClassToString('ProductModel')
            ..add('id', _self.id)
            ..add('category', _self.category)
            ..add('imageUrl', _self.imageUrl)
            ..add('title', _self.title)
            ..add('description', _self.description)
            ..add('price', _self.price)
            ..add('ingredients', _self.ingredients)
            ..add('removableIngredients', _self.removableIngredients)
            ..add('addableIngredients', _self.addableIngredients)
            ..add('levels', _self.levels))
          .toString();
}
