import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mek_gasol/features/sheet/invoices_utils.dart';
import 'package:mekart/mekart.dart';

class InvoicesVaultView extends StatelessWidget {
  final IList<UserDto> users;
  final IList<InvoiceDto> invoices;

  const InvoicesVaultView({
    super.key,
    required this.users,
    required this.invoices,
  });

  @override
  Widget build(BuildContext context) {
    final formats = AppFormats.of(context);

    final vault = InvoicesUtils.calculateVault(invoices, returnsZero: false);
    final vaultList = vault.entries.toIList();

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: ListTile(
            leading: const Icon(Icons.token),
            title: Text(formats.formatCaps(vault.values.sum)),
            subtitle: const Text('Available balance'),
          ),
        ),
        const SliverToBoxAdapter(
          child: Divider(),
        ),
        SliverList.builder(
          itemCount: vaultList.length,
          itemBuilder: (context, index) {
            final MapEntry(key: userId, value: amount) = vaultList[index];
            final user = users.firstWhere((e) => e.id == userId);
            return ListTile(
              leading: const Icon(Icons.catching_pokemon),
              title: Text(user.displayName!),
              trailing: Text(formats.formatCaps(amount)),
            );
          },
        ),
      ],
    );
  }
}
