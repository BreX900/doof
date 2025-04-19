import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mek_gasol/features/sheet/invoices_providers.dart';
import 'package:mek_gasol/features/sheet/models/heart_model.dart';
import 'package:mek_gasol/shared/navigation/areas/user_area.dart';
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:mekart/mekart.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

final _screenProvider = FutureProvider.autoDispose((ref) async {
  final results = await (
    ref.watch(InvoicesProviders.all.future),
    ref.watch(UsersProviders.all.future),
  ).wait;

  return (
    invoices: results.$1,
    users: results.$2,
    hearts: _calculate(results.$2, results.$1),
  );
});

class InvoicesScreen extends ConsumerStatefulWidget {
  const InvoicesScreen({super.key});

  @override
  ConsumerState<InvoicesScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<InvoicesScreen> {
  AutoDisposeFutureProvider<
          ({IList<LifeBar> hearts, IList<InvoiceDto> invoices, IList<UserDto> users})>
      get _provider => _screenProvider;

  Widget _buildBody({
    required IList<UserDto> users,
    required IList<InvoiceDto> invoices,
    required IList<LifeBar> lifeBars,
  }) {
    if (invoices.isEmpty) {
      return Consumer(builder: (context, ref, _) {
        return InfoView(
          onTap: () => ref.read(UserArea.tab.notifier).state = UserAreaTab.carts,
          title: const Text('😰 Non hai ancora fatto nessun ordine! 😰\n🛒 Vai al carrello! 🛒'),
        );
      });
    }
    final summaryLifeBars = lifeBars
        .sortedBy<num>((e) => e.data.presenceCount * -1)
        .take(5)
        .sortedBy<num>((e) => e.data.life * -1)
        .toIList();

    final formats = AppFormats.of(context);
    final ThemeData(:colorScheme, :textTheme) = Theme.of(context);

    final records = CustomScrollView(
      slivers: [
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
        SliverList.builder(
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final invoice = invoices[index];

            return ListTile(
              onTap: () => InvoiceRoute(invoice.id).go(context),
              title: Text(formats.formatDateTime(invoice.createdAt)),
              subtitle: Text('Total: ${formats.formatPrice(invoice.amount)}'),
            );
          },
        ),
      ],
    );
    final columns = [
      const Text('Username'),
      const Text('Life'),
      const Text('Presence'),
      ...Job.values.map((job) => Text(job.label)),
    ];
    final rows = lifeBars.map((lifeBar) {
      final life = lifeBar.data;
      return [
        Text('${lifeBar.user.displayName}'),
        Text(formats.formatPercent(lifeBar.data.life)),
        Text('${life.presenceCount}'),
        ...Job.values.map((job) {
          final count = life.jobs[job];
          return Text('${count ?? 0}');
        }),
      ];
    }).toList();
    final textStyle = DefaultTextStyle.of(context);
    final statistics = TableView.builder(
      diagonalDragBehavior: DiagonalDragBehavior.free,
      verticalDetails: const ScrollableDetails.vertical(
        physics: ClampingScrollPhysics(),
      ),
      horizontalDetails: const ScrollableDetails.horizontal(
        physics: ClampingScrollPhysics(),
      ),
      columnCount: columns.length,
      rowCount: rows.length,
      pinnedColumnCount: 1,
      pinnedRowCount: 1,
      columnBuilder: (index) => TableSpan(
        extent: index == 0 ? const FixedSpanExtent(128.0) : const FixedSpanExtent(64.0),
        padding: const SpanPadding.all(8.0),
        backgroundDecoration: SpanDecoration(
          border: SpanBorder(
            trailing: BorderSide(color: colorScheme.onSurface.withValues(alpha: 0.1)),
          ),
        ),
      ),
      rowBuilder: (index) => TableSpan(
        extent: const FixedSpanExtent(48.0),
        backgroundDecoration: SpanDecoration(
          color: index.isEven ? null : colorScheme.surfaceContainer,
        ),
      ),
      cellBuilder: (context, vicinity) {
        Widget child;
        if (vicinity.row == 0) {
          child = columns[vicinity.column];
        } else {
          child = rows[vicinity.row][vicinity.column];
        }
        return TableViewCell(
          child: Align(
            alignment: vicinity.column == 0 ? Alignment.centerLeft : Alignment.center,
            child: DefaultTextStyle(
              style: textStyle.style,
              textAlign: TextAlign.center,
              child: child,
            ),
          ),
        );
      },
    );
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [records, statistics],
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(_provider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Invoices'),
          actions: [
            IconButton(
              onPressed: () => const InvoiceCreateRoute().go(context),
              icon: const Icon(Icons.add),
            )
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Records'),
              Tab(text: 'Statistics'),
            ],
          ),
        ),
        body: orders.buildView(
          onRefresh: () => ref.invalidateWithAncestors(_provider),
          data: (items) => _buildBody(
            invoices: items.invoices,
            users: items.users,
            lifeBars: items.hearts,
          ),
        ),
      ),
    );
  }
}

