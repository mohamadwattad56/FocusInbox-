// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fi_user_registration_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiUserRegistrationModel _$FiUserRegistrationModelFromJson(
        Map<String, dynamic> json) =>
    FiUserRegistrationModel(
      json['firstName'] as String,
      json['lastName'] as String,
      json['email'] as String,
      json['platform'] as int,
      json['token'] as String,
    );

Map<String, dynamic> _$FiUserRegistrationModelToJson(
        FiUserRegistrationModel instance) =>
    <String, dynamic>{
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'email': instance.email,
      'platform': instance.platform,
      'token': instance.token,
    };
