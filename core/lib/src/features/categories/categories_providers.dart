import 'package:core/src/features/categories/dto/category_dto.dart';
import 'package:core/src/features/categories/repositories/categories_repository.dart';
import 'package:core/src/shared/core_utils.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';

abstract class CategoriesProviders {
  static final all = FutureProvider.family((ref, String organizationId) async {
    return await CategoriesRepository.instance.fetchAll(organizationId);
  });

  /// ========== ADMIN

  static final pageCursor = StateNotifierProvider<CursorBloc, CursorState>((ref) {
    return CursorBloc(size: CoreUtils.tableSize);
  });

  static final page = FutureProvider.family((ref, String organizationId) async {
    final cursor = ref.watch(pageCursor.select((state) => state.pageCursor));
    final page = await CategoriesRepository.instance.fetchPage(organizationId, cursor);
    ref.read(pageCursor.notifier).registerOffsets(page.ids);
    return page;
  });

  static final single = FutureProvider.autoDispose
      .family((ref, (String organizationId, String categoryId) args) async {
    final (organizationId, categoryId) = args;

    return await CategoriesRepository.instance.fetch(organizationId, categoryId);
  });

  static Future<void> upsert(
    MutationRef ref,
    String organizationId, {
    required String? id,
    required int weight,
    required String title,
  }) async {
    await CategoriesRepository.instance.upsert(
      organizationId,
      CategoryDto(
        id: id ?? '',
        title: title,
        weight: weight,
      ),
    );

    ref.invalidate(page);
  }
}
