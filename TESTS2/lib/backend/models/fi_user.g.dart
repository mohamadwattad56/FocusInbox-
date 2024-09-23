// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fi_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiUser _$FiUserFromJson(Map<String, dynamic> json) => FiUser()
  ..uuid = json['uuid'] as String?
  ..token = (json['token'] as String?)!
  //..username = json['lastName'] as String?
//..phonenumber = json['phonenumber'] as String?
  ..email = json['email'] as String
//..calendars = json['calendars'] as List<dynamic>
// ..information = json['information']
  ..settings = json['settings'] as Map<String, dynamic>?;

Map<String, dynamic> _$FiUserToJson(FiUser instance) => <String, dynamic>{
  'uuid': instance.uuid,
  'token': instance.token,
  'username': instance.username,
  //'phonenumber': instance.phonenumber,
  'email': instance.email,
  //'calendars': instance.calendars,
  //'information': instance.information,
  'settings': instance.settings,

};