// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks, unused_field

part of 'category_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$CategoryDto {
  CategoryDto get _self => this as CategoryDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.weight == other.weight &&
          _self.title == other.title;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.weight.hashCode);
    hashCode = $hashCombine(hashCode, _self.title.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('CategoryDto')
        ..add('id', _self.id)
        ..add('weight', _self.weight)
        ..add('title', _self.title))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => CategoryDto(
      id: json['id'] as String,
      weight: (json['weight'] as num).toInt(),
      title: json['title'] as String,
    );

abstract final class _$CategoryDtoJsonKeys {
  static const String id = 'id';
  static const String weight = 'weight';
  static const String title = 'title';
}

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weight': instance.weight,
      'title': instance.title,
    };
