import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek/mek.dart';
import 'package:riverbloc/riverbloc.dart';

abstract class ProductsProviders {
  static final all = FutureProvider.family((ref, String organizationId) async {
    final categories = await ref.watch(CategoriesProviders.all(organizationId).future);
    final ingredients = await ref.watch(IngredientsProviders.all(organizationId).future);
    final levels = await ref.watch(LevelsProviders.all((organizationId,)).future);
    final products = await ProductsRepository.instance.fetchAll(organizationId);

    return products
        .map((e) => _modelFrom(e, categories: categories, ingredients: ingredients, levels: levels))
        .toList();
  });

  static final first =
      FutureProvider.family((ref, (String organizationId, String productId) args) async {
    final (organizationId, productId) = args;
    final products = await ref.watch(all(organizationId).future);
    return products.firstWhere((e) => e.id == productId);
  });

  /// ========== ADMIN

  static final pageCursor = BlocProvider<CursorBloc, CursorState>((ref) {
    return CursorBloc(debugLabel: '$ProductsProviders', size: CoreUtils.tableSize);
  });

  static final page = FutureProvider.family((ref, String organizationId) async {
    final categories = await ref.watch(CategoriesProviders.all(organizationId).future);
    final ingredients = await ref.watch(IngredientsProviders.all(organizationId).future);
    final levels = await ref.watch(LevelsProviders.all((organizationId,)).future);
    final cursor = ref.watch(pageCursor.select((state) => state.pageCursor));

    final page = await ProductsRepository.instance.fetchPage(organizationId, cursor);
    ref.read(pageCursor.bloc).registerOffsets(page.ids);

    return page
        .map((e) => _modelFrom(e, categories: categories, ingredients: ingredients, levels: levels))
        .toList();
  });

  static final single = FutureProvider.autoDispose
      .family((ref, (String organizationId, String productId) args) async {
    final (organizationId, productId) = args;
    final categories = await ref.watch(CategoriesProviders.all(organizationId).future);
    final ingredients = await ref.watch(IngredientsProviders.all(organizationId).future);
    final levels = await ref.watch(LevelsProviders.all((organizationId,)).future);

    final product = await ProductsRepository.instance.fetch(organizationId, productId);

    return _modelFrom(product, categories: categories, ingredients: ingredients, levels: levels);
  });

  static Future<void> upsert(
    Ref ref,
    String organizationId, {
    required String? id,
    required String categoryId,
    required String title,
    required String description,
    required Decimal price,
  }) async {
    await ProductsRepository.instance.upsert(
      organizationId,
      ProductDto(
        id: id ?? '',
        categoryId: categoryId,
        imageUrl: null,
        title: title,
        description: description,
        price: price,
        // TODO: Fill it
        ingredients: const IListConst([]),
        removableIngredients: const IListConst([]),
        addableIngredients: const IListConst([]),
        levels: const IListConst([]),
      ),
    );

    ref.invalidate(page);
  }
}

ProductModel _modelFrom(
  ProductDto product, {
  required Iterable<CategoryDto> categories,
  required Iterable<IngredientDto> ingredients,
  required Iterable<LevelDto> levels,
}) {
  return ProductModel(
    id: product.id,
    category: categories.firstWhereId(product.categoryId),
    imageUrl: product.imageUrl,
    title: product.title,
    description: product.description,
    price: product.price,
    ingredients: product.ingredients.map(ingredients.firstWhereId).toIList(),
    removableIngredients: product.removableIngredients.map(ingredients.firstWhereId).toIList(),
    addableIngredients: product.addableIngredients.map(ingredients.firstWhereId).toIList(),
    levels: product.levels.map(levels.firstWhereId).toIList(),
  );
}
