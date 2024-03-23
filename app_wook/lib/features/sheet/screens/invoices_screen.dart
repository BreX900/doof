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
import 'package:pure_extensions/pure_extensions.dart';

final _stateProvider = FutureProvider.autoDispose((ref) async {
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

class InvoicesScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  InvoicesScreen({super.key});

  late final stateProvider = _stateProvider;

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  ConsumerState<InvoicesScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<InvoicesScreen> with AsyncConsumerState {
  Widget _buildBody({
    required IList<UserDto> users,
    required IList<InvoiceDto> invoices,
    required IList<LifeBar> lifeBars,
  }) {
    if (invoices.isEmpty) {
      return Consumer(builder: (context, ref, _) {
        return InfoTile(
          onTap: () => ref.read(UserArea.tab.notifier).state = UserAreaTab.carts,
          title: const Text('😰 Non hai ancora fatto nessun ordine! 😰\n🛒 Vai al carrello! 🛒'),
        );
      });
    }

    final formats = AppFormats.of(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return CustomScrollView(
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(16.0),
          sliver: SliverList.separated(
            itemCount: lifeBars.length,
            separatorBuilder: (context, index) => const SizedBox(height: 4.0),
            itemBuilder: (context, index) {
              final lifeBar = lifeBars[index];
              final user = lifeBar.user;
              final data = lifeBar.data;

              return Tooltip(
                triggerMode: TooltipTriggerMode.tap,
                waitDuration: const Duration(seconds: 1),
                message: '🐶 ${user.displayName} 🐶\n'
                    'Presence: ${data.presenceCount} (${data.pointsLostCount})\n'
                    'Jobs: ${data.jobsCount} (${data.pointsGainedCount})'
                    '${data.jobs.mapTo((job, count) {
                  return '\n    ${job.name}: $count (${data.points[job]})';
                }).join()}\n'
                    'Life: ${data.life.toStringAsFixed(2)} (${data.pointsCount})',
                child: Row(
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
                          LinearProgressIndicator(value: data.life),
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
                          switch (e) {
                            case Job.garbageMan:
                              return const Text('💩');
                            case Job.partner:
                              return const Text('👰🏼‍');
                            case Job.driver:
                              return const Text('🚑');
                          }
                        }),
                      ].joinElement(const SizedBox(width: 4.0)).toList(),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            childCount: invoices.length,
            (context, index) {
              final invoice = invoices[index];

              return ListTile(
                onTap: () => InvoiceRoute(invoice.id).go(context),
                title: Text(formats.formatDateTime(invoice.createdAt)),
                subtitle: Text('Total: ${formats.formatPrice(invoice.amount)}'),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(widget.stateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoices'),
      ),
      body: AsyncViewBuilder(
        state: orders,
        builder: (context, items) => _buildBody(
          invoices: items.invoices,
          users: items.users,
          lifeBars: items.hearts,
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
