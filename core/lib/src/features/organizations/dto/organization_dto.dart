import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'organization_dto.g.dart';

@DataClass()
@DtoSerializable()
class OrganizationDto with Identifiable, _$OrganizationDto {
  @override
  final String id;
  @JsonKey(name: 'title')
  final String name;

  const OrganizationDto({
    required this.id,
    required this.name,
  });

  factory OrganizationDto.fromJson(Map<String, dynamic> map) => _$OrganizationDtoFromJson(map);
  Map<String, dynamic> toJson() => _$OrganizationDtoToJson(this);
}
