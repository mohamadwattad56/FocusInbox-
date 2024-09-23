import 'package:flutter/material.dart';
import '../../../models/main/fi_main_model.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../../utils/list/fi_multi_list_item.dart';
import '../../base/fi_base_widget.dart';
import '../../utils/fi_ui_elements.dart';
import 'cx_timeline_state.dart';
import 'fi_timeline_model.dart';

//ignore: must_be_immutable
class CxTimelineWidget extends FiBaseWidget {
  FiMultiListItem? timelineItem ;
  CxTimelineWidget({super.key});

  FiApplicationStates? _backState;
  late FiTimelineModel model;

  VoidCallback? onWillPopCallBack ;
  @override
  Future<bool> get onWillPop {
    if(onWillPopCallBack != null){
      onWillPopCallBack!.call() ;
    }
    else {
      if (_backState != null) {
        applicationModel.currentState = _backState!;
      }
    }
    return Future.value(false);
  }

  @override
  setParams(params) {
    if (params is Map<String, dynamic>) {
      _backState = params[kBackState];
      model = params[kTimeline];
    }
  }

  @override
  State<StatefulWidget> createState() => CxTimelineState();
}




