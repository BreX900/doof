import 'dart:async';

import 'package:backoffice/shared/widgets/admin_body_layout.dart';
import 'package:backoffice/shared/widgets/bottom_button_bar.dart';
import 'package:backoffice/shared/widgets/sliver_fields_layout.dart';
import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mek/mek.dart';

final _stateProvider =
    FutureProvider.autoDispose.family((ref, (String organizationId, String? productId) args) async {
  final (organizationId, productId) = args;
  ProductModel? product;
  if (productId != null) {
    product = await ref.watch(ProductsProviders.single((organizationId, productId)).future);
  }
  final categories = await ref.watch(CategoriesProviders.all(organizationId).future);
  final ingredients = await ref.watch(IngredientsProviders.all(organizationId).future);

  return (product: product, categories: categories, ingredients: ingredients);
});

class AdminProductScreen extends ConsumerStatefulWidget with AsyncConsumerStatefulWidget {
  final String organizationId;
  final String? productId;

  AdminProductScreen({
    super.key,
    required this.organizationId,
    this.productId,
  });

  late final stateProvider = _stateProvider((organizationId, productId));

  @override
  ProviderBase<Object?> get asyncProvider => stateProvider;

  @override
  ConsumerState<AdminProductScreen> createState() => _AdminProductScreenState();
}

class _AdminProductScreenState extends ConsumerState<AdminProductScreen> with AsyncConsumerState {
  final _categoryFb = FieldBloc<CategoryDto?>(
    initialValue: null,
    validator: const RequiredValidation<CategoryDto>(),
  );
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
  final _ingredientsFb = FieldBloc<IList<IngredientDto>>(
    initialValue: const IListConst([]),
  );
  final _removableIngredientsFb = FieldBloc<IList<IngredientDto>>(
    initialValue: const IListConst([]),
  );
  final _addableIngredientsFb = FieldBloc<IList<IngredientDto>>(
    initialValue: const IListConst([]),
  );

  late final _form =
      ListFieldBloc<void>(fieldBlocs: [_categoryFb, _titleFb, _descriptionFb, _priceFb]);

  late final _upsertProduct = ref.mutation((ref, arg) async {
    return await ProductsProviders.upsert(
      ref,
      widget.organizationId,
      id: widget.productId,
      categoryId: _categoryFb.state.value!.id,
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
    unawaited(_initForm());
  }

  @override
  void dispose() {
    unawaited(_form.close());
    super.dispose();
  }

  Future<void> _initForm() async {
    _ingredientsFb.stream.map((state) => state.value).distinct().listen((ingredients) {
      final removables = _removableIngredientsFb.state.value;
      _removableIngredientsFb.changeValue(removables.removeAll(ingredients));
    });

    final items = await ref.read(widget.stateProvider.futureOfData);
    final product = items.product;
    _categoryFb.updateValue(product?.category);
    _titleFb.updateValue(product?.title);
    _descriptionFb.updateValue(product?.description);
    _priceFb.updateValue(product?.price);
    _ingredientsFb.updateValue(product?.ingredients ?? const IListConst([]));
    _addableIngredientsFb.updateValue(product?.addableIngredients ?? const IListConst([]));
    _removableIngredientsFb.updateValue(product?.removableIngredients ?? const IListConst([]));
  }

  Widget _buildIngredientsField({
    required FieldBloc<IList<IngredientDto>> fieldBloc,
    required IList<IngredientDto> ingredients,
    required InputDecoration decoration,
  }) {
    return FieldChipsInput(
      fieldBloc: fieldBloc,
      decoration: decoration.copyWith(
        labelStyle: const TextStyle(height: 0.0),
      ),
      findSuggestions: (query) =>
          ingredients.where((e) => e.title.toLowerCase().contains(query.toLowerCase())).toList(),
      labelBuilder: (context, value) => Text(value.title),
    );
  }

  Widget _buildBody({
    required ProductModel? product,
    required IList<CategoryDto> categories,
    required IList<IngredientDto> ingredients,
  }) {
    final fields = [
      FieldDropdown(
        fieldBloc: _categoryFb,
        decoration: const InputDecoration(labelText: 'Category'),
        items: categories.map((e) {
          return DropdownMenuItem(
            value: e,
            child: Text(e.title),
          );
        }).toList(),
      ),
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
      _buildIngredientsField(
        fieldBloc: _ingredientsFb,
        ingredients: ingredients,
        decoration: const InputDecoration(labelText: 'Ingredients'),
      ),
      // if (false)
      Consumer(builder: (context, ref, child) {
        final consumableIngredients = ref.watch(_ingredientsFb.select((state) => state.value));

        return _buildIngredientsField(
          fieldBloc: _removableIngredientsFb,
          ingredients: consumableIngredients,
          decoration: const InputDecoration(labelText: 'Removable ingredients'),
        );
      }),
      // if (false)
      Consumer(builder: (context, ref, child) {
        final consumableIngredients =
            ref.watch(_ingredientsFb.select((state) => ingredients.removeAll(state.value)));

        return _buildIngredientsField(
          fieldBloc: _addableIngredientsFb,
          ingredients: consumableIngredients,
          decoration: const InputDecoration(
            label: Padding(
              padding: EdgeInsets.only(bottom: 20.0),
              child: Text('Addable ingredients'),
            ),
          ),
        );
      })
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
    final items = state.valueOrNull;

    final isIdle = ref.watchIdle(mutations: [_upsertProduct]);
    final canSubmit = ref.watchCanSubmit(_form);

    return Scaffold(
      appBar: AppBar(
        title: Text('Product: ${items?.product?.title ?? '...'}'),
      ),
      bottomNavigationBar: BottomButtonBar(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: isIdle && canSubmit ? () => _upsertProduct(null) : null,
              child: Text(items?.product == null ? 'Create' : 'Update'),
            ),
          ),
        ],
      ),
      body: state.buildView(
        data: (items) => _buildBody(
          product: items.product,
          categories: items.categories,
          ingredients: items.ingredients,
        ),
      ),
    );
  }
}
