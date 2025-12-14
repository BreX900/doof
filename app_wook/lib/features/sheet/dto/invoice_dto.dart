import 'package:core/core.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part 'invoice_dto.g.dart';

enum Job {
  garbageMan(0.75), // 0.25
  partner(1.75), // 1.25
  driver(3.5); // 3.0

  static const eaterPoints = -0.50;

  final double points;

  const Job(this.points);

  String get label {
    return switch (this) {
      Job.garbageMan => 'Garbage Man',
      Job.partner => 'Partner',
      Job.driver => 'Driver',
    };
  }
}

typedef InvoiceDtoFields = _$InvoiceDtoJsonKeys;

@DataClass()
@DtoSerializable(createJsonKeys: true)
class InvoiceDto with Identifiable, _$InvoiceDto {
  @override
  final String id;
  final String? orderId;
  final String payerId;
  final Fixed? payedAmount;

  final DateTime createdAt;

  final IMap<String, InvoiceItemDto> items;

  @JsonKey(includeToJson: true)
  List<String> get membersIds => items.keys.toList();

  final IMap<String, Fixed>? vaultOutcomes;

  InvoiceDto({
    required this.id,
    required this.orderId,
    required this.payerId,
    required this.payedAmount,
    required this.createdAt,
    required this.items,
    required this.vaultOutcomes,
  });

  Fixed get amount => items.values.fold(Fixed.zero, (amount, item) => amount + item.amount);

  bool get isPayed => items.values.every((e) => e.isPayed);

  factory InvoiceDto.fromJson(Map<String, dynamic> map) => _$InvoiceDtoFromJson(map);

  Map<String, dynamic> toJson() => _$InvoiceDtoToJson(this);
}

@DataClass()
@DtoSerializable()
class InvoiceItemDto with _$InvoiceItemDto {
  final bool isPayed;
  final Fixed amount;
  final IList<Job> jobs;

  const InvoiceItemDto({required this.isPayed, required this.amount, required this.jobs});

  factory InvoiceItemDto.fromJson(Map<String, dynamic> map) => _$InvoiceItemDtoFromJson(map);

  Map<String, dynamic> toJson() => _$InvoiceItemDtoToJson(this);
}
