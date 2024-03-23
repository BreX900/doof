import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/eti/features/calendar_rules/dto/calendar_rule_dto.dart';
import 'package:mek_gasol/modules/eti/features/calendar_rules/triggers/rules_calendar_trigger.dart';
import 'package:mek_gasol/shared/flutter_utils.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';

class CalendarRuleScreen extends StatefulWidget {
  const CalendarRuleScreen({Key? key}) : super(key: key);

  @override
  State<CalendarRuleScreen> createState() => _CalendarRuleScreenState();
}

class _CalendarRuleScreenState extends State<CalendarRuleScreen> {
  final startAtFB = FieldBloc<TimeOfDay?>(
    initialValue: null,
  );
  final endAtFB = FieldBloc<TimeOfDay?>(
    initialValue: null,
  );
  final weekDays = FieldBloc<List<WeekDay>>(
    initialValue: [],
    validator: const RequiredValidation(),
  );

  final _saveMb = MutationBloc();

  void _save() {
    _saveMb.handle(() async {
      await get<RulesCalendarTrigger>().save(WorkRuleCalendarDto(
        id: '',
        startAt: startAtFB.state.value!.toDuration(),
        endAt: endAtFB.state.value!.toDuration(),
        weekDays: weekDays.state.value,
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      bloc: _saveMb,
      listener: (context, state) => state.whenOrNull(success: (_) {
        context.hub.pop();
      }),
      child: _build(context),
    );
  }

  Widget _build(BuildContext context) {
    List<Widget> buildFields() {
      return [
        FieldTime(
          fieldBloc: startAtFB,
          decoration: const InputDecoration(
            labelText: 'Start At',
          ),
        ),
        FieldTime(
          fieldBloc: endAtFB,
          decoration: const InputDecoration(
            labelText: 'End At',
          ),
        ),
        FieldGroupBuilder<List<WeekDay>>(
          fieldBloc: weekDays,
          decoration: const InputDecoration(
            labelText: 'Week Days',
          ),
          valuesCount: WeekDay.values.length,
          valueBuilder: (state, index) {
            final value = WeekDay.values[index];

            return ChoiceChip(
              selected: state.value.contains(value),
              onSelected: state.widgetSelectHandler(weekDays, value),
              label: Text(value.name),
            );
          },
        ),
      ];
    }

    final floatingButton = ButtonBuilder(
      onPressed: _save,
      builder: (context, onPressed) {
        return AppFloatingActionButton(
          onPressed: onPressed,
          icon: const Icon(Icons.check),
          label: const Text('Save'),
          // child: const Icon(Icons.check),
        );
      },
    );

    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Add Event'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: buildFields(),
        ),
      ),
      floatingActionButton: floatingButton,
    );
  }
}
