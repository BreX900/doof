import 'package:core/src/apis/serialization/timestamp_json_converter.dart';
import 'package:json_annotation/json_annotation.dart';

// ignore: depend_on_referenced_packages
export 'package:cloud_firestore_platform_interface/cloud_firestore_platform_interface.dart'
    show Timestamp;
export 'package:core/src/apis/serialization/timestamp_json_converter.dart'
    show TimestampJsonConvert;
export 'package:json_annotation/json_annotation.dart' show $enumDecode, $enumDecodeNullable;

class DtoSerializable extends JsonSerializable {
  const DtoSerializable({
    super.createJsonKeys,
  }) : super(
          createFactory: true,
          createToJson: true,
          converters: const [TimestampJsonConvert()],
        );
}

class DtoRequestSerializable extends JsonSerializable {
  const DtoRequestSerializable()
      : super(
          createToJson: true,
          converters: const [TimestampJsonConvert()],
        );
}

// class DecimalConverter extends JsonConverter<Decimal, String> {
//   const DecimalConverter();
//
//   @override
//   Decimal fromJson(String json) => Decimal.parse(json);
//
//   @override
//   String toJson(Decimal object) => object.toString();
// }
