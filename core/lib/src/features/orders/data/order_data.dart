import 'package:core/src/features/orders/dto/order_dto.dart';

extension OrderStatusToData on OrderStatus {
  int? toStatusBarIndex({required bool shippable}) {
    return switch (this) {
      OrderStatus.accepting => 0,
      OrderStatus.notAccepted => null,
      OrderStatus.accepted || OrderStatus.processing => 1,
      OrderStatus.processed => shippable ? 1 : 2,
      OrderStatus.shipping || OrderStatus.shipped || OrderStatus.delivering => 2,
      OrderStatus.delivered => null,
    };
  }

  String translate({required bool shippable}) {
    return switch (this) {
      OrderStatus.accepting => 'In revisione',
      OrderStatus.notAccepted => 'Rifiutato',
      OrderStatus.accepted || OrderStatus.processing => 'In preparazione',
      OrderStatus.processed => shippable ? 'In preparazione' : 'In arrivo',
      OrderStatus.shipping || OrderStatus.shipped || OrderStatus.delivering => 'In arrivo',
      OrderStatus.delivered => 'Consegnato',
    };
  }
}
