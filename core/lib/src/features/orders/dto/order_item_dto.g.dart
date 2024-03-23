// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks

part of 'order_item_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$OrderItemDto {
  OrderItemDto get _self => this as OrderItemDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.createdAt == other.createdAt &&
          _self.buyers == other.buyers &&
          _self.product == other.product &&
          _self.quantity == other.quantity &&
          _self.ingredients == other.ingredients &&
          _self.levels == other.levels &&
          _self.payedAmount == other.payedAmount;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdAt.hashCode);
    hashCode = $hashCombine(hashCode, _self.buyers.hashCode);
    hashCode = $hashCombine(hashCode, _self.product.hashCode);
    hashCode = $hashCombine(hashCode, _self.quantity.hashCode);
    hashCode = $hashCombine(hashCode, _self.ingredients.hashCode);
    hashCode = $hashCombine(hashCode, _self.levels.hashCode);
    hashCode = $hashCombine(hashCode, _self.payedAmount.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('OrderItemDto')
        ..add('id', _self.id)
        ..add('createdAt', _self.createdAt)
        ..add('buyers', _self.buyers)
        ..add('product', _self.product)
        ..add('quantity', _self.quantity)
        ..add('ingredients', _self.ingredients)
        ..add('levels', _self.levels)
        ..add('payedAmount', _self.payedAmount))
      .toString();
}

class _OrderItemDtoFields {
  // ignore: unused_element
  const _OrderItemDtoFields([this._path = '']);

  final String _path;

  String get id => '${_path}id';

  String get createdAt => '${_path}createdAt';

  String get buyers => '${_path}buyers';

  ProductDtoFields get product => ProductDtoFields('${_path}product.');

  String get quantity => '${_path}quantity';

  String get ingredients => '${_path}ingredients';

  String get levels => '${_path}levels';

  String get payedAmount => '${_path}payedAmount';

  @override
  String toString() => _path.isEmpty ? '_OrderItemDtoFields()' : _path;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderItemDto _$OrderItemDtoFromJson(Map<String, dynamic> json) => OrderItemDto(
      id: json['id'] as String,
      createdAt:
          const TimestampJsonConvert().fromJson(json['createdAt'] as Timestamp),
      buyers:
          IList<String>.fromJson(json['buyers'], (value) => value as String),
      product: ProductDto.fromJson(json['product'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      ingredients: IList<OrderIngredientDto>.fromJson(
          json['ingredients'],
          (value) =>
              OrderIngredientDto.fromJson(value as Map<String, dynamic>)),
      levels: IList<OrderLevelDto>.fromJson(json['levels'],
          (value) => OrderLevelDto.fromJson(value as Map<String, dynamic>)),
      payedAmount: Decimal.fromJson(json['payedAmount'] as String),
    );

Map<String, dynamic> _$OrderItemDtoToJson(OrderItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'createdAt': const TimestampJsonConvert().toJson(instance.createdAt),
      'buyers': instance.buyers.toJson(
        (value) => value,
      ),
      'product': instance.product.toJson(),
      'quantity': instance.quantity,
      'ingredients': instance.ingredients.toJson(
        (value) => value.toJson(),
      ),
      'levels': instance.levels.toJson(
        (value) => value.toJson(),
      ),
      'payedAmount': instance.payedAmount.toJson(),
    };
