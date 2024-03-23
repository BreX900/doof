import 'package:mek_gasol/modules/eti/features/calendar_events/dto/calendar_event_dto.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/dvo/calendar_event_dvo.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/repositories/events_calendar_repo.dart';
import 'package:mek_gasol/modules/eti/features/clients/triggers/clients_trigger.dart';
import 'package:mek_gasol/modules/eti/features/projects/triggers/projects_trigger.dart';
import 'package:mek_gasol/shared/firestore.dart';
import 'package:pure_extensions/pure_extensions.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tuple/tuple.dart';

class EventsCalendarTrigger {
  static final instance = Provider((ref) {
    return EventsCalendarTrigger._(ref);
  });

  final Ref _ref;

  EventsCalendarRepo get _eventsRepo => _ref.watch(EventsCalendarRepo.instance);

  EventsCalendarTrigger._(this._ref);

  static final userMonth = FutureProvider.family((ref, DateTime moth) async {
    final signedUser = await ref.watch(Providers.user.future);
    final users = await ref.watch(Providers.users.future);
    final clients = await ref.watch(ClientsTrigger.all.future);
    final events = await ref.watch(EventsCalendarRepo.month(Tuple2(signedUser.id, moth)).future);

    final mappedEvents = await events.map((event) async {
      final cratedBy = users.firstWhere((user) => event.createdBy == user.id);

      return await event.map(onWork: (event) async {
        final client = clients.firstWhere((e) => event.clientId == e.id);
        final projects = await ref.watch(ProjectsTrigger.all(client.id).future);
        final project = projects.firstWhere((e) => event.projectId == e.id);

        return WorkEventCalendarDvo(
          id: event.id,
          createdBy: cratedBy,
          startAt: event.startAt,
          endAt: event.endAt,
          note: event.note,
          isPaid: event.isPaid,
          client: client,
          project: project,
        );
      }, onHoliday: (event) async {
        return HolidayEventCalendarDvo(
          id: event.id,
          createdBy: cratedBy,
          startAt: event.startAt,
          endAt: event.endAt,
          note: event.note,
          isPaid: event.isPaid,
        );
      }, onVacation: (event) async {
        return VacationEventCalendarDvo(
          id: event.id,
          createdBy: cratedBy,
          startAt: event.startAt,
          endAt: event.endAt,
          note: event.note,
          isPaid: event.isPaid,
        );
      });
    }).waitFutures();
    return mappedEvents.toList();
  });

  Future<void> save(EventCalendarDvo event) async {
    final eventDto = event.map(onWork: (event) {
      return WorkEventCalendarDto(
        id: event.id,
        createdBy: event.createdBy.id,
        startAt: event.startAt,
        endAt: event.endAt,
        note: event.note,
        isPaid: event.isPaid,
        clientId: event.client.id,
        projectId: event.project.id,
      );
    }, onHoliday: (event) {
      return HolidayEventCalendarDto(
        id: event.id,
        createdBy: event.createdBy.id,
        startAt: event.startAt,
        endAt: event.endAt,
        note: event.note,
        isPaid: event.isPaid,
      );
    }, onVacation: (event) {
      return VacationEventCalendarDto(
        id: event.id,
        createdBy: event.createdBy.id,
        startAt: event.startAt,
        endAt: event.endAt,
        note: event.note,
        isPaid: event.isPaid,
      );
    });

    if (event.id.isEmpty) {
      await _eventsRepo.create(eventDto);
    } else {
      await _eventsRepo.update(eventDto);
    }
  }
}
