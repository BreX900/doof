// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks, unused_field

part of 'organization_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$OrganizationDto {
  OrganizationDto get _self => this as OrganizationDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrganizationDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.name == other.name;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.name.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('OrganizationDto')
        ..add('id', _self.id)
        ..add('name', _self.name))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrganizationDto _$OrganizationDtoFromJson(Map<String, dynamic> json) =>
    OrganizationDto(
      id: json['id'] as String,
      name: json['title'] as String,
    );

Map<String, dynamic> _$OrganizationDtoToJson(OrganizationDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.name,
    };
