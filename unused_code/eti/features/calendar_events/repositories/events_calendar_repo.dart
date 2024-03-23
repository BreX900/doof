import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mek_gasol/features/firestore/repositories/firestore_repository.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/dto/calendar_event_dto.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/firestore.dart';
import 'package:riverpod/riverpod.dart';
import 'package:tuple/tuple.dart';

class EventsCalendarRepo extends FirestoreRepository<EventCalendarDto> {
  EventsCalendarRepo._(Ref ref)
      : super(
          ref: ref,
          collectionName: 'events_calendar',
          fromFirestore: EventCalendarDto.fromJson,
        );

  static final instance = Provider((ref) {
    return EventsCalendarRepo._(ref);
  });

  static final month = StreamProvider.family((ref, Tuple2<String, DateTime> args) {
    return ref.watch(instance)._watchMonth(args);
  });

  Stream<List<EventCalendarDto>> _watchMonth(Tuple2<String, DateTime> args) {
    final userId = args.item1;
    final month = args.item2;

    final nextMonth = DateTimeUtils.darwinAdd(month, 1);

    var query = box.watchCollection.asQuery();

    query = query.orderBy(EventCalendarDto.startAtKey);
    query = query.startAt([Timestamp.fromDate(month)]).endAt([Timestamp.fromDate(nextMonth)]);
    query = query.where(EventCalendarDto.createdByKey, isEqualTo: userId);

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });
  }
}
