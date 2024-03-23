import 'package:backoffice/shared/navigation/console_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

class AdminOrdersScreen extends ConsumerWidget {
  final String organizationId;

  const AdminOrdersScreen({
    super.key,
    required this.organizationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formats = AppFormats.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: AsyncTableConsumer(
        provider: OrdersProviders.page((organizationId,)),
        bodyBuilder: (context, ref, orders) {
          return MekTable(
            columns: const [
              MekColumn(label: Text('Id')),
              MekColumn(label: Text('Created At')),
              MekColumn(label: Text('Status')),
              MekColumn(label: Text('Place')),
              MekColumn(label: Text('Payer')),
            ],
            rows: orders.map((e) {
              return MekRow(
                onTap: () => AdminOrderRoute(organizationId, e.id).go(context),
                children: [
                  Text(e.id),
                  Text(formats.formatDate(e.createdAt)),
                  Text(e.status.translate(shippable: e.shippable)),
                  Text(e.place ?? ''),
                  Text(e.payer.displayName ?? ''),
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
