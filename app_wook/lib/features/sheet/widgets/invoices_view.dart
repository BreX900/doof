import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mek_gasol/features/sheet/models/heart_model.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';

class InvoicesView extends StatelessWidget {
  final IList<InvoiceDto> invoices;
  final IList<LifeBar> lifeBars;

  const InvoicesView({
    super.key,
    required this.invoices,
    required this.lifeBars,
  });

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
    final uncollectedInvoices = invoices.where((e) => e.payerId == userId && !e.isPayed).toIList();
    final unpaidInvoices = invoices.where((e) => !(e.items[userId]?.isPayed ?? true)).toIList();

    return DefaultTabController(
      length: 3,
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
                  const Tab(text: 'All'),
                  Tab(
                    child: Badge(
                      isLabelVisible: uncollectedInvoices.isNotEmpty,
                      offset: const Offset(16.0, -8.0),
                      label: Text('${uncollectedInvoices.length}'),
                      child: const Text('Uncollected'),
                    ),
                  ),
                  Tab(
                    child: Badge(
                      isLabelVisible: unpaidInvoices.isNotEmpty,
                      offset: const Offset(16.0, -8.0),
                      label: Text('${unpaidInvoices.length}'),
                      child: const Text('Unpaid'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
        body: Builder(builder: (context) {
          return TabBarView(
            children: [invoices, uncollectedInvoices, unpaidInvoices].map((invoices) {
              if (invoices.isEmpty) return const InfoView(title: Text('No results!'));

              return CustomScrollView(
                slivers: [
                  SliverOverlapInjector(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  ),
                  SliverList.builder(
                    itemCount: invoices.length,
                    itemBuilder: (context, index) {
                      final invoice = invoices[index];
                      final isPayed = invoice.isPayed;

                      return ListTile(
                        onTap: () => InvoiceRoute(invoice.id).go(context),
                        leading: isPayed
                            ? const Icon(Icons.check_circle, color: Colors.green)
                            : const Icon(Icons.warning, color: Colors.yellow),
                        title: Text(formats.formatDateTime(invoice.createdAt)),
                        subtitle: Text('Total: ${formats.formatPrice(invoice.amount)}'),
                      );
                    },
                  ),
                ],
              );
            }).toList(),
          );
        }),
      ),
    );
  }
}
