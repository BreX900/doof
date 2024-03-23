import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'pay_slip_dto.g.dart';

@DataClass()
@JsonSerializable()
class PaySlipDto with _$PaySlipDto {
  final DateTime month;

  const PaySlipDto({
    required this.month,
  });

  factory PaySlipDto.fromJson(Map<String, dynamic> map) => _$PaySlipDtoFromJson(map);
  Map<String, dynamic> toJson() => _$PaySlipDtoToJson(this);
}
