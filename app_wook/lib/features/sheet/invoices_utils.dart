import 'package:collection/collection.dart';
import 'package:decimal/decimal.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_gasol/features/sheet/dto/invoice_dto.dart';
import 'package:mekart/mekart.dart';

abstract final class InvoicesUtils {
  static IMap<String, Decimal> calculateVault(IList<InvoiceDto> invoices) {
    final amounts = <String, Decimal>{};
    for (final InvoiceDto(:payerId, :amount, :payedAmount, :vaultOutcomes) in invoices) {
      if (vaultOutcomes != null) {
        for (final MapEntry(key: userId, value: outcome) in vaultOutcomes.entries) {
          amounts[userId] = (amounts[userId] ?? Decimal.zero) + outcome;
        }
      } else if (payedAmount != null) {
        amounts[payerId] = (amounts[payerId] ?? Decimal.zero) + amount - payedAmount;
      }
    }
    return amounts.entries.sortedBy((e) => e.value).reversed.toIMap();
  }
}

Decimal maxDecimal(Decimal a, Decimal b) => a > b ? a : b;
Decimal minDecimal(Decimal a, Decimal b) => a < b ? a : b;
