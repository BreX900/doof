import 'package:app_button/shared/data/r.dart';
import 'package:app_button/shared/navigation/routes.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mek/mek.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _stateProvider = FutureProvider.autoDispose.family((ref, String organizationId) async {
  final organization = await ref.watch(OrganizationsProviders.single(organizationId).future);

  return (organization: organization);
});

class TicketCreateScreen extends ConsumerStatefulWidget {
  final String organizationId;

  TicketCreateScreen({super.key, required this.organizationId});

  late final stateProvider = _stateProvider(organizationId);

  @override
  ConsumerState<TicketCreateScreen> createState() => _TicketCreateScreenState();
}

class _TicketCreateScreenState extends ConsumerState<TicketCreateScreen> {
  final _placeFb = FormControlTyped<String>(
    initialValue: '',
    validators: [ValidatorsTyped.required()],
  );

  late final _createTicket = ref.mutation(
    (ref, arg) async {
      return await TicketsProviders.create(
        organizationId: widget.organizationId,
        place: _placeFb.value,
      );
    },
    onError: (_, error) => CoreUtils.showErrorSnackBar(context, error),
    onSuccess: (_, __) {
      TicketCreatedRoute(widget.organizationId).go(context);
    },
  );

  @override
  void dispose() {
    _placeFb.dispose();
    super.dispose();
  }

  Widget _buildBody() {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final colors = theme.colorScheme;

    final isIdle = !ref.watchIsMutating([_createTicket]);

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
              child: ReactiveTextField(
                formControl: _placeFb,
                decoration: InputDecorations.borderless.copyWith(
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
      appBar: AppBar(title: DotsText.or(data?.organization.name)),
      body: Padding(padding: const EdgeInsets.symmetric(horizontal: 64.0), child: _buildBody()),
    );
  }
}
