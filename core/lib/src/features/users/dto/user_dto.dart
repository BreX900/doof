import 'package:core/src/apis/serialization/serialization.dart';
import 'package:core/src/shared/data/identifiable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mek_data_class/mek_data_class.dart';

part 'user_dto.g.dart';

@DataClass()
class AuthUserDto with Identifiable, _$AuthUserDto {
  @override
  final String id;
  final String? phoneNumber;

  const AuthUserDto({
    required this.id,
    required this.phoneNumber,
  });
}

@DataClass()
@DtoSerializable()
class UserDto with Identifiable, _$UserDto {
  @override
  final String id;
  final String? displayName;
  final String? phoneNumber;

  const UserDto({
    required this.id,
    required this.displayName,
    required this.phoneNumber,
  });

  static const UserDto unknown = UserDto(id: '', displayName: null, phoneNumber: null);

  factory UserDto.fromJson(Map<String, dynamic> map) => _$UserDtoFromJson(map);
  Map<String, dynamic> toJson() => _$UserDtoToJson(this);
}

extension FirebaseUserToDtoExtension on User {
  AuthUserDto toDto() {
    return AuthUserDto(
      id: uid,
      phoneNumber: phoneNumber,
    );
  }
}
