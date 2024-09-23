

import '../../../models/main/fi_main_model.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../../utils/fi_resources.dart';
import '../../../utils/list/fi_expanded_members_list.dart';
import '../../utils/fi_ui_elements.dart';
import '../base/fi_timeline_model.dart';
import '../group/cx_group_timeline_model.dart';

class FiMineTimelineModel extends FiTimelineModel {


  @override
  String get title => localise("my_timeline") ;

  @override
  OnGroupListItemClickCallback get showGroupTimeline => (group){
    applicationModel.setCurrentStateWithParams(FiApplicationStates.groupTimeline, {kBackState:FiApplicationStates.mineTimeline,kTargetGroup:group,kTimeline:CxGroupTimelineModel( group: group)});
  };

  @override
  String get name => applicationModel.currentContact!.name;

  @override
  String get phone => applicationModel.currentContact!.phoneNumber;

  @override
  String get occupation => applicationModel.currentContact!.title == localise("title") ? "" :  applicationModel.currentContact!.title ;
}