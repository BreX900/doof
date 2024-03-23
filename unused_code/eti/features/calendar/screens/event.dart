import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/users/dto/user_dto.dart';
import 'package:mek_gasol/modules/doof/shared/service_locator/service_locator.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/dvo/calendar_event_dvo.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/triggers/events_calendar_trigger.dart';
import 'package:mek_gasol/modules/eti/features/clients/dvo/client_dvo.dart';
import 'package:mek_gasol/modules/eti/features/clients/triggers/clients_trigger.dart';
import 'package:mek_gasol/modules/eti/features/projects/dvo/project_dvo.dart';
import 'package:mek_gasol/modules/eti/features/projects/repositories/projects_repo.dart';
import 'package:mek_gasol/modules/eti/features/projects/triggers/projects_trigger.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/flutter_utils.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/firestore.dart';
import 'package:mek_gasol/shared/riverpod_extensions.dart';
import 'package:mek_gasol/shared/widgets/app_floating_action_button.dart';
import 'package:pure_extensions/pure_extensions.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class _EventFormBloc extends MapFieldBloc<String, dynamic> {
  ProviderSubscription? _projectsSub;

  final EventCalendarType type;

  final startAtFB = FieldBloc<TimeOfDay?>(
    initialValue: null,
  );
  final endAtFB = FieldBloc<TimeOfDay?>(
    initialValue: null,
  );
  final noteFB = FieldBloc(
    initialValue: '',
  );

  /// Fields for [EventCalendarType.work]

  final clientFB = FieldBloc<ClientDvo?>(
    initialValue: null,
    validator: const RequiredValidation(),
  );
  final projectFB = FieldBloc<ProjectDvo?>(
    initialValue: null,
    validator: const RequiredValidation(),
  );

  _EventFormBloc({
    required this.type,
    required DateTime day,
  }) {
    startAtFB.updateInitialValue(TimeOfDay.fromDateTime(day.copyWith(hour: 9)));
    endAtFB.updateInitialValue(TimeOfDay.fromDateTime(day.copyWith(hour: 9 + 4)));

    addFieldBlocs({
      'startAt': startAtFB,
      'endAt': endAtFB,
      'note': noteFB,
    });

    switch (type) {
      case EventCalendarType.work:
        clientFB.hotStream.distinct((prev, curr) => prev.value == curr.value).switchMap((state) async* {
          final client = state.value;
          if (client == null) return;

          yield* get<ProjectsRepo>().watchAll(client.id);
          _projectsSub?.close();
          _projectsSub = ref.listenFuture<List<ProjectDvo>>(ProjectsTrigger.all(client.id).future,
              fireImmediately: true, (previous, next) {
            projectFB.updateItems(next);
          });
        });

        ref.listenFuture<List<ClientDvo>>(ClientsTrigger.all.future, (previous, next) {
          clientFB.updateItems(next);
        }, fireImmediately: true);

        addFieldBlocs({
          'client': clientFB,
          'project': projectFB,
        });
        break;
      case EventCalendarType.holiday:
      case EventCalendarType.vacation:
        break;
    }
  }
}

enum EventCalendarType { work, holiday, vacation }

class WorkEventScreen extends StatefulWidget {
  final EventCalendarType type;
  final DateTime day;

  const WorkEventScreen({
    Key? key,
    required this.type,
    required this.day,
  }) : super(key: key);

  @override
  State<WorkEventScreen> createState() => _WorkEventScreenState();
}

class _WorkEventScreenState extends State<WorkEventScreen> {
  Tuple2<EventCalendarType, DateTime> get args => Tuple2(widget.type, widget.day);

  final _projectsQb = QueryBloc(() => get<ProjectsRepo>().watchAll())

  final _saveMb = MutationBloc();

  final _form = _EventFormBloc();

  @override
  void initState() {
    super.initState();
    _form.clientFB.hotStream.distinct((prev, curr) => prev.value == curr.value).listen((state) {
      final client = state.value;
      if (client == null) return;
      _projectsSub?.close();
      _projectsSub = ref.listenFuture<List<ProjectDvo>>(ProjectsTrigger.all(client.id).future,
          fireImmediately: true, (previous, next) {
            projectFB.updateItems(next);
          });
    });
  }

  void save() {
    _saveMb.handle(() async {
      final day = args.item2;

      final user = get<UserDto>();

      EventCalendarDvo event;
      switch (args.item1) {
        case EventCalendarType.work:
          event = WorkEventCalendarDvo(
            id: '',
            createdBy: user,
            startAt: formBloc.startAtFB.value!.toDateTime(day),
            endAt: formBloc.endAtFB.value!.toDateTime(day),
            note: formBloc.noteFB.value,
            client: formBloc.clientFB.value!,
            project: formBloc.projectFB.value!,
            isPaid: false,
          );
          break;
        case EventCalendarType.holiday:
          event = HolidayEventCalendarDvo(
            id: '',
            createdBy: user,
            startAt: formBloc.startAtFB.value!.toDateTime(day),
            endAt: formBloc.endAtFB.value!.toDateTime(day),
            note: formBloc.noteFB.value,
            isPaid: false,
          );
          break;
        case EventCalendarType.vacation:
          event = VacationEventCalendarDvo(
            id: '',
            createdBy: user,
            startAt: formBloc.startAtFB.value!.toDateTime(day),
            endAt: formBloc.endAtFB.value!.toDateTime(day),
            note: formBloc.noteFB.value,
            isPaid: false,
          );
          break;
      }

      await get<EventsCalendarTrigger>().save(event);
    });
  }

  @override
  Widget build(BuildContext context) {
    final formBloc = ref.watch(_form(args).bloc);

    ref.listen<MutationState>(_save(args), (previous, next) {
      next.whenOrNull(success: (_) {
        context.hub.pop();
      });
    });

    List<Widget> buildFields() {
      return [
        FieldTime(
          fieldBloc: formBloc.startAtFB,
          initialTime: TimeOfDay.fromDateTime(widget.day),
          decoration: const InputDecoration(
            labelText: 'Start At',
          ),
        ),
        FieldTime(
          fieldBloc: formBloc.endAtFB,
          initialTime: TimeOfDay.fromDateTime(widget.day),
          decoration: const InputDecoration(
            labelText: 'End At',
          ),
        ),
        FieldTime(
          fieldBloc: formBloc.noteFB,
          decoration: const InputDecoration(
            labelText: 'Note',
          ),
        ),
        FieldDropdown<ClientDvo>(
          fieldBloc: formBloc.clientFB,
          decoration: const InputDecoration(
            labelText: 'Client',
          ),
          itemBuilder: (context, value) => FieldItem(child: Text(value.displayName)),
        ),
        FieldDropdown<ProjectDvo>(
          fieldBloc: formBloc.projectFB,
          decoration: const InputDecoration(
            labelText: 'Project',
          ),
          itemBuilder: (context, value) => FieldItem(child: Text(value.name)),
        ),
      ];
    }

    final buttonBar = ButtonBuilder(
      onPressed: save,
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
        title: const Text('Add Event'),
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: Column(
          children: buildFields(),
        ),
      ),
      floatingActionButton: buttonBar,
    );
  }
}
