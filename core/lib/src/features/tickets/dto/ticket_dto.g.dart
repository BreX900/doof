// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks, unused_field

part of 'ticket_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$TicketDto {
  TicketDto get _self => this as TicketDto;

  TicketDto change(void Function(TicketDtoChanges c) updates) =>
      (toChanges()..update(updates)).build();

  TicketDtoChanges toChanges() => TicketDtoChanges._(_self);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TicketDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.createAt == other.createAt &&
          _self.updatedAt == other.updatedAt &&
          _self.status == other.status &&
          _self.place == other.place;

  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.createAt.hashCode);
    hashCode = $hashCombine(hashCode, _self.updatedAt.hashCode);
    hashCode = $hashCombine(hashCode, _self.status.hashCode);
    hashCode = $hashCombine(hashCode, _self.place.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() =>
      (ClassToString('TicketDto')
            ..add('id', _self.id)
            ..add('createAt', _self.createAt)
            ..add('updatedAt', _self.updatedAt)
            ..add('status', _self.status)
            ..add('place', _self.place))
          .toString();
}

class TicketDtoChanges {
  TicketDtoChanges._(this._original);

  final TicketDto _original;

  late String id = _original.id;

  late DateTime createAt = _original.createAt;

  late DateTime updatedAt = _original.updatedAt;

  late TicketStatus status = _original.status;

  late String place = _original.place;

  void update(void Function(TicketDtoChanges c) updates) => updates(this);

  TicketDto build() {
    return TicketDto(
      id: id,
      createAt: createAt,
      updatedAt: updatedAt,
      status: status,
      place: place,
    );
  }
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TicketDto _$TicketDtoFromJson(Map<String, dynamic> json) => TicketDto(
  id: json['id'] as String,
  createAt: const TimestampJsonConvert().fromJson(
    json['createAt'] as Timestamp,
  ),
  updatedAt: const TimestampJsonConvert().fromJson(
    json['updatedAt'] as Timestamp,
  ),
  status: $enumDecode(_$TicketStatusEnumMap, json['status']),
  place: json['place'] as String,
);

abstract final class _$TicketDtoJsonKeys {
  static const String id = 'id';
  static const String createAt = 'createAt';
  static const String updatedAt = 'updatedAt';
  static const String status = 'status';
  static const String place = 'place';
}

Map<String, dynamic> _$TicketDtoToJson(TicketDto instance) => <String, dynamic>{
  'id': instance.id,
  'createAt': const TimestampJsonConvert().toJson(instance.createAt),
  'updatedAt': const TimestampJsonConvert().toJson(instance.updatedAt),
  'status': _$TicketStatusEnumMap[instance.status]!,
  'place': instance.place,
};

const _$TicketStatusEnumMap = {
  TicketStatus.pending: 'pending',
  TicketStatus.processing: 'processing',
  TicketStatus.resolved: 'resolved',
};
