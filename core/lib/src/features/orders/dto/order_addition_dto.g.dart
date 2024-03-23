// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks

part of 'order_addition_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$OrderIngredientDto {
  OrderIngredientDto get _self => this as OrderIngredientDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderIngredientDto &&
          runtimeType == other.runtimeType &&
          _self.ingredient == other.ingredient &&
          _self.value == other.value;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.ingredient.hashCode);
    hashCode = $hashCombine(hashCode, _self.value.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('OrderIngredientDto')
        ..add('ingredient', _self.ingredient)
        ..add('value', _self.value))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderIngredientDto _$OrderIngredientDtoFromJson(Map<String, dynamic> json) =>
    OrderIngredientDto(
      ingredient:
          IngredientDto.fromJson(json['ingredient'] as Map<String, dynamic>),
      value: json['value'] as bool,
    );

Map<String, dynamic> _$OrderIngredientDtoToJson(OrderIngredientDto instance) =>
    <String, dynamic>{
      'ingredient': instance.ingredient.toJson(),
      'value': instance.value,
    };
