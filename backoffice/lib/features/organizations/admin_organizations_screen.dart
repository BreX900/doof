import 'package:backoffice/shared/navigation/console_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

class AdminOrganizationsScreen extends ConsumerWidget {
  final String? selectedOrganizationId;

  const AdminOrganizationsScreen({
    super.key,
    required this.selectedOrganizationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizations'),
      ),
      body: AsyncTableConsumer(
        provider: OrganizationsProviders.page,
        bodyBuilder: (context, ref, products) {
          return MekTable(
            columns: const [
              MekColumn(label: Text('Name')),
            ],
            rows: products.map((e) {
              return MekRow(
                onDoubleTap: () => AdminAreaRoute(e.id).pushReplacement(context),
                children: [
                  Text(e.name),
                ],
              );
            }).toList(),
          );
        },
        footer: MekTablePagination(
          cursorBloc: ref.watch(OrganizationsProviders.pageCursor.bloc),
        ),
      ),
    );
  }
}
