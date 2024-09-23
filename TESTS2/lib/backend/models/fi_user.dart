import 'package:json_annotation/json_annotation.dart';
part 'fi_user.g.dart';

@JsonSerializable()

class FiUser {
  String? uuid ;
  late String token;
  late String? username;
  late String email;
  List<dynamic> calendars = <String>[];
  List<dynamic> groups = <String>[];
  //dynamic information ;
  Map<String,dynamic>? settings ;

  //static FiUser fromJson(Map<String,dynamic> json) =>_$FiUserFromJson(json) ;
  // Custom fromJson method
  static FiUser fromJson(Map<String, dynamic> json) {
    FiUser user = _$FiUserFromJson(json);

    // Concatenate firstName and lastName to form the username
    String firstName = json['firstName'] as String? ?? '';
    String lastName = json['lastName'] as String? ?? '';
    user.username = '$firstName $lastName'.trim();

    return user;
  }
  Map<String, dynamic> toJson() => _$FiUserToJson(this);

}