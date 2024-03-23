import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/features/firestore/repositories/firestore_repository.dart';

part 'calendar_rule_dto.g.dart';

enum RuleCalendarDtoType { work }

// TODO: Implement base rule dto class
// class RuleCalendarDto extends Dto {
//   const RuleCalendarDto();
// }

@DataClass()
@JsonSerializable()
class WorkRuleCalendarDto with Dto, _$WorkRuleCalendarDto {
  @override
  final String id;
  final RuleCalendarDtoType type;
  final Duration startAt;
  final Duration endAt;
  final List<WeekDay> weekDays;

  const WorkRuleCalendarDto({
    required this.id,
    this.type = RuleCalendarDtoType.work,
    required this.startAt,
    required this.endAt,
    required this.weekDays,
  });

  factory WorkRuleCalendarDto.fromJson(Map<String, dynamic> map) =>
      _$WorkRuleCalendarDtoFromJson(map);
  Map<String, dynamic> toJson() => _$WorkRuleCalendarDtoToJson(this);
}

enum WeekDay {
  monday(1),
  tuesday(2),
  wednesday(3),
  thursday(4),
  friday(5),
  saturday(6),
  sunday(7);

  final int number;

  const WeekDay(this.number);
}
