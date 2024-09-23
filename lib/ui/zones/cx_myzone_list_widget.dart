import 'package:flutter/material.dart';
import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import '../utils/fi_ui_elements.dart';
import 'cx_myzone_model.dart';

class CxMyZoneListWidget extends FiBaseWidget {
  const CxMyZoneListWidget({super.key});

  @override
  Future<bool> get onWillPop {
    applicationModel.currentState = FiApplicationStates.navigationScreen ;
    return Future.value(false);
  }

  @override
  State<StatefulWidget> createState() => _CxCxMyZoneListState();
}

class _CxCxMyZoneListState extends FiBaseState<CxMyZoneListWidget> {
  final CxMyZoneModel _model = CxMyZoneModel();
  @override
  // TODO: implement content
  Widget get content => Stack(
    children: [
      uiElements.backButton(() async {
        await widget.onWillPop ;
      }) ,

      Positioned(
          top:toY(152),
          left:toX(142),
          width: toX(140),
          height: toX(140),
          child: uiElements.avatar(applicationModel.currentContact!,fontSize: 50)),
      Positioned(
        left:toX(35),
        width: toX(344),
        top: toY(373),
        height: toY(80),
        child: uiElements.listButton(localise("my_timeline"), null,onTap: _model.onMyZoneClicked),
      ),
      Positioned(
        left:toX(35),
        width: toX(344),
        top: toY(478),
        height: toY(80),
        child: uiElements.listButton(localise("groups"), null,onTap: _model.onCustomGroupsClick),
      ),
    ],
  );
}