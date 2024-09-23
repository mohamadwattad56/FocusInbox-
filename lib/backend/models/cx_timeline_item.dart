
import 'package:json_annotation/json_annotation.dart';

enum CxTimelineItemType {
  calendar,
  email,
  whatsapp,
  call,
  unknown
}

@JsonSerializable()
class FiTimelineItem {

  @JsonKey(name:'type')
  int? _type ;
  Map<String,dynamic>? data = {}  ;


  CxTimelineItemType get type {
     switch(_type){
       case 0 : return CxTimelineItemType.calendar ;
       case 1 : return CxTimelineItemType.email ;
       case 2 : return CxTimelineItemType.whatsapp ;
       case 3 : return CxTimelineItemType.call ;
       default: return CxTimelineItemType.unknown ;
     }
  }

  String get title => "Whatsapp - incoming";

  bool get incoming => data!["incoming"]??true;

}