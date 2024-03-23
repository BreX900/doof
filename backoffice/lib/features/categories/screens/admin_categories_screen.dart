import 'package:backoffice/shared/navigation/console_routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

class AdminCategoriesScreen extends ConsumerWidget {
  final String organizationId;

  const AdminCategoriesScreen({
    super.key,
    required this.organizationId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        // leading: const SignOutIconButton(),
        title: const Text('Categories'),
        actions: [
          IconButton(
            onPressed: () => AdminCategoryCreateRoute(organizationId).go(context),
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: AsyncTableConsumer(
        provider: CategoriesProviders.page(organizationId),
        bodyBuilder: (context, ref, categories) {
          return MekTable(
            columns: const [
              MekColumn(label: Text('Title')),
              MekColumn(label: Text('Weight')),
            ],
            rows: categories.map((e) {
              return MekRow(
                onTap: () => AdminCategoryRoute(organizationId, e.id).go(context),
                children: [
                  Text(e.title),
                  Text('${e.weight}'),
                ],
              );
            }).toList(),
          );
        },
        footer: MekTablePagination(
          cursorBloc: ref.watch(CategoriesProviders.pageCursor.bloc),
        ),
      ),
    );
  }
}
