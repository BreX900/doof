import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'place_dto.g.dart';

@DataClass()
@DtoSerializable()
class PlaceDto with Identifiable, _$PlaceDto {
  @override
  final String id;

  const PlaceDto({
    required this.id,
  });

  factory PlaceDto.fromJson(Map<String, dynamic> map) => _$PlaceDtoFromJson(map);
  Map<String, dynamic> toJson() => _$PlaceDtoToJson(this);
}
