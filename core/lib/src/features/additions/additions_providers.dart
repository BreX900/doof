import 'package:core/src/features/additions/dto/addition_dto.dart';
import 'package:core/src/features/additions/repositories/additions_repository.dart';
import 'package:core/src/shared/core_utils.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:decimal/decimal.dart';
import 'package:mek/mek.dart';
import 'package:riverbloc/riverbloc.dart';

abstract class IngredientsProviders {
  static final all = FutureProvider.family((ref, String organizationId) async {
    return await IngredientsRepository.instance.fetchAll(organizationId);
  });

  /// ========== ADMIN

  static final pageCursor = BlocProvider<CursorBloc, CursorState>((ref) {
    return CursorBloc(size: CoreUtils.tableSize);
  });

  static final page = FutureProvider.family((ref, String organizationId) async {
    final cursor = ref.watch(pageCursor.select((state) => state.pageCursor));

    final page = await IngredientsRepository.instance.fetchPage(organizationId, cursor);
    ref.read(pageCursor.bloc).registerOffsets(page.ids);

    return page;
  });

  static final single = FutureProvider.autoDispose
      .family((ref, (String organizationId, String ingredientId) args) async {
    final (organizationId, ingredientId) = args;
    return await IngredientsRepository.instance.fetch(organizationId, ingredientId);
  });

  static Future<void> upsert(
    MutatorRef<void> ref, {
    required String organizationId,
    required String? ingredientId,
    required String title,
    required String description,
    required Decimal price,
  }) async {
    final ingredient = IngredientDto(
      id: ingredientId ?? '',
      title: title,
      description: description,
      price: price,
    );
    await IngredientsRepository.instance.upsert(organizationId, ingredient);

    ref.invalidate(page);
  }
}
