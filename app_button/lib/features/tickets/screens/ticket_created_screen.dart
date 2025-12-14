import 'dart:async';

import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:app_button/shared/widgets/app_info_view.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mek/mek.dart';

final _stateProvider = FutureProvider.autoDispose.family((ref, String organizationId) async {
  final organization = await ref.watch(OrganizationsProviders.single(organizationId).future);

  return (organization: organization);
});

class TicketCreatedScreen extends ConsumerStatefulWidget {
  final String organizationId;

  const TicketCreatedScreen({
    super.key,
    required this.organizationId,
  });

  @override
  ConsumerState<TicketCreatedScreen> createState() => _PlaceSentScreenState();
}

class _PlaceSentScreenState extends ConsumerState<TicketCreatedScreen> {
  @override
  void initState() {
    super.initState();
    unawaited(_initAutoPop());
  }

  Future<void> _initAutoPop() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    if (!mounted) return;
    ServicesRoute(widget.organizationId).go(context);
  }

  Widget _buildBody() {
    return AppInfoView(
      header: SvgPicture.asset(R.svgsTableServiceRequested),
      title: const Text('Richiesta inviata'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(_stateProvider(widget.organizationId));
    final data = state.value;

    return Scaffold(
      appBar: AppBar(
        title: DotsText.or(data?.organization.name),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 64.0),
        child: _buildBody(),
      ),
    );
  }
}
