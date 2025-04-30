import 'package:collection/collection.dart';
import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mek_gasol/features/sheet/invoices_providers.dart';
import 'package:mek_gasol/features/sheet/models/heart_model.dart';
import 'package:mek_gasol/features/sheet/widgets/invoices_expenses_view.dart'
    deferred as invoices_expenses_view;
import 'package:mek_gasol/features/sheet/widgets/invoices_statistics_view.dart'
    deferred as invoices_statistics_view;
import 'package:mek_gasol/features/sheet/widgets/invoices_vault_view.dart';
import 'package:mek_gasol/features/sheet/widgets/invoices_view.dart' deferred as invoices_view;
import 'package:mek_gasol/shared/navigation/routes/app_routes.dart';
import 'package:mek_gasol/shared/widgets/riverpod_utils.dart';
import 'package:mekart/mekart.dart';

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
      return InfoView(
        onTap: () => const CartsRoute().go(context),
        title: const Text('😰 Non hai ancora fatto nessun ordine! 😰\n🛒 Vai al carrello! 🛒'),
      );
    }

    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      children: [
        DeferredLibraryBuilder(
          loader: invoices_view.loadLibrary,
          builder: (context) => invoices_view.InvoicesView(invoices: invoices, lifeBars: lifeBars),
        ),
        InvoicesVaultView(users: users, invoices: invoices),
        DeferredLibraryBuilder(
          loader: invoices_statistics_view.loadLibrary,
          builder: (context) => invoices_statistics_view.InvoicesStatisticsView(lifeBars: lifeBars),
        ),
        DeferredLibraryBuilder(
          loader: invoices_expenses_view.loadLibrary,
          builder: (context) => invoices_expenses_view.InvoiceExpensesView(
            users: users,
            invoices: invoices,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(_provider);

    return DefaultTabController(
      length: 4,
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
              Tab(icon: Icon(Icons.dashboard)),
              Tab(icon: Icon(Icons.token)),
              Tab(icon: Icon(Icons.pets)),
              Tab(icon: Icon(Icons.money_off)),
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
      }).unlockView,
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
