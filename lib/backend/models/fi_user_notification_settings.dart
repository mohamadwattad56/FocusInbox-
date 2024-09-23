import 'package:json_annotation/json_annotation.dart';
part 'fi_user_notification_settings.g.dart';
@JsonSerializable()
class FiUserNotificationSettings {
  @JsonKey(name: "allowedfrom")
  int allowedFrom ;
  @JsonKey(name: "allowedto")
  int allowedTo ;
  @JsonKey(name: "relatedtome")
  bool relatedToMe ;
  @JsonKey(name: "any")
  bool any ;

  FiUserNotificationSettings({required this.allowedFrom, required this.allowedTo,required this.relatedToMe,required this.any});

  @JsonKey(includeToJson: false,includeFromJson: false)
  String get allowedFromToString {
    if(allowedFrom == 0) return "-" ;
    return _millisecondsToString(allowedFrom);
  }

  @JsonKey(includeToJson: false,includeFromJson: false)
  String get allowedToToString {
    if(allowedTo == 0) return "-" ;
    return _millisecondsToString(allowedTo);
  }

  @JsonKey(includeToJson: false,includeFromJson: false)
  bool get isManualTimeSet => allowedFrom != 0 && allowedTo != 0;

  @JsonKey(includeToJson: false,includeFromJson: false)
  int get allowedHourFrom =>  DateTime.fromMillisecondsSinceEpoch(allowedFrom).hour ;

  @JsonKey(includeToJson: false,includeFromJson: false)
  int get allowedMinuteFrom =>  DateTime.fromMillisecondsSinceEpoch(allowedFrom).minute ;

  @JsonKey(includeToJson: false,includeFromJson: false)
  int get allowedSecondsFrom =>  DateTime.fromMillisecondsSinceEpoch(allowedFrom).second ;

  @JsonKey(includeToJson: false,includeFromJson: false)
  int get allowedHourTo =>  DateTime.fromMillisecondsSinceEpoch(allowedTo).hour ;

  @JsonKey(includeToJson: false,includeFromJson: false)
  int get allowedMinuteTo =>  DateTime.fromMillisecondsSinceEpoch(allowedTo).minute ;

  @JsonKey(includeToJson: false,includeFromJson: false)
  int get allowedSecondsTo =>  DateTime.fromMillisecondsSinceEpoch(allowedTo).second ;

  String _millisecondsToString(int milliseconds){
    var data = DateTime.fromMillisecondsSinceEpoch(milliseconds) ;
    var hour = data.hour < 10 ?"0${data.hour}":"${data.hour}" ;
    var minutes = data.minute < 10 ?"0${data.minute}":"${data.minute}" ;
    return "$hour:$minutes";
  }

  Map<String,dynamic> toJson() => _$FiUserNotificationSettingsToJson(this) ;

  static FiUserNotificationSettings fromJson(Map<String,dynamic> json) => _$FiUserNotificationSettingsFromJson(json) ;
}