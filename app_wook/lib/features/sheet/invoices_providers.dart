import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mek/mek.dart';
import 'package:mek_gasol/core/env.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mek_gasol/features/sheet/repositories/invoices_repository.dart';

abstract class InvoicesProviders {
  static final all = StreamProvider((ref) {
    return InvoicesRepository.instance.watchAll();
  });

  static final single = FutureProvider.family.autoDispose((ref, String invoiceId) async {
    final invoice = await InvoicesRepository.instance.fetch(invoiceId);
    if (invoice == null) throw TargetNotFoundFailure('${InvoicesRepository.collection}/$invoiceId');

    return invoice;
  });

  static Future<void> create(
    MutationRef ref, {
    required OrderModel? order,
    required String payerId,
    required Decimal? payedAmount,
    required IMap<String, InvoiceItemDto> items,
    required IMap<String, Decimal>? vaultOutcomes,
  }) async {
    if (order != null) {
      final invoice = await InvoicesRepository.instance.fetch(order.id);
      if (invoice != null) {
        throw AlreadyExistFailure('${InvoicesRepository.collection}/${order.id}');
      }
    }

    if (vaultOutcomes != null) {
      items = items.map((userId, item) {
        final newItem = InvoiceItemDto(isPayed: true, amount: item.amount, jobs: item.jobs);
        return MapEntry(userId, newItem);
      });
    }

    await InvoicesRepository.instance.save(InvoiceDto(
      id: order?.id ?? '',
      orderId: order?.id,
      createdAt: order?.createdAt ?? DateTime.now(),
      payerId: payerId,
      payedAmount: payedAmount,
      items: items,
      vaultOutcomes: vaultOutcomes?.where((_, value) => value > Decimal.zero),
    ));

    if (order == null) return;
    await OrdersRepository.instance.update(
      Env.organizationId,
      order.id,
      OrderUpdateDto(status: OrderStatus.delivered),
    );
  }

  static Future<void> update(
    MutationRef ref, {
    required InvoiceDto invoice,
    required String payerId,
    Decimal? payedAmount,
    required IMap<String, InvoiceItemDto> items,
    required IMap<String, Decimal>? vaultOutcomes,
  }) async {
    if (vaultOutcomes != null) {
      items = items.map((userId, item) {
        final newItem = InvoiceItemDto(isPayed: true, amount: item.amount, jobs: item.jobs);
        return MapEntry(userId, newItem);
      });
    }

    await InvoicesRepository.instance.save(InvoiceDto(
      id: invoice.id,
      orderId: invoice.orderId,
      createdAt: invoice.createdAt,
      payerId: payerId,
      payedAmount: payedAmount,
      items: items,
      vaultOutcomes: vaultOutcomes?.where((_, value) => value > Decimal.zero),
    ));
  }
}
