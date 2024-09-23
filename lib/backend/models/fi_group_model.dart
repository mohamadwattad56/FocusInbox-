import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'fi_group_model.g.dart';

const kOrganization = 0;

const kGroup = 1;

const kPartner = 2;

const kCustomGroup = 3;

@JsonSerializable()
class CxGroupModel {
  String? groupid;

  String? parentgroup;

  String? name;

  List<dynamic>? members;

  List<dynamic>? childgroups;

  bool? private = false;

  bool? editable = false;

  bool? editmembers = false;

  bool? assignasparent = true;

  String? creator;

  String? notes;

  int? type = kGroup;
  bool? logo = false ;

  Map<String,dynamic>? information = {} ;

  CxGroupModel();

  Map<String, dynamic> toJson() => _$CxGroupModelToJson(this);

  static CxGroupModel from(Map<String, dynamic> groupData) {
    return _$CxGroupModelFromJson(groupData) ;
  }
}
