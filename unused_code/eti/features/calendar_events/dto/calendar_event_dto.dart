import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/clients/firebase/timestamp_json_converter.dart';
import 'package:mek_gasol/features/firestore/repositories/firestore_repository.dart';

part 'calendar_event_dto.g.dart';

enum EventCalendarDtoType { work, holiday, vacation }

abstract class EventCalendarDto with Dto {
  @override
  final String id;
  final EventCalendarDtoType type;
  final String createdBy;
  final DateTime startAt;
  final DateTime endAt;
  final String note;

  const EventCalendarDto({
    required this.id,
    required this.type,
    required this.createdBy,
    required this.startAt,
    required this.endAt,
    required this.note,
  });

  static const String startAtKey = 'startAt';
  static const String createdByKey = 'createdBy';

  factory EventCalendarDto.fromJson(Map<String, dynamic> map) {
    final type = $enumDecode(_$EventCalendarDtoTypeEnumMap, map['type']);
    final fromJson = _$EventCalendarDtoTypeMappings(type);
    return fromJson(map);
  }

  R map<R>({
    required R Function(WorkEventCalendarDto object) onWork,
    required R Function(HolidayEventCalendarDto object) onHoliday,
    required R Function(VacationEventCalendarDto object) onVacation,
  });
}

@DataClass()
@JsonSerializable()
@TimestampJsonConvert()
class WorkEventCalendarDto extends EventCalendarDto with _$WorkEventCalendarDto {
  /// Quando è già calcolato in bustapaga
  final bool isPaid;

  final String clientId;
  final String projectId;

  const WorkEventCalendarDto({
    required super.id,
    super.type = EventCalendarDtoType.work,
    required super.createdBy,
    required super.startAt,
    required super.endAt,
    required super.note,
    required this.isPaid,
    required this.clientId,
    required this.projectId,
  });

  factory WorkEventCalendarDto.fromJson(Map<String, dynamic> map) =>
      _$WorkEventCalendarDtoFromJson(map);
  Map<String, dynamic> toJson() => _$WorkEventCalendarDtoToJson(this);

  @override
  R map<R>({
    required R Function(WorkEventCalendarDto object) onWork,
    required R Function(HolidayEventCalendarDto object) onHoliday,
    required R Function(VacationEventCalendarDto object) onVacation,
  }) {
    return onWork(this);
  }
}

@DataClass()
@JsonSerializable()
@TimestampJsonConvert()
class HolidayEventCalendarDto extends EventCalendarDto with _$HolidayEventCalendarDto {
  /// Quando è già calcolato in bustapaga
  final bool isPaid;

  HolidayEventCalendarDto({
    required super.id,
    super.type = EventCalendarDtoType.holiday,
    required super.createdBy,
    required super.startAt,
    required super.endAt,
    required super.note,
    required this.isPaid,
  });

  factory HolidayEventCalendarDto.fromJson(Map<String, dynamic> map) =>
      _$HolidayEventCalendarDtoFromJson(map);
  Map<String, dynamic> toJson() => _$HolidayEventCalendarDtoToJson(this);

  @override
  R map<R>({
    required R Function(WorkEventCalendarDto object) onWork,
    required R Function(HolidayEventCalendarDto object) onHoliday,
    required R Function(VacationEventCalendarDto object) onVacation,
  }) {
    return onHoliday(this);
  }
}

@DataClass()
@JsonSerializable()
@TimestampJsonConvert()
class VacationEventCalendarDto extends EventCalendarDto with _$VacationEventCalendarDto {
  /// Quando è già calcolato in bustapaga
  final bool isPaid;

  VacationEventCalendarDto({
    required super.id,
    super.type = EventCalendarDtoType.vacation,
    required super.createdBy,
    required super.startAt,
    required super.endAt,
    required super.note,
    required this.isPaid,
  });

  factory VacationEventCalendarDto.fromJson(Map<String, dynamic> map) =>
      _$VacationEventCalendarDtoFromJson(map);
  Map<String, dynamic> toJson() => _$VacationEventCalendarDtoToJson(this);

  @override
  R map<R>({
    required R Function(WorkEventCalendarDto object) onWork,
    required R Function(HolidayEventCalendarDto object) onHoliday,
    required R Function(VacationEventCalendarDto object) onVacation,
  }) {
    return onVacation(this);
  }
}

EventCalendarDto Function(Map<String, dynamic> map) _$EventCalendarDtoTypeMappings(
    EventCalendarDtoType type) {
  switch (type) {
    case EventCalendarDtoType.work:
      return WorkEventCalendarDto.fromJson;
    case EventCalendarDtoType.holiday:
      return HolidayEventCalendarDto.fromJson;
    case EventCalendarDtoType.vacation:
      return VacationEventCalendarDto.fromJson;
  }
}
