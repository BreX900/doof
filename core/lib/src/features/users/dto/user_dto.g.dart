// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: cast_nullable_to_non_nullable, unnecessary_null_checks, unused_field

part of 'user_dto.dart';

// **************************************************************************
// DataClassGenerator
// **************************************************************************

mixin _$AuthUserDto {
  AuthUserDto get _self => this as AuthUserDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AuthUserDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.phoneNumber == other.phoneNumber;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.phoneNumber.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('AuthUserDto')
        ..add('id', _self.id)
        ..add('phoneNumber', _self.phoneNumber))
      .toString();
}

mixin _$UserDto {
  UserDto get _self => this as UserDto;
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDto &&
          runtimeType == other.runtimeType &&
          _self.id == other.id &&
          _self.displayName == other.displayName &&
          _self.phoneNumber == other.phoneNumber;
  @override
  int get hashCode {
    var hashCode = 0;
    hashCode = $hashCombine(hashCode, _self.id.hashCode);
    hashCode = $hashCombine(hashCode, _self.displayName.hashCode);
    hashCode = $hashCombine(hashCode, _self.phoneNumber.hashCode);
    return $hashFinish(hashCode);
  }

  @override
  String toString() => (ClassToString('UserDto')
        ..add('id', _self.id)
        ..add('displayName', _self.displayName)
        ..add('phoneNumber', _self.phoneNumber))
      .toString();
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDto _$UserDtoFromJson(Map<String, dynamic> json) => UserDto(
      id: json['id'] as String,
      displayName: json['displayName'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );

Map<String, dynamic> _$UserDtoToJson(UserDto instance) => <String, dynamic>{
      'id': instance.id,
      'displayName': instance.displayName,
      'phoneNumber': instance.phoneNumber,
    };
