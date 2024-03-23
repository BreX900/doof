import 'dart:async';

import 'package:app_button/apis/material/text_icon.dart';
import 'package:app_button/apis/riverpod/safe_ref.dart';
import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mek/mek.dart';

final _stateProvider = FutureProvider.autoDispose.family((unsafeRef, String organizationId) async {
  final ref = unsafeRef.safe;

  final organization = await ref.watch(OrganizationsProviders.single(organizationId).future);

  return (organization: organization);
});

class TicketCreateScreen extends ConsumerStatefulWidget {
  final String organizationId;

  TicketCreateScreen({
    super.key,
    required this.organizationId,
  });

  late final stateProvider = _stateProvider(organizationId);

  @override
  ConsumerState<TicketCreateScreen> createState() => _TicketCreateScreenState();
}

class _TicketCreateScreenState extends ConsumerState<TicketCreateScreen> {
  final _placeFb = FieldBloc(
    initialValue: '',
    validator: const TextValidation(minLength: 1),
  );

  late final _createTicket = ref.mutation((ref, arg) async {
    return await TicketsProviders.create(
      organizationId: widget.organizationId,
      place: _placeFb.state.value,
    );
  }, onSuccess: (_, __) {
    TicketCreatedRoute(widget.organizationId).go(context);
  });

  @override
  void dispose() {
    unawaited(_placeFb.close());
    super.dispose();
  }

  Widget _buildBody() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;

    final isIdle = ref.watchIdle(mutations: [_createTicket]);

    return Column(
      children: [
        const Spacer(),
        SvgPicture.asset(R.svgsTableServiceSticky),
        const Spacer(),
        Text(
          'Inserisci il numero di ombrellone o lettino',
          style: textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const Spacer(),
        Row(
          children: [
            Expanded(
              child: FieldText(
                fieldBloc: _placeFb,
                converter: FieldConvert.text,
                decoration: FieldBuilder.decorationBorderless.copyWith(
                  iconColor: colors.primary,
                  icon: const TextIcon('#'),
                  hintText: 'numero',
                ),
              ),
            ),
            OutlinedButton(
              onPressed: isIdle ? () => _createTicket(null) : null,
              child: const Text('SEND'),
            ),
          ],
        ),
        const Spacer(flex: 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final data = state.valueOrNull;

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
