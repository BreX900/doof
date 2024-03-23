import 'package:mek_gasol/features/firestore/repositories/firestore_repository.dart';
import 'package:mek_gasol/modules/eti/features/calendar_rules/dto/calendar_rule_dto.dart';
import 'package:riverpod/riverpod.dart';

class RulesCalendarRepo extends FirestoreRepository<WorkRuleCalendarDto> {
  RulesCalendarRepo._(Ref ref)
      : super(
          ref: ref,
          collectionName: 'calendar_rules',
          fromFirestore: WorkRuleCalendarDto.fromJson,
        );

  static final instance = Provider((ref) => RulesCalendarRepo._(ref));

  static final all = StreamProvider((ref) {
    return ref.watch(instance)._watchAll();
  });

  Stream<List<WorkRuleCalendarDto>> _watchAll() {
    return box.watchCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((e) => e.data()).toList();
    });
  }
}
