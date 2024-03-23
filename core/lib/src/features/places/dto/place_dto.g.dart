// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks

part of 'place_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$PlaceDto {
  PlaceDto get _self => this as PlaceDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlaceDto && runtimeType == other.runtimeType && _self.id == other.id;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('PlaceDto')..add('id', _self.id)).toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlaceDto _$PlaceDtoFromJson(Map<String, dynamic> json) => PlaceDto(
      id: json['id'] as String,
    );

Map<String, dynamic> _$PlaceDtoToJson(PlaceDto instance) => <String, dynamic>{
      'id': instance.id,
    };
