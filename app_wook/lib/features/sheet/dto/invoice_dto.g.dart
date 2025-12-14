// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: unused_field

part of 'invoice_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$InvoiceDto {
  InvoiceDto get _self => this as InvoiceDto;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.orderId == other.orderId &&
          _self.payerId == other.payerId &&
          _self.payedAmount == other.payedAmount &&
          _self.createdAt == other.createdAt &&
          _self.items == other.items &&
          _self.vaultOutcomes == other.vaultOutcomes;

  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.orderId.hashCode);
    hashCode = $hashCombine(hashCode, _self.payerId.hashCode);
    hashCode = $hashCombine(hashCode, _self.payedAmount.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdAt.hashCode);
    hashCode = $hashCombine(hashCode, _self.items.hashCode);
    hashCode = $hashCombine(hashCode, _self.vaultOutcomes.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() =>
      (ClassToString('InvoiceDto')
            ..add('id', _self.id)
            ..add('orderId', _self.orderId)
            ..add('payerId', _self.payerId)
            ..add('payedAmount', _self.payedAmount)
            ..add('createdAt', _self.createdAt)
            ..add('items', _self.items)
            ..add('vaultOutcomes', _self.vaultOutcomes))
          .toString();
}

mixin _$InvoiceItemDto {
  InvoiceItemDto get _self => this as InvoiceItemDto;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InvoiceItemDto &&
          runtimeType == other.runtimeType &&
          _self.isPayed == other.isPayed &&
          _self.amount == other.amount &&
          _self.jobs == other.jobs;

  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.isPayed.hashCode);
    hashCode = $hashCombine(hashCode, _self.amount.hashCode);
    hashCode = $hashCombine(hashCode, _self.jobs.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() =>
      (ClassToString('InvoiceItemDto')
            ..add('isPayed', _self.isPayed)
            ..add('amount', _self.amount)
            ..add('jobs', _self.jobs))
          .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceDto _$InvoiceDtoFromJson(Map<String, dynamic> json) => InvoiceDto(
  id: json['id'] as String,
  orderId: json['orderId'] as String?,
  payerId: json['payerId'] as String,
  payedAmount: json['payedAmount'] == null ? null : Fixed.fromJson(json['payedAmount'] as String),
  createdAt: const TimestampJsonConvert().fromJson(json['createdAt'] as Timestamp),
  items: IMap<String, InvoiceItemDto>.fromJson(
    json['items'] as Map<String, dynamic>,
    (value) => value as String,
    (value) => InvoiceItemDto.fromJson(value as Map<String, dynamic>),
  ),
  vaultOutcomes: json['vaultOutcomes'] == null
      ? null
      : IMap<String, Fixed>.fromJson(
          json['vaultOutcomes'] as Map<String, dynamic>,
          (value) => value as String,
          (value) => Fixed.fromJson(value as String),
        ),
);

abstract final class _$InvoiceDtoJsonKeys {
  static const String id = 'id';
  static const String orderId = 'orderId';
  static const String payerId = 'payerId';
  static const String payedAmount = 'payedAmount';
  static const String createdAt = 'createdAt';
  static const String items = 'items';
  static const String membersIds = 'membersIds';
  static const String vaultOutcomes = 'vaultOutcomes';
}

Map<String, dynamic> _$InvoiceDtoToJson(InvoiceDto instance) => <String, dynamic>{
  'id': instance.id,
  'orderId': instance.orderId,
  'payerId': instance.payerId,
  'payedAmount': instance.payedAmount?.toJson(),
  'createdAt': const TimestampJsonConvert().toJson(instance.createdAt),
  'items': instance.items.toJson((value) => value, (value) => value.toJson()),
  'membersIds': instance.membersIds,
  'vaultOutcomes': instance.vaultOutcomes?.toJson((value) => value, (value) => value.toJson()),
};

InvoiceItemDto _$InvoiceItemDtoFromJson(Map<String, dynamic> json) => InvoiceItemDto(
  isPayed: json['isPayed'] as bool,
  amount: Fixed.fromJson(json['amount'] as String),
  jobs: IList<Job>.fromJson(json['jobs'], (value) => $enumDecode(_$JobEnumMap, value)),
);

Map<String, dynamic> _$InvoiceItemDtoToJson(InvoiceItemDto instance) => <String, dynamic>{
  'isPayed': instance.isPayed,
  'amount': instance.amount.toJson(),
  'jobs': instance.jobs.toJson((value) => _$JobEnumMap[value]!),
};

const _$JobEnumMap = {Job.garbageMan: 'garbageMan', Job.partner: 'partner', Job.driver: 'driver'};
