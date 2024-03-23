import 'package:mek_gasol/modules/eti/features/calendar_rules/dto/calendar_rule_dto.dart';
import 'package:mek_gasol/modules/eti/features/calendar_rules/repositories/rules_calendar_repo.dart';
import 'package:riverpod/riverpod.dart';

class RulesCalendarTrigger {
  final Ref _ref;

  RulesCalendarTrigger._(this._ref);

  static final instance = Provider((ref) {
    return RulesCalendarTrigger._(ref);
  });

  static final all = FutureProvider((ref) async {
    return await ref.watch(RulesCalendarRepo.all);
  });

  Future<void> save(WorkRuleCalendarDto rule) async {
    if (rule.id.isEmpty) {
      await _ref.read(RulesCalendarRepo.instance).create(rule);
    } else {
      await _ref.read(RulesCalendarRepo.instance).update(rule);
    }
  }
}
