// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks, unused_field

part of 'order_ingredient_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$OrderLevelDto {
  OrderLevelDto get _self => this as OrderLevelDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderLevelDto &&
          runtimeType == other.runtimeType &&
          _self.level == other.level &&
          _self.value == other.value;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.level.hashCode);
    hashCode = $hashCombine(hashCode, _self.value.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('OrderLevelDto')
        ..add('level', _self.level)
        ..add('value', _self.value))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderLevelDto _$OrderLevelDtoFromJson(Map<String, dynamic> json) =>
    OrderLevelDto(
      level: LevelDto.fromJson(json['level'] as Map<String, dynamic>),
      value: (json['value'] as num).toDouble(),
    );

Map<String, dynamic> _$OrderLevelDtoToJson(OrderLevelDto instance) =>
    <String, dynamic>{
      'level': instance.level.toJson(),
      'value': instance.value,
    };
