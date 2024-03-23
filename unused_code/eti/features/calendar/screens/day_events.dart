import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mek_gasol/modules/eti/features/calendar/screens/event.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/dvo/calendar_event_dvo.dart';
import 'package:mek_gasol/modules/eti/features/calendar_events/triggers/events_calendar_trigger.dart';
import 'package:mek_gasol/shared/dart_utils.dart';
import 'package:mek_gasol/shared/data/mek_widgets.dart';
import 'package:mek_gasol/shared/hub.dart';
import 'package:mek_gasol/shared/widgets/bar_calendar.dart';

final _dayFilter = StateProvider.family((ref, DateTime initialDay) {
  return initialDay;
});

final _events = FutureProvider.family((ref, DateTime day) async {
  final events = await ref.watch(EventsCalendarTrigger.userMonth(day.copyUpTo(month: true)).future);

  return events.where((event) {
    return event.startAt.isBetween(day, day.add(const Duration(days: 1)));
  }).toList();
});

class WorkEventsScreen extends ConsumerWidget {
  final DateTime initialDay;

  const WorkEventsScreen({
    Key? key,
    required this.initialDay,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dayProvider = _dayFilter(initialDay);

    final day = ref.watch(dayProvider);
    final eventsState = ref.watch(_events(day));

    final languageTag = Localizations.localeOf(context).toLanguageTag();
    final titleDateTimeFormat = DateFormat(null, languageTag).addPattern('EEEE').add_yMd();
    final cellDateTimeFormat = DateFormat(null, languageTag).add_Hm();

    Widget buildCells(List<EventCalendarDvo> events) {
      if (events.isEmpty) {
        return const Center(
          child: Text('Tap add icon to create new event!'),
        );
      }

      return ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];

          return ListTile(
            title: Text(event.note),
            subtitle: Text(
                '${cellDateTimeFormat.format(event.startAt)} - ${cellDateTimeFormat.format(event.endAt)}\n${event.id}'),
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(titleDateTimeFormat.format(day)),
        actions: [
          SheetMenuButton(
            itemsBuilder: (context) {
              return EventCalendarType.values.map((e) {
                return PopupMenuItem<Never>(
                  onTap: () => context.hub.push(WorkEventScreen(
                    type: e,
                    day: day,
                  )),
                  child: Text(e.name),
                );
              }).toList();
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            BarCalendar(
              firstDate: DateTime.now().subtract(const Duration(days: 100)),
              initialDate: day,
              lastDate: DateTime.now().add(const Duration(days: 100)),
              onDateChanged: (date) => ref.read(dayProvider.notifier).state = date,
            ),
            Expanded(
              child: eventsState.when(
                loading: () => const LoadingView(),
                error: (error, __) => ErrorView(error: error),
                data: (events) => buildCells(events),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SheetMenuButton extends StatelessWidget {
  final List<PopupMenuEntry<Never>> Function(BuildContext context) itemsBuilder;
  final Widget? icon;

  const SheetMenuButton({
    Key? key,
    required this.itemsBuilder,
    this.icon,
  }) : super(key: key);

  Widget _buildSheet(BuildContext context) {
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: itemsBuilder(context),
      ),
    );
  }

  static const _isMobile = true;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (_isMobile) {
          const offset = Offset.zero;
          final button = context.findRenderObject()! as RenderBox;
          final overlay = Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;

          final position = RelativeRect.fromRect(
            Rect.fromPoints(
              button.localToGlobal(offset, ancestor: overlay),
              button.localToGlobal(button.size.bottomRight(Offset.zero) + offset,
                  ancestor: overlay),
            ),
            Offset.zero & overlay.size,
          );
          showMenu(
            context: context,
            position: position,
            items: itemsBuilder(context).map((entry) {
              if (entry is PopupMenuItem<Never>) {
                final onTap = entry.onTap;
                return PopupMenuItem<Never>(
                  onTap: onTap != null
                      ? () => WidgetsBinding.instance.addPostFrameCallback((_) => onTap())
                      : onTap,
                  child: entry.child,
                );
              }
              return entry;
            }).toList(),
          );
        } else {
          // TODO: Enable it on mobile platform
          showModalBottomSheet(
            context: context,
            builder: _buildSheet,
          );
        }
      },
      icon: icon ?? const Icon(Icons.more_vert),
    );
  }
}
