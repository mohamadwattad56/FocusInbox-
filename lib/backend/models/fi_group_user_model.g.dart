// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fi_group_user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiGroupUserModel _$FiGroupUserModelFromJson(Map<String, dynamic> json) =>
    FiGroupUserModel()
      ..id = json['id'] as String
      ..firstName = json['firstname'] as String?
      ..lastName = json['lastname'] as String?
      ..title = json['title'] as String?
      ..parentId = json['parentid'] as String?
      ..image = json['image'] as String?
      ..phones =
          (json['phones'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..emails =
          (json['emails'] as List<dynamic>?)?.map((e) => e as String).toList()
      ..socials =
          (json['socials'] as List<dynamic>?)?.map((e) => e as String).toList()
     // ..company = json['company'] as String?
      ..groups =
          (json['groups'] as List<dynamic>).map((e) => e as String).toList()
      ..shared = json['shared'] as bool;

Map<String, dynamic> _$FiGroupUserModelToJson(FiGroupUserModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstname': instance.firstName,
      'lastname': instance.lastName,
      'title': instance.title,
      'parentid': instance.parentId,
      'image': instance.image,
      'phones': instance.phones,
      'emails': instance.emails,
      'socials': instance.socials,
      'company': instance.company,
      'groups': instance.groups,
      'shared': instance.shared,
    };
