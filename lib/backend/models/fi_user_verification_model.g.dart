// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fi_user_verification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiUserVerificationModel _$FiUserVerificationModelFromJson(
        Map<String, dynamic> json) =>
    FiUserVerificationModel()
      ..verification = json['verification'] as String?
      ..mail = json['mail'] as String?;

Map<String, dynamic> _$FiUserVerificationModelToJson(
        FiUserVerificationModel instance) =>
    <String, dynamic>{
      'verification': instance.verification,
      'mail': instance.mail,
    };
