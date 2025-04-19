import 'package:app_button/apis/flutter_svg/svg_icon.dart';
import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

final _stateProvider = FutureProvider.family((ref, String organizationId) async {
  final organization = await ref.watch(OrganizationsProviders.single(organizationId).future);

  return (organization: organization);
});

class ServicesScreen extends ConsumerWidget {
  final String organizationId;

  ServicesScreen({
    super.key,
    required this.organizationId,
  });

  late final stateProvider = _stateProvider(organizationId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(stateProvider);
    final data = state.valueOrNull;

    final services = [
      const SizedBox(height: 128.0),
      _ServiceCard(
        onTap: () => TicketCreateRoute(organizationId).go(context),
        leading: const SvgIcon.asset(R.svgsTableService),
        title: const Text('Richiedi servizio al tavolo'),
        subtitle: const Text('Servizio'),
        description: const Text('Hai sete? Fame? Inviavi una richiesta e arriviamo!'),
      ),
      const Spacer(),
      _ServiceCard(
        onTap: () => ProductsRoute(organizationId).go(context),
        leading: const SvgIcon.asset(R.svgsMenu),
        title: const Text('Vedi il menu'),
        subtitle: const Text('Menu'),
        description: const Text('Sfoglia il nostro intero menu!'),
      ),
      const Spacer(flex: 8),
    ];

    return Scaffold(
      appBar: AppBar(
        title: DotsText.or(data?.organization.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: services,
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final VoidCallback onTap;
  final Widget leading;
  final Widget title;
  final Widget subtitle;
  final Widget description;

  const _ServiceCard({
    required this.onTap,
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;

    return Card(
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 96.0,
                    minWidth: 64.0,
                  ),
                  child: Center(
                    child: IconTheme.merge(
                      data: const IconThemeData(size: 40.0),
                      child: leading,
                    ),
                  ),
                ),
                DefaultTextStyle(
                  style: textTheme.titleLarge!,
                  child: title,
                ),
              ],
            ),
            const Divider(height: 8.0),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: DefaultTextStyle(
                style: textTheme.labelLarge!.copyWith(color: colors.primary),
                child: subtitle,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: description,
            ),
            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}
