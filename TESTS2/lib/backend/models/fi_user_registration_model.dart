import 'dart:convert';

import 'package:googleapis/cloudsearch/v1.dart';
import 'package:json_annotation/json_annotation.dart';
part 'fi_user_registration_model.g.dart';

@JsonSerializable()
class FiUserRegistrationModel {

  String firstName ;
  String lastName ;
  String email ;
  int platform ;
  String token ;

  @override
  String toString() {
    return 'FiUserRegistrationModel{name: $firstName, email: $email, platform: $platform, token: $token}';
  }

  FiUserRegistrationModel(this.firstName,this.lastName, this.email,this.platform,this.token);

  toJson() => jsonEncode(_$FiUserRegistrationModelToJson(this));
}