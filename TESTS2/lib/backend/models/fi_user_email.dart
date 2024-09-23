import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
part 'fi_user_email.g.dart';
@JsonSerializable()
class FiUserEmail {

  String? email ;

  @JsonKey(includeFromJson: false)
  @JsonKey(includeToJson: false)
  Map<String,dynamic>? headers ;

  String? token ;
  FiUserEmail({this.email,this.headers}){
    token = headers?["Authorization"]??"" ;
    if(token!= null && token!.isNotEmpty){
      List<String> parts = token!.split(" ") ;
      if(parts.length == 2){
        token = parts[1] ;
      }
    }
  }

  String toJson() => jsonEncode(_$FiUserEmailToJson(this)) ;

}