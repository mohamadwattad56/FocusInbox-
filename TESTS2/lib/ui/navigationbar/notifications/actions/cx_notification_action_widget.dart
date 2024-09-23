import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import '../../../../models/main/fi_main_model.dart';
import '../../../../models/main/fi_main_models_states.dart';
import '../../../../utils/fi_display.dart';
import '../../../../utils/fi_resources.dart';
import '../../../base/fi_base_state.dart';
import '../../../base/fi_base_widget.dart';
import '../cx_notification.dart';
import 'cx_notification_action_model.dart';

class CxNotificationActionWidget extends FiBaseWidget {
  CxNotificationActionModel model = CxNotificationActionModel();

  CxNotificationActionWidget({super.key});

  @override
  Future<bool> get onWillPop {
    applicationModel.currentState = FiApplicationStates.navigationScreen;
    return Future.value(false);
  }

  @override
  setParams(dynamic params) {
    if (params is CxNotification) {
      model.notification = params;
    }
  }

  @override
  State<StatefulWidget> createState() => _CxNotificationActionState();
}

class _CxNotificationActionState extends FiBaseState<CxNotificationActionWidget> {
  @override
  void initState() {
    widget.model.setState(this);
    super.initState();
  }

  @override
  void dispose() {
    widget.model.setState(null);
    super.dispose();
  }

  @override
  Widget get content => Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: toY(185),
              child: const Image(
                image: AssetImage("assets/images/notification_action_top.png"),
                fit: BoxFit.fill,
              )),
          Positioned(
              top: toY(50),
              left: toX(20),
              width: toX(32),
              height: toX(32),
              child: InkWell(
                  onTap: () {
                    applicationModel.currentState = FiApplicationStates.navigationScreen;
                  },
                  child: const Image(
                    image: AssetImage("assets/images/back_page.png"),
                  ))),
          Positioned(
              top: toY(92),
              height: toY(40),
              left: 0,
              right: 0,
              child:Center(child: Text(
                localise("notification_action").toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: toY(20),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  letterSpacing: 5.10,
                ),
              ))),
          Positioned(
              top: toY(134),
              height: toY(40),
              // width: display.width,
              left: 0,
              right: 0,
              child: Center(
                  child: Text(
                '10:39:07 - 15/06/23',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: toY(15),
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                  height: 1.07,
                ),
              )))
        ],
      );
}
