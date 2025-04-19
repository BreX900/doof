import 'package:backoffice/shared/navigation/console_routes.dart';
import 'package:backoffice/shared/widgets/icons_bar.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

class AdminTicketsScreen extends ConsumerStatefulWidget {
  final String organizationId;

  const AdminTicketsScreen({
    super.key,
    required this.organizationId,
  });

  @override
  ConsumerState<AdminTicketsScreen> createState() => _AdminTicketScreenState();
}

class _AdminTicketScreenState extends ConsumerState<AdminTicketsScreen> {
  late final _updateTicket =
      ref.mutation((ref, ({String ticketId, TicketStatus status}) args) async {
    await TicketsProviders.update(
      organizationId: widget.organizationId,
      ticketId: args.ticketId,
      status: args.status,
    );
  });

  @override
  Widget build(BuildContext context) {
    final idIdle = !ref.watchIsMutating([_updateTicket]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tickets'),
      ),
      body: AsyncTableConsumer(
        provider: TicketsProviders.page(widget.organizationId),
        bodyBuilder: (context, ref, orders) {
          return MekTable(
            columns: const [
              MekColumn(label: Text('Id')),
              MekColumn(label: Text('Status')),
              MekColumn(label: Text('Place')),
              MekColumn(label: SizedBox.shrink()),
            ],
            rows: orders.map((e) {
              return MekRow(
                onTap: () => AdminOrderRoute(widget.organizationId, e.id).go(context),
                children: [
                  Text(e.id),
                  Text(e.status.name),
                  Text(e.place),
                  IconsBar(
                    currentIndex: e.status.index,
                    onSelected: idIdle
                        ? (index) => _updateTicket((
                              ticketId: e.id,
                              status: TicketStatus.values[index],
                            ))
                        : null,
                    icons: const [
                      Icon(Icons.pending_actions),
                      Icon(Icons.work_outline_rounded),
                      Icon(Icons.check),
                    ],
                  ),
                ],
              );
            }).toList(),
          );
        },
        footer: MekTablePagination(
          cursorBloc: ref.watch(OrdersProviders.pageCursor.bloc),
        ),
      ),
    );
  }
}
