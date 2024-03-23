import 'dart:async';

import 'package:backoffice/shared/widgets/admin_body_layout.dart';
import 'package:backoffice/shared/widgets/bottom_button_bar.dart';
import 'package:backoffice/shared/widgets/sliver_fields_layout.dart';
import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';

final _stateProvider = FutureProvider.autoDispose
    .family((ref, (String organizationId, String? ingredientId) args) async {
  final (organizationId, ingredientId) = args;

  IngredientDto? ingredient;
  if (ingredientId != null) {
    ingredient = await ref.watch(IngredientsProviders.single((
      organizationId,
      ingredientId,
    )).future);
  }

  return (ingredient: ingredient);
});

class AdminIngredientScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  final String organizationId;
  final String? ingredientId;

  AdminIngredientScreen({
    super.key,
    required this.organizationId,
    this.ingredientId,
  });

  late final stateProvider = _stateProvider((organizationId, ingredientId));

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  ConsumerState<AdminIngredientScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends ConsumerState<AdminIngredientScreen>
    with AsyncConsumerState {
  final _titleFb = FieldBloc<String>(
    initialValue: '',
    validator: const TextValidation(minLength: 3),
  );
  final _descriptionFb = FieldBloc<String>(
    initialValue: '',
  );
  final _priceFb = FieldBloc<Decimal?>(
    initialValue: null,
    validator: const RequiredValidation<Decimal>(),
  );

  late final _form = ListFieldBloc<void>(fieldBlocs: [_titleFb, _descriptionFb, _priceFb]);

  late final _upsertIngredient = ref.mutation((ref, arg) async {
    return await IngredientsProviders.upsert(
      ref,
      organizationId: widget.organizationId,
      ingredientId: widget.ingredientId,
      title: _titleFb.state.value,
      description: _descriptionFb.state.value,
      price: _priceFb.state.value!,
    );
  }, onSuccess: (_, __) {
    context.pop();
  });

  @override
  void initState() {
    super.initState();
    unawaited(_init());
  }

  @override
  void dispose() {
    unawaited(_form.close());
    super.dispose();
  }

  Future<void> _init() async {
    final items = await ref.read(widget.stateProvider.futureOfData);
    final ingredient = items.ingredient;
    _titleFb.updateValue(ingredient?.title);
    _descriptionFb.updateValue(ingredient?.description);
    _priceFb.updateValue(ingredient?.price);
  }

  Widget _buildBody() {
    final fields = [
      FieldText(
        fieldBloc: _titleFb,
        converter: FieldConvert.text,
        maxLines: 2,
        minLines: 1,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Title'),
      ),
      FieldText(
        fieldBloc: _descriptionFb,
        converter: FieldConvert.text,
        maxLines: 4,
        minLines: 1,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Description'),
      ),
      FieldText(
        fieldBloc: _priceFb,
        converter: FieldConvert.decimal(locale: Localizations.localeOf(context)),
        type: const TextFieldType.decimal(),
        decoration: const InputDecoration(labelText: 'Price'),
      ),
    ];

    return AdminBodyLayout(
      slivers: [
        SliverFieldsLayout(
          children: fields,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final data = state.valueOrNull;

    final isIdle = ref.watchIdle(mutations: [_upsertIngredient]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Ingredient: ${data?.ingredient?.title ?? '...'}'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle ? () => _upsertIngredient(null) : null,
              child: Text(data?.ingredient == null ? 'Create' : 'Update'),
            ),
          ),
        ],
      ),
      body: AsyncViewBuilder(
        state: state,
        builder: (context, data) => _buildBody(),
      ),
    );
  }
}
