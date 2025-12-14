// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks, unused_field

part of 'product_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$ProductDto {
  ProductDto get _self => this as ProductDto;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.categoryId == other.categoryId &&
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
    hashCode = $hashCombine(hashCode, _self.categoryId.hashCode);
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
      (ClassToString('ProductDto')
            ..add('id', _self.id)
            ..add('categoryId', _self.categoryId)
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

class ProductDtoFields {
  const ProductDtoFields([this._path = '']);

  final String _path;

  String get id => '${_path}id';

  String get categoryId => '${_path}categoryId';

  String get imageUrl => '${_path}imageUrl';

  String get title => '${_path}title';

  String get description => '${_path}description';

  String get price => '${_path}price';

  String get ingredients => '${_path}ingredients';

  String get removableIngredients => '${_path}removableIngredients';

  String get addableIngredients => '${_path}addableIngredients';

  String get levels => '${_path}levels';

  @override
  String toString() => _path.isEmpty ? 'ProductDtoFields()' : _path;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDto _$ProductDtoFromJson(Map<String, dynamic> json) => ProductDto(
  id: json['id'] as String,
  categoryId: json['categoryId'] as String,
  imageUrl: json['imageUrl'] as String?,
  title: json['title'] as String,
  description: json['description'] as String,
  price: Fixed.fromJson(json['price'] as String),
  ingredients: IList<String>.fromJson(json['ingredients'], (value) => value as String),
  removableIngredients: IList<String>.fromJson(
    json['removableIngredients'],
    (value) => value as String,
  ),
  addableIngredients: IList<String>.fromJson(
    json['addableIngredients'],
    (value) => value as String,
  ),
  levels: IList<String>.fromJson(json['levels'], (value) => value as String),
);

Map<String, dynamic> _$ProductDtoToJson(ProductDto instance) => <String, dynamic>{
  'id': instance.id,
  'categoryId': instance.categoryId,
  'imageUrl': instance.imageUrl,
  'title': instance.title,
  'description': instance.description,
  'price': instance.price.toJson(),
  'ingredients': instance.ingredients.toJson((value) => value),
  'removableIngredients': instance.removableIngredients.toJson((value) => value),
  'addableIngredients': instance.addableIngredients.toJson((value) => value),
  'levels': instance.levels.toJson((value) => value),
};
