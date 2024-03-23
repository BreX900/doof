// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks

part of 'cart_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$CartDto {
  CartDto get _self => this as CartDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.ownerId == other.ownerId &&
          _self.membersIds == other.membersIds &&
          _self.isPublic == other.isPublic &&
          _self.title == other.title;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.ownerId.hashCode);
    hashCode = $hashCombine(hashCode, _self.membersIds.hashCode);
    hashCode = $hashCombine(hashCode, _self.isPublic.hashCode);
    hashCode = $hashCombine(hashCode, _self.title.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('CartDto')
        ..add('id', _self.id)
        ..add('ownerId', _self.ownerId)
        ..add('membersIds', _self.membersIds)
        ..add('isPublic', _self.isPublic)
        ..add('title', _self.title))
      .toString();
}

class _CartDtoFields {
  // ignore: unused_element
  const _CartDtoFields([this._path = '']);

  final String _path;

  String get id => '${_path}id';

  String get ownerId => '${_path}ownerId';

  String get membersIds => '${_path}membersIds';

  String get isPublic => '${_path}isPublic';

  String get title => '${_path}title';

  @override
  String toString() => _path.isEmpty ? '_CartDtoFields()' : _path;
}

mixin _$CartItemDto {
  CartItemDto get _self => this as CartItemDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.productId == other.productId &&
          _self.quantity == other.quantity &&
          _self.buyers == other.buyers &&
          _self.ingredientsRemoved == other.ingredientsRemoved &&
          _self.ingredientsAdded == other.ingredientsAdded &&
          _self.levels == other.levels;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.productId.hashCode);
    hashCode = $hashCombine(hashCode, _self.quantity.hashCode);
    hashCode = $hashCombine(hashCode, _self.buyers.hashCode);
    hashCode = $hashCombine(hashCode, _self.ingredientsRemoved.hashCode);
    hashCode = $hashCombine(hashCode, _self.ingredientsAdded.hashCode);
    hashCode = $hashCombine(hashCode, _self.levels.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('CartItemDto')
        ..add('id', _self.id)
        ..add('productId', _self.productId)
        ..add('quantity', _self.quantity)
        ..add('buyers', _self.buyers)
        ..add('ingredientsRemoved', _self.ingredientsRemoved)
        ..add('ingredientsAdded', _self.ingredientsAdded)
        ..add('levels', _self.levels))
      .toString();
  CartItemDto change(void Function(_CartItemDtoChanges c) updates) =>
      (_CartItemDtoChanges._(_self)..update(updates)).build();
  _CartItemDtoChanges toChanges() => _CartItemDtoChanges._(_self);
}

class _CartItemDtoChanges {
  _CartItemDtoChanges._(CartItemDto dc)
      : id = dc.id,
        productId = dc.productId,
        quantity = dc.quantity,
        buyers = dc.buyers,
        ingredientsRemoved = dc.ingredientsRemoved,
        ingredientsAdded = dc.ingredientsAdded,
        levels = dc.levels;

  String id;

  String productId;

  int quantity;

  IList<String> buyers;

  IList<String> ingredientsRemoved;

  IList<String> ingredientsAdded;

  IMap<String, double> levels;

  void update(void Function(_CartItemDtoChanges c) updates) => updates(this);

  CartItemDto build() => CartItemDto(
        id: id,
        productId: productId,
        quantity: quantity,
        buyers: buyers,
        ingredientsRemoved: ingredientsRemoved,
        ingredientsAdded: ingredientsAdded,
        levels: levels,
      );
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartDto _$CartDtoFromJson(Map<String, dynamic> json) => CartDto(
      id: json['id'] as String,
      ownerId: json['ownerId'] as String,
      membersIds: IList<String>.fromJson(
          json['membersIds'], (value) => value as String),
      isPublic: json['isPublic'] as bool,
      title: json['title'] as String?,
    );

Map<String, dynamic> _$CartDtoToJson(CartDto instance) => <String, dynamic>{
      'id': instance.id,
      'ownerId': instance.ownerId,
      'membersIds': instance.membersIds.toJson(
        (value) => value,
      ),
      'isPublic': instance.isPublic,
      'title': instance.title,
    };

CartItemDto _$CartItemDtoFromJson(Map<String, dynamic> json) => CartItemDto(
      id: json['id'] as String,
      productId: json['productId'] as String,
      quantity: json['quantity'] as int,
      buyers:
          IList<String>.fromJson(json['buyers'], (value) => value as String),
      ingredientsRemoved: IList<String>.fromJson(
          json['ingredientsRemoved'], (value) => value as String),
      ingredientsAdded: IList<String>.fromJson(
          json['ingredientsAdded'], (value) => value as String),
      levels: IMap<String, double>.fromJson(
          json['levels'] as Map<String, dynamic>,
          (value) => value as String,
          (value) => (value as num).toDouble()),
    );

Map<String, dynamic> _$CartItemDtoToJson(CartItemDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'quantity': instance.quantity,
      'buyers': instance.buyers.toJson(
        (value) => value,
      ),
      'ingredientsRemoved': instance.ingredientsRemoved.toJson(
        (value) => value,
      ),
      'ingredientsAdded': instance.ingredientsAdded.toJson(
        (value) => value,
      ),
      'levels': instance.levels.toJson(
        (value) => value,
        (value) => value,
      ),
    };
