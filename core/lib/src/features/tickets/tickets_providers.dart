import 'package:core/src/features/tickets/dto/ticket_dto.dart';
import 'package:core/src/features/tickets/repositories/tickets_repository.dart';
import 'package:core/src/shared/core_utils.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:mek/mek.dart';
import 'package:riverbloc/riverbloc.dart';

abstract class TicketsProviders {
  static Future<void> create({
    required String organizationId,
    required String place,
  }) async {
    final now = DateTime.now();
    final ticket = TicketDto(
      id: '',
      createAt: now,
      updatedAt: now,
      status: TicketStatus.pending,
      place: place,
    );
    await TicketsRepository.instance.create(organizationId, ticket);
  }

  /// ========== ADMIN
  // static final all = FutureProvider.family((ref, (String organizationId,) args) async {
  //   final (organizationId,) = args;
  //
  //   return await TicketsRepository.instance.fetchAll(organizationId);
  // });

  static final pageCursor = BlocProvider<CursorBloc, CursorState>((ref) {
    return CursorBloc(size: CoreUtils.tableSize);
  });

  static final page = StreamProvider.family((ref, String organizationId) async* {
    final cursor = ref.watch(pageCursor.select((state) => state.pageCursor));

    final onPage = await TicketsRepository.instance.watchPage(organizationId, cursor);

    await for (final page in onPage) {
      ref.read(pageCursor.bloc).registerOffsets(page.ids, page: cursor.page);

      yield page;
    }
  });

  static Future<void> update({
    required String organizationId,
    required String ticketId,
    required TicketStatus status,
  }) async {
    await TicketsRepository.instance.update(organizationId, ticketId, status: status);
  }

  // static final single = FutureProvider.autoDispose
  //     .family((ref, (String organizationId, String productId) args) async {
  //   final (organizationId, productId) = args;
  //   return await TicketsRepository.instance.fetch(organizationId, productId);
  // });
}
