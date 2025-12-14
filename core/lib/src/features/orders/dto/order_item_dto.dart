import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/features/orders/dto/order_addition_dto.dart';
import 'package:core/src/features/orders/dto/order_ingredient_dto.dart';
import 'package:core/src/features/products/dto/product_dto.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part 'order_item_dto.g.dart';

typedef OrderItemDtoFields = _$OrderItemDtoJsonKeys;

@DataClass()
@DtoSerializable(createJsonKeys: true)
class OrderItemDto with _$OrderItemDto {
  final String id;
  final DateTime createdAt;
  final IList<String> buyers;
  final ProductDto product;
  final int quantity;
  final IList<OrderIngredientDto> ingredients;
  final IList<OrderLevelDto> levels;
  final Fixed payedAmount;

  const OrderItemDto({
    required this.id,
    required this.createdAt,
    required this.buyers,
    required this.product,
    required this.quantity,
    required this.ingredients,
    required this.levels,
    required this.payedAmount,
  });

  factory OrderItemDto.fromJson(Map<String, dynamic> map) => _$OrderItemDtoFromJson(map);

  Map<String, dynamic> toJson() => _$OrderItemDtoToJson(this);
}
