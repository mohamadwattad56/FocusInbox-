// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fi_group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CxGroupModel _$CxGroupModelFromJson(Map<String, dynamic> json) => CxGroupModel()
  ..groupid = json['groupid'] as String?
  ..parentgroup = json['parentgroup'] as String?
  ..name = json['name'] as String?
  ..members = json['members'] as List<dynamic>?
  ..childgroups = json['childgroups'] as List<dynamic>?
  ..private = json['private'] as bool?
  ..editable = json['editable'] as bool?
  ..editmembers = json['editmembers'] as bool?
  ..assignasparent = json['assignasparent'] as bool?
  ..creator = json['creator'] as String?
  ..notes = json['notes'] as String?
  ..type = json['type'] as int?
  ..logo = json['logo'] as bool?
  ..information = json['information'] as Map<String, dynamic>?;

Map<String, dynamic> _$CxGroupModelToJson(CxGroupModel instance) =>
    <String, dynamic>{
      'groupid': instance.groupid,
      'parentgroup': instance.parentgroup,
      'name': instance.name,
      'members': instance.members,
      'childgroups': instance.childgroups,
      'private': instance.private,
      'editable': instance.editable,
      'editmembers': instance.editmembers,
      'assignasparent': instance.assignasparent,
      'creator': instance.creator,
      'notes': instance.notes,
      'type': instance.type,
      'logo': instance.logo,
      'information': instance.information,
    };
