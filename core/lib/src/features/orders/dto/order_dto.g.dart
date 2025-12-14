// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks, unused_field

part of 'order_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$OrderDto {
  OrderDto get _self => this as OrderDto;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.originCartId == other.originCartId &&
          _self.createdAt == other.createdAt &&
          _self.updatedAt == other.updatedAt &&
          _self.at == other.at &&
          _self.organizationId == other.organizationId &&
          _self.payerId == other.payerId &&
          _self.membersIds == other.membersIds &&
          _self.shippable == other.shippable &&
          _self.status == other.status &&
          _self.place == other.place &&
          _self.payedAmount == other.payedAmount;

  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.originCartId.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdAt.hashCode);
    hashCode = $hashCombine(hashCode, _self.updatedAt.hashCode);
    hashCode = $hashCombine(hashCode, _self.at.hashCode);
    hashCode = $hashCombine(hashCode, _self.organizationId.hashCode);
    hashCode = $hashCombine(hashCode, _self.payerId.hashCode);
    hashCode = $hashCombine(hashCode, _self.membersIds.hashCode);
    hashCode = $hashCombine(hashCode, _self.shippable.hashCode);
    hashCode = $hashCombine(hashCode, _self.status.hashCode);
    hashCode = $hashCombine(hashCode, _self.place.hashCode);
    hashCode = $hashCombine(hashCode, _self.payedAmount.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() =>
      (ClassToString('OrderDto')
            ..add('id', _self.id)
            ..add('originCartId', _self.originCartId)
            ..add('createdAt', _self.createdAt)
            ..add('updatedAt', _self.updatedAt)
            ..add('at', _self.at)
            ..add('organizationId', _self.organizationId)
            ..add('payerId', _self.payerId)
            ..add('membersIds', _self.membersIds)
            ..add('shippable', _self.shippable)
            ..add('status', _self.status)
            ..add('place', _self.place)
            ..add('payedAmount', _self.payedAmount))
          .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderDto _$OrderDtoFromJson(Map<String, dynamic> json) => OrderDto(
  id: json['id'] as String,
  originCartId: json['originCartId'] as String?,
  createdAt: const TimestampJsonConvert().fromJson(json['createdAt'] as Timestamp),
  updatedAt: const TimestampJsonConvert().fromJson(json['updatedAt'] as Timestamp),
  at: _$JsonConverterFromJson<Timestamp, DateTime>(
    json['at'],
    const TimestampJsonConvert().fromJson,
  ),
  organizationId: json['organizationId'] as String,
  payerId: json['payerId'] as String,
  membersIds: IList<String>.fromJson(json['membersIds'], (value) => value as String),
  status: $enumDecode(_$OrderStatusEnumMap, json['status']),
  shippable: json['shippable'] as bool,
  place: json['place'] as String?,
  payedAmount: Fixed.fromJson(json['payedAmount'] as String),
);

abstract final class _$OrderDtoJsonKeys {
  static const String id = 'id';
  static const String originCartId = 'originCartId';
  static const String createdAt = 'createdAt';
  static const String updatedAt = 'updatedAt';
  static const String at = 'at';
  static const String organizationId = 'organizationId';
  static const String payerId = 'payerId';
  static const String membersIds = 'membersIds';
  static const String shippable = 'shippable';
  static const String status = 'status';
  static const String place = 'place';
  static const String payedAmount = 'payedAmount';
}

Map<String, dynamic> _$OrderDtoToJson(OrderDto instance) => <String, dynamic>{
  'id': instance.id,
  'originCartId': instance.originCartId,
  'createdAt': const TimestampJsonConvert().toJson(instance.createdAt),
  'updatedAt': const TimestampJsonConvert().toJson(instance.updatedAt),
  'at': _$JsonConverterToJson<Timestamp, DateTime>(
    instance.at,
    const TimestampJsonConvert().toJson,
  ),
  'organizationId': instance.organizationId,
  'payerId': instance.payerId,
  'membersIds': instance.membersIds.toJson((value) => value),
  'shippable': instance.shippable,
  'status': _$OrderStatusEnumMap[instance.status]!,
  'place': instance.place,
  'payedAmount': instance.payedAmount.toJson(),
};

Value? _$JsonConverterFromJson<Json, Value>(Object? json, Value? Function(Json json) fromJson) =>
    json == null ? null : fromJson(json as Json);

const _$OrderStatusEnumMap = {
  OrderStatus.accepting: 'accepting',
  OrderStatus.notAccepted: 'notAccepted',
  OrderStatus.accepted: 'accepted',
  OrderStatus.processing: 'processing',
  OrderStatus.processed: 'processed',
  OrderStatus.shipping: 'shipping',
  OrderStatus.shipped: 'shipped',
  OrderStatus.delivering: 'delivering',
  OrderStatus.delivered: 'delivered',
};

Json? _$JsonConverterToJson<Json, Value>(Value? value, Json? Function(Value value) toJson) =>
    value == null ? null : toJson(value);

Map<String, dynamic> _$OrderUpdateDtoToJson(OrderUpdateDto instance) => <String, dynamic>{
  'updateAt': const TimestampJsonConvert().toJson(instance.updateAt),
  'status': _$OrderStatusEnumMap[instance.status]!,
};
