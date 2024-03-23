import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'project_dvo.g.dart';

@DataClass()
@JsonSerializable()
class ProjectDvo with _$ProjectDvo {
  final String id;
  final String name;

  const ProjectDvo({
    required this.id,
    required this.name,
  });

  static const String nameKey = 'name';

  factory ProjectDvo.fromJson(Map<String, dynamic> map) => _$ProjectDvoFromJson(map);
  Map<String, dynamic> toJson() => _$ProjectDvoToJson(this);
}
