// GENERATED CODE - DO NOT MODIFY BY HAND

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
          _self.createdAt == other.createdAt &&
          $listEquality.equals(_self.membersIds, other.membersIds) &&
          $mapEquality.equals(_self.items, other.items);
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.orderId.hashCode);
    hashCode = $hashCombine(hashCode, _self.payerId.hashCode);
    hashCode = $hashCombine(hashCode, _self.createdAt.hashCode);
    hashCode = $hashCombine(hashCode, $listEquality.hash(_self.membersIds));
    hashCode = $hashCombine(hashCode, $mapEquality.hash(_self.items));
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('InvoiceDto')
        ..add('id', _self.id)
        ..add('orderId', _self.orderId)
        ..add('payerId', _self.payerId)
        ..add('createdAt', _self.createdAt)
        ..add('membersIds', _self.membersIds)
        ..add('items', _self.items))
      .toString();
}

class _InvoiceDtoFields {
  // ignore: unused_element
  const _InvoiceDtoFields([this._path = '']);

  final String _path;

  String get id => '${_path}id';

  String get orderId => '${_path}orderId';

  String get payerId => '${_path}payerId';

  String get createdAt => '${_path}createdAt';

  String get membersIds => '${_path}membersIds';

  String get items => '${_path}items';

  @override
  String toString() => _path.isEmpty ? '_InvoiceDtoFields()' : _path;
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
          $listEquality.equals(_self.jobs, other.jobs);
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.isPayed.hashCode);
    hashCode = $hashCombine(hashCode, _self.amount.hashCode);
    hashCode = $hashCombine(hashCode, $listEquality.hash(_self.jobs));
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('InvoiceItemDto')
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
      orderId: json['orderId'] as String,
      payerId: json['payerId'] as String,
      createdAt:
          const TimestampJsonConvert().fromJson(json['createdAt'] as Timestamp),
      membersIds: (json['membersIds'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      items: (json['items'] as Map<String, dynamic>).map(
        (k, e) =>
            MapEntry(k, InvoiceItemDto.fromJson(e as Map<String, dynamic>)),
      ),
    );

Map<String, dynamic> _$InvoiceDtoToJson(InvoiceDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'orderId': instance.orderId,
      'payerId': instance.payerId,
      'createdAt': const TimestampJsonConvert().toJson(instance.createdAt),
      'membersIds': instance.membersIds,
      'items': instance.items.map((k, e) => MapEntry(k, e.toJson())),
    };

InvoiceItemDto _$InvoiceItemDtoFromJson(Map<String, dynamic> json) =>
    InvoiceItemDto(
      isPayed: json['isPayed'] as bool,
      amount: Decimal.fromJson(json['amount'] as String),
      jobs: (json['jobs'] as List<dynamic>)
          .map((e) => $enumDecode(_$JobEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$InvoiceItemDtoToJson(InvoiceItemDto instance) =>
    <String, dynamic>{
      'isPayed': instance.isPayed,
      'amount': instance.amount.toJson(),
      'jobs': instance.jobs.map((e) => _$JobEnumMap[e]!).toList(),
    };

const _$JobEnumMap = {
  Job.garbageMan: 'garbageMan',
  Job.partner: 'partner',
  Job.driver: 'driver',
};
