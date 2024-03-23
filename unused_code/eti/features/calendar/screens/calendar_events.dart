import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek_gasol/modules/eti/features/calendar/screens/day_events.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/dvo/calendar_event_dvo.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/triggers/events_calendar_trigger.dart';
import 'package:mek_gasol/modules/eti/features/clients/screens/clients_screen.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/firestore.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/sign_out_icon_button.dart';
import 'package:pure_extensions/pure_extensions.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final month = DateTime.now().copyUpTo(month: true);

    Widget buildCalendar(List<EventCalendarDvo> events) {
      return TableCalendar(
        firstDay: DateTime.now().subtract(const Duration(days: 360)),
        focusedDay: DateTime.now(),
        lastDay: DateTime.now().add(const Duration(days: 360)),
        onDaySelected: (selectedDay, _) {
          context.hub.push(WorkEventsScreen(initialDay: selectedDay.toLocal().copyUpTo(day: true)));
        },
      );
    }

    Widget buildSummary(List<EventCalendarDvo> events) {
      final groupedEvents = events.groupListsBy((event) => event.createdBy);

      return DataTable(
        columns: const [
          DataColumn(label: Text('Workers')),
          DataColumn(label: Text('Hours')),
        ],
        rows: groupedEvents.generateIterable((user, events) {
          final hours = events.fold<Duration>(Duration.zero, (total, event) {
            return total + event.endAt.difference(event.startAt);
          });
          return DataRow(
            cells: [
              DataCell(Text(user.displayName)),
              DataCell(Text('${hours.hours}:${hours.minutes}')),
            ],
          );
        }).toList(),
      );
    }

    final eventsState = ref.watch(EventsCalendarTrigger.userMonth(month));

    return Scaffold(
      appBar: AppBar(
        leading: const SignOutIconButton(),
        title: const Text('Calendar'),
        actions: [
          IconButton(
            onPressed: () => context.hub.push(const ClientsScreen()),
            icon: const Icon(Icons.people_alt_outlined),
          ),
          IconButton(
            onPressed: () => ref.read(Providers.auth).signOut(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: eventsState.when(
        loading: () => const LoadingView(),
        error: (error, __) => ErrorView(error: error),
        data: (events) {
          return Column(
            children: [
              buildCalendar(events),
              buildSummary(events),
            ],
          );
        },
      ),
    );
  }
}
