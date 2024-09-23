// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fi_user_notification_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


FiUserNotificationSettings _$FiUserNotificationSettingsFromJson(
    Map<String, dynamic> json) =>
    FiUserNotificationSettings(
      allowedFrom: json['allowedfrom'] as int,
      allowedTo: json['allowedto'] as int,
      relatedToMe: json['relatedtome'] as bool,
      any: json['any'] as bool,
    );

Map<String, dynamic> _$FiUserNotificationSettingsToJson(
    FiUserNotificationSettings instance) =>
    <String, dynamic>{
      'allowedfrom': instance.allowedFrom,
      'allowedto': instance.allowedTo,
      'relatedtome': instance.relatedToMe,
      'any': instance.any,
    };
