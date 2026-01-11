// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks, unused_field

part of 'addition_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$IngredientDto {
  IngredientDto get _self => this as IngredientDto;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.title == other.title &&
          _self.description == other.description &&
          _self.price == other.price;

  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.title.hashCode);
    hashCode = $hashCombine(hashCode, _self.description.hashCode);
    hashCode = $hashCombine(hashCode, _self.price.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() =>
      (ClassToString('IngredientDto')
            ..add('id', _self.id)
            ..add('title', _self.title)
            ..add('description', _self.description)
            ..add('price', _self.price))
          .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientDto _$IngredientDtoFromJson(Map<String, dynamic> json) =>
    IngredientDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: Fixed.fromJson(json['price'] as String),
    );

abstract final class _$IngredientDtoJsonKeys {
  static const String id = 'id';
  static const String title = 'title';
  static const String description = 'description';
  static const String price = 'price';
}

Map<String, dynamic> _$IngredientDtoToJson(IngredientDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price.toJson(),
    };
