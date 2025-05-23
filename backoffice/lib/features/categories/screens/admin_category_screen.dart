import 'dart:async';

import 'package:backoffice/shared/widgets/admin_body_layout.dart';
import 'package:backoffice/shared/widgets/sliver_fields_layout.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';
import 'package:reactive_forms/reactive_forms.dart';

final _stateProvider = FutureProvider.autoDispose
    .family((ref, (String organizationId, String? categoryId) args) async {
  final (organizationId, categoryId) = args;
  CategoryDto? category;
  if (categoryId != null) {
    category = await ref.watch(CategoriesProviders.single((organizationId, categoryId)).future);
  }
  return category;
});

class AdminCategoryScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  final String organizationId;
  final String? categoryId;

  AdminCategoryScreen({
    super.key,
    required this.organizationId,
    this.categoryId,
  });

  late final stateProvider = _stateProvider((organizationId, categoryId));

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  ConsumerState<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends ConsumerState<AdminCategoryScreen> with AsyncConsumerState {
  final _titleFb = FormControlTyped<String>(
    initialValue: '',
    validators: [ValidatorsTyped.required(), ValidatorsTyped.text(minLength: 3)],
  );
  final _weightFb = FormControlTyped<int>(
    initialValue: 0,
  );

  late final _form = FormArray<void>([_titleFb, _weightFb]);

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
    final category = await ref.read(widget.stateProvider.futureOfData);
    _titleFb.updateValue(category?.title);
    _weightFb.updateValue(category?.weight);
  }

  late final _upsertCategory = ref.mutation((ref, _) async {
    await CategoriesProviders.upsert(
      ref,
      widget.organizationId,
      id: widget.categoryId,
      title: _titleFb.state.value,
      weight: _weightFb.state.value,
    );
  }, onSuccess: (_, __) {
    context.pop();
  });

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(widget.stateProvider);
    final items = state.valueOrNull;
    final isIdle = !ref.watchIsMutating([_upsertCategory]);

    return Scaffold(
      appBar: AppBar(
        title: Text('Category: ${items?.title ?? '...'}'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle ? ref.handleSubmit(_form, () => _upsertCategory(null)) : null,
              child: Text(widget.categoryId == null ? 'Create' : 'Update'),
            ),
          )
        ],
      ),
      body: AsyncViewBuilder(
        state: state,
        builder: (context, items) => _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final fields = [
      ReactiveTextField(
        formControl: _titleFb,
        maxLines: 2,
        minLines: 1,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(labelText: 'Title'),
      ),
      ReactiveTypedTextField(
        formControl: _weightFb,
        variant: const TextFieldVariant.integer(),
        decoration: const InputDecoration(labelText: 'Weight'),
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
}
