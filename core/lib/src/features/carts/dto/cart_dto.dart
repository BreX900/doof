import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:fast_immutable_collections/fast_immutable_collections.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'cart_dto.g.dart';

typedef CartDtoFields = _$CartDtoJsonKeys;

@DataClass()
@DtoSerializable(createJsonKeys: true)
class CartDto with Identifiable, _$CartDto {
  @override
  final String id;
  final String ownerId;
  final IList<String> membersIds;
  final bool isPublic;
  final String? title;

  const CartDto({
    required this.id,
    required this.ownerId,
    required this.membersIds,
    required this.isPublic,
    required this.title,
  });

  factory CartDto.fromJson(Map<String, dynamic> map) => _$CartDtoFromJson(map);
  Map<String, dynamic> toJson() => _$CartDtoToJson(this);
}

@DataClass(changeable: true)
@DtoSerializable()
class CartItemDto with Identifiable, _$CartItemDto {
  @override
  final String id;
  final String productId;
  final int quantity;
  final IList<String> buyers;
  final IList<String> ingredientsRemoved;
  final IList<String> ingredientsAdded;
  final IMap<String, double> levels;

  const CartItemDto({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.buyers,
    required this.ingredientsRemoved,
    required this.ingredientsAdded,
    required this.levels,
  });

  factory CartItemDto.fromJson(Map<String, dynamic> map) => _$CartItemDtoFromJson(map);
  Map<String, dynamic> toJson() => _$CartItemDtoToJson(this);
}
