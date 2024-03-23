// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks

part of 'ingredient_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$LevelDto {
  LevelDto get _self => this as LevelDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LevelDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.title == other.title &&
          _self.description == other.description &&
          _self.min == other.min &&
          _self.initial == other.initial &&
          _self.max == other.max;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.title.hashCode);
    hashCode = $hashCombine(hashCode, _self.description.hashCode);
    hashCode = $hashCombine(hashCode, _self.min.hashCode);
    hashCode = $hashCombine(hashCode, _self.initial.hashCode);
    hashCode = $hashCombine(hashCode, _self.max.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('LevelDto')
        ..add('id', _self.id)
        ..add('title', _self.title)
        ..add('description', _self.description)
        ..add('min', _self.min)
        ..add('initial', _self.initial)
        ..add('max', _self.max))
      .toString();
}

class _LevelDtoFields {
  // ignore: unused_element
  const _LevelDtoFields([this._path = '']);

  final String _path;

  String get id => '${_path}id';

  String get title => '${_path}title';

  String get description => '${_path}description';

  String get min => '${_path}min';

  String get initial => '${_path}initial';

  String get max => '${_path}max';

  @override
  String toString() => _path.isEmpty ? '_LevelDtoFields()' : _path;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LevelDto _$LevelDtoFromJson(Map<String, dynamic> json) => LevelDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      min: json['min'] as int,
      initial: json['initial'] as int?,
      max: json['max'] as int,
    );

Map<String, dynamic> _$LevelDtoToJson(LevelDto instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'min': instance.min,
      'initial': instance.initial,
      'max': instance.max,
    };
