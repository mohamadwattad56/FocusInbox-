
import 'package:flutter/material.dart';

import '../../../utils/fi_display.dart';
import '../../../utils/fi_resources.dart';
import '../../base/fi_base_state.dart';
import '../../base/fi_base_widget.dart';
import '../../utils/fi_ui_elements.dart';
import 'cx_home_sceen_tab_model.dart';

class FiHomeScreenTabWidget extends FiBaseWidget {
  const FiHomeScreenTabWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CxHomeScreenTabState();
}

class _CxHomeScreenTabState extends FiBaseState<FiHomeScreenTabWidget> {
  final FiHomeScreenTabModel _model = FiHomeScreenTabModel();

  @override
  void initState() {
    super.initState();
    _model.setState(this) ;
  }

  @override
  void dispose() {
    _model.setState(null) ;
    super.dispose();
  }


  @override
  Widget get content => personalContent;

  Widget get businessContent {
    double w = display.width - toX(70) ;

    return Stack(
      children: [
        Positioned(
          top: toY(0),
          left: centerOnDisplayByWidth(237),
          width: toX(237),
          height: toY(253),
          child: Image(image: const AssetImage("assets/images/blure_background.png"), width: toX(237), height: toY(233)),
        ),
        Positioned(
            left: 0,
            right: 0,

            top: toY(95),
            height: toY(65),
            child: Center( child:uiElements.applicationTitle())),
        Positioned(
          left: centerOnDisplayByWidth(w),
          width: w,
          top: toY(275),
          child: uiElements.listButton(localise("my_zone"), const AssetImage("assets/images/list_user_icon.png"),onTap: _model.onMyZoneClicked),
        ),
 /*       Positioned(
          left: centerOnDisplayByWidth(w),
          width: w,
          top: toY(385),
          child: uiElements.listButton(localise("my_organization"), const AssetImage("assets/images/network.png"),onTap: _model.onMyOrganizationClicked),
        ),
        Positioned(
          left: centerOnDisplayByWidth(w),
          width: w,
          top: toY(495),
          child: uiElements.listButton(localise("partners"), const AssetImage("assets/images/partners.png"),onTap:_model.onMyPartnersClicked),
        ),*/
        Positioned(
          left: centerOnDisplayByWidth(w),
          width: w,
          top: toY(605 ),
          child: uiElements.listButton(localise("meetings"), const AssetImage("assets/images/meetings.png"),onTap:_model.onMyMeetingsClick),
        ),
      ],
    );
  }

  Widget get personalContent {
    double w = display.width - toX(70) ;

    return Stack(
      children: [
        Positioned(
          top: toY(0),
          left: centerOnDisplayByWidth(237),
          width: toX(237),
          height: toY(253),
          child: Image(image: const AssetImage("assets/images/blure_background.png"), width: toX(237), height: toY(233)),
        ),
        Positioned(
            left: 0,
            right: 0,

            top: toY(95),
            height: toY(65),
            child: Center( child:uiElements.applicationTitle())),
        
        Positioned(
            left: 0,
            right: 0,

            top: toY(219),
            child: Center(child:Text(
          localise("personal_assistant"),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: toY(40),
            fontFamily: 'Vujahday',
            fontWeight: FontWeight.w400,
            height: 0.02,
          ),
        ))),
        Positioned(
          left: centerOnDisplayByWidth(w),
          width: w,
          top: toY(365),
          child: uiElements.listButton(localise("my_timeline"), const AssetImage("assets/images/my_timeline.png"),onTap: _model.onMyTimeLineClick),
        ),
        Positioned(
          left: centerOnDisplayByWidth(w),
          width: w,
          top: toY(495),
          child: uiElements.listButton(localise("groups"), const AssetImage("assets/images/groups_symbol.png"),onTap: _model.onMyGroupsClick),
        ),
        Positioned(
          left: centerOnDisplayByWidth(w),
          width: w,
          top: toY(625 ),
          child: uiElements.listButton(localise("meetings"), const AssetImage("assets/images/meetings.png"),onTap:_model.onMyMeetingsClick),
        ),
      ],
    );
  }
}
