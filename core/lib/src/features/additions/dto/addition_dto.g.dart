// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks

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
  String toString() => (ClassToString('IngredientDto')
        ..add('id', _self.id)
        ..add('title', _self.title)
        ..add('description', _self.description)
        ..add('price', _self.price))
      .toString();
}

class _IngredientDtoFields {
  // ignore: unused_element
  const _IngredientDtoFields([this._path = '']);

  final String _path;

  String get id => '${_path}id';

  String get title => '${_path}title';

  String get description => '${_path}description';

  String get price => '${_path}price';

  @override
  String toString() => _path.isEmpty ? '_IngredientDtoFields()' : _path;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IngredientDto _$IngredientDtoFromJson(Map<String, dynamic> json) =>
    IngredientDto(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      price: Decimal.fromJson(json['price'] as String),
    );

Map<String, dynamic> _$IngredientDtoToJson(IngredientDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'price': instance.price.toJson(),
    };
