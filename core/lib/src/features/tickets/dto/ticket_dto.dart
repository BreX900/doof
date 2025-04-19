import 'package:core/core.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'ticket_dto.g.dart';

enum TicketStatus { pending, processing, resolved }

typedef TicketDtoFields = _$TicketDtoJsonKeys;

@DataClass(changeable: true)
@DtoSerializable(createJsonKeys: true)
class TicketDto with Identifiable, _$TicketDto {
  @override
  final String id;
  final DateTime createAt;
  final DateTime updatedAt;
  final TicketStatus status;
  final String place;

  const TicketDto({
    required this.id,
    required this.createAt,
    required this.updatedAt,
    required this.status,
    required this.place,
  });

  factory TicketDto.fromJson(Map<String, dynamic> map) => _$TicketDtoFromJson(map);
  Map<String, dynamic> toJson() => _$TicketDtoToJson(this);
}

// @DataClass(createFieldsClass: true, changeable: true)
// @DtoRequestSerializable()
// class TicketUpdateDto {
//   final DateTime updatedAt = DateTime.now();
//   final TicketStatus status;
//
//   TicketUpdateDto({
//     required this.status,
//   });
//
//   Map<String, dynamic> toJson() => _$TicketUpdateDtoToJson(this);
// }
