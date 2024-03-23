import 'package:backoffice/shared/navigation/console_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

class AdminIngredientsScreen extends ConsumerWidget {
  final String organizationId;

  const AdminIngredientsScreen({
    super.key,
    required this.organizationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formats = AppFormats.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredients'),
        actions: [
          IconButton(
            onPressed: () => AdminIngredientCreateRoute(organizationId).go(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: AsyncTableConsumer(
        provider: IngredientsProviders.page(organizationId),
        bodyBuilder: (context, ref, products) {
          return MekTable(
            columns: const [
              MekColumn(label: Text('Title')),
              MekColumn(label: Text('Description')),
              MekColumn(label: Text('Price')),
            ],
            rows: products.map((e) {
              return MekRow(
                onTap: () => AdminIngredientRoute(organizationId, e.id).go(context),
                children: [
                  Text(e.title),
                  Text(e.description),
                  Text(formats.formatPrice(e.price)),
                ],
              );
            }).toList(),
          );
        },
        footer: MekTablePagination(
          cursorBloc: ref.watch(IngredientsProviders.pageCursor.bloc),
        ),
      ),
    );
  }
}
