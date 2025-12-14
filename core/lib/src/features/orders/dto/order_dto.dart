import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part 'order_dto.g.dart';

enum OrderStatus {
  accepting,
  notAccepted,
  accepted,
  processing,
  processed,
  shipping,
  shipped,
  delivering,
  delivered,
}

typedef OrderDtoFields = _$OrderDtoJsonKeys;

@DataClass()
@DtoSerializable(createJsonKeys: true)
class OrderDto with Identifiable, _$OrderDto {
  @override
  final String id;
  final String? originCartId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? at;
  final String organizationId;
  final String payerId;
  final IList<String> membersIds;
  final bool shippable;
  final OrderStatus status;
  final String? place;
  final Fixed payedAmount;

  const OrderDto({
    required this.id,
    required this.originCartId,
    required this.createdAt,
    required this.updatedAt,
    required this.at,
    required this.organizationId,
    required this.payerId,
    required this.membersIds,
    required this.status,
    required this.shippable,
    required this.place,
    required this.payedAmount,
  });

  factory OrderDto.fromJson(Map<String, dynamic> map) => _$OrderDtoFromJson(map);

  Map<String, dynamic> toJson() => _$OrderDtoToJson(this);
}

@DtoRequestSerializable()
class OrderUpdateDto {
  final DateTime updateAt = DateTime.now();
  final OrderStatus status;

  OrderUpdateDto({required this.status});

  Map<String, dynamic> toJson() => _$OrderUpdateDtoToJson(this);
}
