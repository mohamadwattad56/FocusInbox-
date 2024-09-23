import 'dart:ui';
import '../../models/main/base/fi_model.dart';
import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../timeline/minetimeline/cx_mine_timeline_model.dart';
import '../utils/fi_ui_elements.dart';

class CxMyZoneModel extends FiModel {
  FiMineTimelineModel? timeline ;

  Future<FiMineTimelineModel> _loadTimeline() async {
    FiMineTimelineModel timelineModel = FiMineTimelineModel();
    return timelineModel ;
  }

  VoidCallback get onMyZoneClicked => () async {
    timeline = await _loadTimeline();
    applicationModel.setCurrentStateWithParams(FiApplicationStates.mineTimeline, {kBackState:FiApplicationStates.myZones,kTimeline:timeline}) ;
  };

  VoidCallback get onCustomGroupsClick => (){
    applicationModel.currentState = FiApplicationStates.customGroupsList ;
  };



}