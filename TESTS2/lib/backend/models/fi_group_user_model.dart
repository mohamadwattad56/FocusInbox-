import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

import '../../utils/fi_log.dart';
part 'fi_group_user_model.g.dart';

@JsonSerializable()
class FiGroupUserModel {
  String id = "" ;
  @JsonKey(name: "firstname")
  String? firstName ;
  @JsonKey(name: "lastname")
  String? lastName ;
  String? title ;
  @JsonKey(name: "parentid")
  String? parentId ;
  String? image ;
  List<String>? phones = <String>[] ;
  List<String>? emails = <String>[] ;
  List<String>? socials = <String>[] ;
  String? company ;
  List<String> groups = <String>[] ;
  bool shared = false;

  Map<String,dynamic> get toJson => _$FiGroupUserModelToJson(this) ;

  static FiGroupUserModel fromJson(Map<String,dynamic> json) {
    try {
      FiGroupUserModel model = _$FiGroupUserModelFromJson(json);
      return model;
    }
    catch(err, stack){
      logger.d("$err, $stack") ;
      return FiGroupUserModel();
    }
  }
}