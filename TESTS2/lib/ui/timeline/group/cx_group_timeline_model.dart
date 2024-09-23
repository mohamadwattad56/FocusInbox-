import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/main/fi_main_model.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../../utils/fi_image_data.dart';
import '../../../utils/fi_resources.dart';
import '../../../utils/list/cx_expanded_groups_list.dart';
import '../../groups/fi_group.dart';
import '../base/fi_timeline_model.dart';

class CxGroupTimelineModel extends FiTimelineModel {
  FiGroup group ;
  CxGroupTimelineModel({required this.group});


  String get name {
     return applicationModel.currentContact!.name;
  }

  @override
  FiApplicationStates get backState => FiApplicationStates.groupTimeline;

  @override
  String get phone {
      return applicationModel.currentContact!.phoneNumber;

  }

  @override
  String get occupation {
      return applicationModel.currentContact!.title == localise("title") ? "" : applicationModel.currentContact!.title;
  }

  @override
  String get title => group.name! ;

  @override
  bool get logoVisible => true ;

  @override
  Widget get logo => group.logoWithSize(size: 105);

  @override
  OnGroupListItemClickCallback get showMemberTimeline => (member){} ;

  @override
  String get timelineName => localise("group_timeline");

  @override
  bool get pageMenuSupported => true;

  @override
  updateImage(XFile file){
    group.setImage(FiImageData(image: file)) ;
    group.uploadImages();
  }


}