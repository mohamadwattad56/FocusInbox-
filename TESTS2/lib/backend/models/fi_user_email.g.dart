// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fi_user_email.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiUserEmail _$FiUserEmailFromJson(Map<String, dynamic> json) => FiUserEmail(
      email: json['email'] as String?,
    )..token = json['token'] as String?;

Map<String, dynamic> _$FiUserEmailToJson(FiUserEmail instance) =>
    <String, dynamic>{
      'email': instance.email,
      'token': instance.token,
    };
