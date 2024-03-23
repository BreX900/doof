import 'package:core/core.dart';
import 'package:mek/mek.dart';
import 'package:riverbloc/riverbloc.dart';

abstract class OrganizationsProviders {
  static final single = FutureProvider.family((ref, String organizationId) async {
    return await OrganizationsRepository.instance.fetch(organizationId);
  });

  /// ========== ADMIN

  static final pageCursor = BlocProvider<CursorBloc, CursorState>((ref) {
    return CursorBloc(size: CoreUtils.tableSize);
  });

  static final page = FutureProvider((ref) async {
    final cursor = ref.watch(pageCursor.select((state) => state.pageCursor));

    final page = await OrganizationsRepository.instance.fetchPage(cursor);
    ref.read(pageCursor.bloc).registerOffsets(page.ids);

    return page;
  });
}
