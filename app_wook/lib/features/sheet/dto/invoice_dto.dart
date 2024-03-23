import 'package:core/core.dart';
import 'package:decimal/decimal.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'invoice_dto.g.dart';

enum Job {
  garbageMan(0.75), // 0.25
  partner(1.75), // 1.25
  driver(3.5); // 3.0

  static const eaterPoints = -0.50;

  final double points;

  const Job(this.points);
}

@DataClass(createFieldsClass: true)
@DtoSerializable()
class InvoiceDto with Identifiable, _$InvoiceDto {
  static const fields = _InvoiceDtoFields();

  @override
  final String id;
  final String orderId;
  final String payerId;

  final DateTime createdAt;

  final List<String> membersIds;
  final Map<String, InvoiceItemDto> items;

  InvoiceDto({
    required this.id,
    required this.orderId,
    required this.payerId,
    required this.createdAt,
    List<String>? membersIds,
    required this.items,
  }) : membersIds = membersIds ?? items.keys.toList();

  Decimal get amount => items.values.fold(Decimal.zero, (amount, item) => amount + item.amount);

  factory InvoiceDto.fromJson(Map<String, dynamic> map) => _$InvoiceDtoFromJson(map);
  Map<String, dynamic> toJson() => _$InvoiceDtoToJson(this);
}

@DataClass()
@DtoSerializable()
class InvoiceItemDto with _$InvoiceItemDto {
  final bool isPayed;
  final Decimal amount;
  final List<Job> jobs;

  const InvoiceItemDto({
    required this.isPayed,
    required this.amount,
    required this.jobs,
  });

  factory InvoiceItemDto.fromJson(Map<String, dynamic> map) => _$InvoiceItemDtoFromJson(map);
  Map<String, dynamic> toJson() => _$InvoiceItemDtoToJson(this);
}
