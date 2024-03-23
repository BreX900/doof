import 'package:mek_data_class/mek_data_class.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';

part 'calendar_event_dvo.g.dart';

abstract class EventCalendarDvo {
  final String id;
  final PublicUserDto createdBy;
  final DateTime startAt;
  final DateTime endAt;
  final String note;

  const EventCalendarDvo({
    required this.id,
    required this.createdBy,
    required this.startAt,
    required this.endAt,
    required this.note,
  });

  R map<R>({
    required R Function(WorkEventCalendarDvo object) onWork,
    required R Function(HolidayEventCalendarDvo object) onHoliday,
    required R Function(VacationEventCalendarDvo object) onVacation,
  });
}

@DataClass()
class WorkEventCalendarDvo extends EventCalendarDvo with _$WorkEventCalendarDvo {
  /// Quando è già calcolato in bustapaga
  final bool isPaid;

  final ClientDvo client;
  final ProjectDvo project;

  const WorkEventCalendarDvo({
    required super.id,
    required super.createdBy,
    required super.startAt,
    required super.endAt,
    required super.note,
    required this.isPaid,
    required this.client,
    required this.project,
  });

  @override
  R map<R>({
    required R Function(WorkEventCalendarDvo object) onWork,
    required R Function(HolidayEventCalendarDvo object) onHoliday,
    required R Function(VacationEventCalendarDvo object) onVacation,
  }) {
    return onWork(this);
  }
}

@DataClass()
class HolidayEventCalendarDvo extends EventCalendarDvo with _$HolidayEventCalendarDvo {
  /// Quando è già calcolato in bustapaga
  final bool isPaid;

  HolidayEventCalendarDvo({
    required super.id,
    required super.createdBy,
    required super.startAt,
    required super.endAt,
    required super.note,
    required this.isPaid,
  });

  @override
  R map<R>({
    required R Function(WorkEventCalendarDvo object) onWork,
    required R Function(HolidayEventCalendarDvo object) onHoliday,
    required R Function(VacationEventCalendarDvo object) onVacation,
  }) {
    return onHoliday(this);
  }
}

@DataClass()
class VacationEventCalendarDvo extends EventCalendarDvo with _$VacationEventCalendarDvo {
  /// Quando è già calcolato in bustapaga
  final bool isPaid;

  VacationEventCalendarDvo({
    required super.id,
    required super.createdBy,
    required super.startAt,
    required super.endAt,
    required super.note,
    required this.isPaid,
  });

  @override
  R map<R>({
    required R Function(WorkEventCalendarDvo object) onWork,
    required R Function(HolidayEventCalendarDvo object) onHoliday,
    required R Function(VacationEventCalendarDvo object) onVacation,
  }) {
    return onVacation(this);
  }
}
