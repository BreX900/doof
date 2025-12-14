import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:mek/mek.dart';

abstract class OrganizationsProviders {
  static final single = FutureProvider.family((ref, String organizationId) async {
    return await OrganizationsRepository.instance.fetch(organizationId);
  });

  /// ========== ADMIN

  static final pageCursor = StateNotifierProvider<CursorBloc, CursorState>((ref) {
    return CursorBloc(size: CoreUtils.tableSize);
  });

  static final page = FutureProvider((ref) async {
    final cursor = ref.watch(pageCursor.select((state) => state.pageCursor));

    final page = await OrganizationsRepository.instance.fetchPage(cursor);
    ref.read(pageCursor.notifier).registerOffsets(page.ids);

    return page;
  });
}