IList<LifeBar> _calculate(IList<UserDto> users, IList<InvoiceDto> invoices) {
  final usersData = invoices.fold(<String, Life>{}, (points, invoice) {
    return {
      ...points,
      ...invoice.items.map((userId, item) {
        final data = points[userId];

        return MapEntry(
          userId,
          Life(
            presenceCount: (data?.presenceCount ?? 0) + 1,
            jobs: IMap({
              ...?data?.jobs.unlock,
              for (final job in item.jobs) job: (data?.jobs[job] ?? 0) + 1,
            }),
          ),
        );
      }),
    };
  }).toIMap();

  final presencesPodium = usersData.entries
      .sortedBy<num>((e) => e.value.presenceCount)
      .splitBetween((prev, next) => prev.value.presenceCount != next.value.presenceCount)
      .toList();
  final presencesKings = presencesPodium.lastOrNull?.map((e) => e.key).toList() ?? [];

  final jobsKings = Job.values.map((job) {
    final graduates = usersData.entries.sortedBy<num>((entry) => entry.value.jobs[job] ?? 0);
    final podium = graduates.splitBetween((prev, next) {
      return (prev.value.jobs[job] ?? 0) != (next.value.jobs[job] ?? '');
    });
    return MapEntry(job, podium.lastOrNull?.map((e) => e.key).toList() ?? []);
  }).toMap();

  final pointsPodium = usersData.entries
      .sortedBy<num>((e) => e.value.life)
      .splitBetween((prev, next) => prev.value.life != next.value.life)
      .toList();

  final morePointsUsers = pointsPodium.lastOrNull?.map((e) => e.key).toList() ?? [];
  final lessPointsUsers = pointsPodium.firstOrNull?.map((e) => e.key).toList() ?? [];
  final maxLife = pointsPodium.lastOrNull?.firstOrNull?.value.life ?? 1.0;
  final minLife = pointsPodium.firstOrNull?.firstOrNull?.value.life ?? 0.0;
  final lifeBar = maxLife - minLife;

  // print('heartsCount: $heartsCount, life: ($minLife, $maxLife, $lifeBar), $points');

  return usersData.mapTo((userId, data) {
    final life = (data.life - minLife) / lifeBar;
    final fullHearts = _calculateHearts(LifeBar.hearts, life);
    final missingHearts = _calculateHearts(LifeBar.hearts, 1 - life);
    // print('${data.life}, life: $life, hearts: ($fullHearts, $brokenHearts, $missingHearts)');
    // '${'❤️' * fullHearts}${'💔' * brokenHearts}${'🤍' * missingHearts}'

    final user = users.firstWhere((e) => e.id == userId);
    return LifeBar(
      user,
      data,
      fullHearts,
      missingHearts,
      hasManyPresences: presencesKings.contains(userId),
      kingJobs:
          jobsKings.entries.where((e) => e.value.contains(userId)).map((e) => e.key).toIList(),
      hasMorePoints: morePointsUsers.contains(userId),
      hasLessPoints: lessPointsUsers.contains(userId),
    );
  }).sortedBy<num>((e) {
    return e.data.life * -1;
  }).toIList();
}

/// Examples: [division], [value] -> result
/// 5, 0.23 -> 1
/// 5, 0.33 -> 1
/// 5, 0.36 -> 2
int _calculateHearts(int division, double value) {
  final vl2 = (value * (division * 2)).round();
  return (vl2 / 2).truncate();
}
