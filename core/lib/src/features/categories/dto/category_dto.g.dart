// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks

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

class _CategoryDtoFields {
  // ignore: unused_element
  const _CategoryDtoFields([this._path = '']);

  final String _path;

  String get id => '${_path}id';

  String get weight => '${_path}weight';

  String get title => '${_path}title';

  @override
  String toString() => _path.isEmpty ? '_CategoryDtoFields()' : _path;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDto _$CategoryDtoFromJson(Map<String, dynamic> json) => CategoryDto(
      id: json['id'] as String,
      weight: json['weight'] as int,
      title: json['title'] as String,
    );

Map<String, dynamic> _$CategoryDtoToJson(CategoryDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'weight': instance.weight,
      'title': instance.title,
    };
