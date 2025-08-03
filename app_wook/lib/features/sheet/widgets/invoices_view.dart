import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mek_gasol/features/sheet/models/heart_model.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mekart/mekart.dart';

class InvoicesView extends StatelessWidget {
  final IList<InvoiceDto> invoices;
  final IList<LifeBar> lifeBars;

  const InvoicesView({
    super.key,
    required this.invoices,
    required this.lifeBars,
  });

  Widget _buildIcon(String userId, InvoiceDto invoice) {
    if (!(invoice.items[userId]?.isPayed ?? true)) {
      return const Icon(Icons.warning, color: Colors.yellow);
    }

    final payedAmount = invoice.payedAmount;
    final vaultOutcome = invoice.vaultOutcomes?.values.sum;

    if (payedAmount != null && vaultOutcome != null) {
      if (payedAmount != invoice.vaultOutcomes?.values.sum) {
        return const Icon(Icons.token, color: Colors.yellow);
      } else {
        return const Icon(Icons.token, color: Colors.green);
      }
    }

    if (!invoice.isPayed) return const Icon(Icons.check_circle, color: Colors.yellow);
    return const Icon(Icons.check_circle, color: Colors.green);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);
    final formats = AppFormats.of(context);

    final summaryLifeBars = lifeBars
        .sortedBy<num>((e) => e.data.presenceCount * -1)
        .take(5)
        .sortedBy<num>((e) => e.data.life * -1)
        .toIList();

    final userId = FirebaseAuth.instance.currentUser!.uid;
    final pendingInvoices = invoices.where((e) => !e.isPayed).toIList();
    final uncollectedInvoices = invoices.where((e) => e.payerId == userId && !e.isPayed).toIList();
    final unpaidInvoices = invoices.where((e) => !(e.items[userId]?.isPayed ?? true)).toIList();

    return DefaultTabController(
      length: 4,
      child: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList.separated(
              itemCount: summaryLifeBars.length,
              separatorBuilder: (context, index) => const SizedBox(height: 4.0),
              itemBuilder: (context, index) {
                final lifeBar = summaryLifeBars[index];
                final user = lifeBar.user;
                final data = lifeBar.data;

                // print('\'${user.id}\', // ${user.displayName} ');

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 128.0,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text('♥ ${formats.formatDouble(data.life)}',
                                  style: textTheme.labelSmall),
                              const Spacer(),
                              Text('🐶 ${formats.formatDouble(data.pointsCount)}',
                                  style: textTheme.labelSmall),
                            ],
                          ),
                          LinearProgressIndicator(
                            value: data.life,
                            backgroundColor: colorScheme.primary.withValues(alpha: 0.2),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Text(user.displayName!, overflow: TextOverflow.ellipsis),
                    const SizedBox(width: 8.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        if (lifeBar.hasManyPresences) const Text('🐶'),
                        if (lifeBar.hasMorePoints) const Text('👑'),
                        if (lifeBar.hasLessPoints) const Text('👻'),
                        ...lifeBar.kingJobs.map((e) {
                          return switch (e) {
                            Job.garbageMan => const Text('💩'),
                            Job.partner => const Text('👰🏼‍'),
                            Job.driver => const Text('🚑'),
                          };
                        }),
                      ].expandIndexed((index, child) sync* {
                        if (index > 0) yield const SizedBox(width: 4.0);
                        yield child;
                      }).toList(),
                    ),
                  ],
                );
              },
            ),
          ),
          SliverOverlapAbsorber(
            handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
            sliver: SliverPersistentSizeHeader.preferred(
              pinned: true,
              forceElevated: innerBoxIsScrolled,
              child: TabBar.secondary(
                tabs: [
                  const Tab(icon: Icon(Icons.clear_all)),
                  Tab(
                    child: Badge(
                      isLabelVisible: uncollectedInvoices.isNotEmpty,
                      label: Text('${uncollectedInvoices.length}'),
                      child: const Icon(Icons.search),
                    ),
                  ),
                  Tab(
                    child: Badge(
                      isLabelVisible: unpaidInvoices.isNotEmpty,
                      label: Text('${unpaidInvoices.length}'),
                      child: const Icon(Icons.attach_money),
                    ),
                  ),
                  Tab(
                    child: Badge(
                      isLabelVisible: pendingInvoices.isNotEmpty,
                      label: Text('${pendingInvoices.length}'),
                      child: const Icon(Icons.question_mark),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: TabBarView(
          children: [
            (const ParagraphTile(title: Text('All Invoices')), invoices),
            (const ParagraphTile(title: Text('Your Uncollected Invoices')), uncollectedInvoices),
            (const ParagraphTile(title: Text('Your Unpaid Invoices')), unpaidInvoices),
            (const ParagraphTile(title: Text('All Unresolved Invoices')), pendingInvoices)
          ].map((__) {
            final (title, invoices) = __;

            return CustomScrollView(
              slivers: [
                Builder(builder: (context) {
                  return SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  );
                }),
                SliverToBoxAdapter(
                  child: title,
                ),
                if (invoices.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: InfoView(title: Text('No results!')),
                  )
                else
                  SliverList.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      final InvoiceDto(:payedAmount, :vaultOutcomes) = invoice;

                      var text = 'Total: ${formats.formatPrice(invoice.amount)}';
                      if (payedAmount != null) {
                        if (vaultOutcomes != null) {
                          text += ' • Vault: -${vaultOutcomes.values.sum}';
                        } else {
                          text += ' • Vault: +${formats.formatCaps(invoice.amount - payedAmount)}';
                        }
                      }

                      return ListTile(
                        onTap: () => InvoiceRoute(invoice.id).go(context),
                        leading: _buildIcon(userId, invoice),
                        title: Text(formats.formatDateTime(invoice.createdAt)),
                        subtitle: Text(text),
                      );
                    },
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
