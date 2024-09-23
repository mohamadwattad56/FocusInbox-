
import '../../../models/main/base/fi_model.dart';
import '../../../models/main/fi_main_model.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../timeline/minetimeline/cx_mine_timeline_model.dart';
import '../../utils/fi_ui_elements.dart';

class FiHomeScreenTabModel extends FiModel {

  get onMyZoneClicked => (){
    applicationModel.currentState = FiApplicationStates.myZones ;
  };

  get onMyTimeLineClick => (){
    FiMineTimelineModel timelineModel = FiMineTimelineModel();
  applicationModel.setCurrentStateWithParams(FiApplicationStates.mineTimeline, {kBackState:FiApplicationStates.navigationScreen,kTimeline:timelineModel}) ;

  };

  get onMyGroupsClick => (){
    applicationModel.setCurrentStateWithParams(FiApplicationStates.customGroupsList, {kBackState:FiApplicationStates.navigationScreen}) ;
    applicationModel.currentState = FiApplicationStates.customGroupsList ;
  };

  //get onMyOrganizationClicked =>()=>applicationModel.currentState = FiApplicationStates.organizationList ;

 // get onMyPartnersClicked => ()=>applicationModel.currentState = FiApplicationStates.partnersList ;

  get onMyMeetingsClick => ()=>applicationModel.currentState = FiApplicationStates.meetingMenu ;

}