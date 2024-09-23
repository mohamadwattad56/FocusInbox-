import 'package:json_annotation/json_annotation.dart';
part 'fi_user_phone.g.dart';
@JsonSerializable()

class FiUserPhone {
  String phone ;
  FiUserPhone({required this.phone});

  Map<String,dynamic> toJson() => _$FiUserPhoneToJson(this) ;
}