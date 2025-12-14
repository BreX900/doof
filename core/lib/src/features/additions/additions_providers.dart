import 'package:core/src/features/additions/dto/addition_dto.dart';
import 'package:core/src/features/additions/repositories/additions_repository.dart';
import 'package:core/src/shared/core_utils.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mek/mek.dart';
import 'package:mekart/mekart.dart';

abstract class IngredientsProviders {
  static final all = FutureProvider.family((ref, String organizationId) async {
    return await IngredientsRepository.instance.fetchAll(organizationId);
  });

  /// ========== ADMIN

  static final pageCursor = StateNotifierProvider<CursorBloc, CursorState>((ref) {
    return CursorBloc(size: CoreUtils.tableSize);
  });

  static final page = FutureProvider.family((ref, String organizationId) async {
    final cursor = ref.watch(pageCursor.select((state) => state.pageCursor));

    final page = await IngredientsRepository.instance.fetchPage(organizationId, cursor);
    ref.read(pageCursor.notifier).registerOffsets(page.ids);

    return page;
  });

  static final single = FutureProvider.autoDispose.family((
    ref,
    (String organizationId, String ingredientId) args,
  ) async {
    final (organizationId, ingredientId) = args;
    return await IngredientsRepository.instance.fetch(organizationId, ingredientId);
  });

  static Future<void> upsert(
    MutationRef ref, {
    required String organizationId,
    required String? ingredientId,
    required String title,
    required String description,
    required Fixed price,
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
