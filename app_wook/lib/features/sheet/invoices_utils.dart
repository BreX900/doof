import 'package:collection/collection.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mekart/mekart.dart';

abstract final class InvoicesUtils {
  static IMap<String, Fixed> calculateVault(IList<InvoiceDto> invoices, {bool returnsZero = true}) {
    final amounts = <String, Fixed>{};
    for (final InvoiceDto(:payerId, :amount, :payedAmount, :vaultOutcomes) in invoices) {
      if (vaultOutcomes != null) {
        for (final MapEntry(key: userId, value: outcome) in vaultOutcomes.entries) {
          amounts[userId] = (amounts[userId] ?? Fixed.zero) - outcome;
        }
      } else if (payedAmount != null) {
        amounts[payerId] = (amounts[payerId] ?? Fixed.zero) + amount - payedAmount;
      }
    }

    var entries = amounts.entries;
    if (!returnsZero) entries = entries.where((e) => e.value != Fixed.zero);
    return entries.sortedBy((e) => -e.value).toIMap();
  }
}
