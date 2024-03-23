import 'package:json_annotation/json_annotation.dart';

part 'qr_code_data.g.dart';

sealed class QrCodeData {
  const QrCodeData();

  factory QrCodeData.fromUrl(Uri url) {
    final type = $enumDecode(_$_QrCodeGroupEnumMap, url.pathSegments[0]);
    final data = url.queryParameters;

    return switch (type) {
      _QrCodeGroup.organizations => QrCodeOrganizationData.fromJson({
          'organizationId': url.pathSegments[1],
          ...data,
        }),
    };
  }
}

/// Example: doof:organizations/dev
@JsonSerializable(createFactory: true)
class QrCodeOrganizationData extends QrCodeData {
  final String organizationId;

  const QrCodeOrganizationData({
    required this.organizationId,
  });

  factory QrCodeOrganizationData.fromJson(Map<String, dynamic> map) =>
      _$QrCodeOrganizationDataFromJson(map);
}

@JsonEnum(alwaysCreate: true)
enum _QrCodeGroup { organizations }
