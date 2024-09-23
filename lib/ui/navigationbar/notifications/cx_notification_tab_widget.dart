
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

import '../../../models/main/fi_main_model.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../../utils/fi_display.dart';
import '../../../utils/fi_resources.dart';
import '../../base/fi_base_state.dart';
import '../../base/fi_base_widget.dart';
import '../../utils/fi_ui_elements.dart';
import 'cx_notification.dart';
import 'cx_notification_model.dart';

class CxNotificationsTabWidget extends FiBaseWidget {
  const CxNotificationsTabWidget({super.key});

  @override
  State<StatefulWidget> createState() => _CxNotificationsTabState();
}

class _CxNotificationsTabState extends FiBaseState<CxNotificationsTabWidget> {
  @override
  void initState() {
    notificationModel.setState(this);
    super.initState();
  }

  @override
  void dispose() {
    notificationModel.setState(null);
    super.dispose();
  }

  @override
  // TODO: implement content
  Widget get content => Stack(
        children: [
          Positioned(
              top: toY(53),
              height: toY(40),
              width: display.width,
              child: Text(
                localise("notifications").toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: toY(22),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w800,
                  //letterSpacing: 5.61,
                ),
              )),
          Positioned(
              top: toY(126),
              width: display.width,
              height: display.height - toY(126),
              child: ListView.builder(
                  itemCount: notificationModel.notificationCount,
                  padding: EdgeInsets.only(left: toX(25), right: toX(25), top: toY(0), bottom: toY(0)),
                  itemBuilder: (BuildContext context, int index) {
                    return SizedBox(
                      height: toY(126),
                      width: display.width,
                      child: Padding(
                        padding: EdgeInsets.only(top: toY(20)),
                        child: _notificationItem(index),
                      ),
                    );
                  }))
        ],
      );

  Widget _notificationItem(int index) {
    CxNotification notification = notificationModel.notificationAtIndex(index);

    ConstraintId nameLabelId = ConstraintId("_notificationItem_nameLabelId_$index");
    ConstraintId messageLabelId = ConstraintId("_notificationItem_messageLabelId_$index");
    ConstraintId menuLabelId = ConstraintId("_notificationItem_menuLabelId_$index");
    ConstraintId timeLabelId = ConstraintId("_notificationItem_timeLabelId_$index");
    return ConstraintLayout(
      children: [
        Padding(
            padding: EdgeInsets.only(left: toX(52)),
            child: Text(
              notification.author,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(16),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            )).applyConstraint(id: nameLabelId, left: parent.left, top: parent.top),
        Padding(padding: EdgeInsets.only(left: toX(7)), child: const Image(image: AssetImage("assets/images/success_circle.png"))).applyConstraint(left: nameLabelId.right, top: nameLabelId.top, width: toX(23), height: toY(16)),
        const Image(image: AssetImage("assets/images/nb_man_icon.png")).applyConstraint(left: parent.left, top: nameLabelId.bottom, width: toX(44), height: toY(48)),
        Padding(
            padding: EdgeInsets.only(left: toX(52), top: toY(8)),
            child: Text(notification.message,
                style: TextStyle(
                  color: const Color(0xFFC6C6C6),
                  fontSize: toY(14),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                ))).applyConstraint(id: messageLabelId, left: nameLabelId.left, top: nameLabelId.bottom),
        uiElements.popupMenu(_itemMenu(notification), const Image(image: AssetImage("assets/images/menu_dots.png")), BoxConstraints.tightFor(width: toX(136)), Offset(0, toY(30))).applyConstraint(id: menuLabelId, zIndex:100,right: parent.right, top: messageLabelId.top, width: toX(5), height: toY(25)),
        Padding(
            padding: EdgeInsets.only(right: toX(10)),
            child: Text(
              "  ${notification.time}",
              style: TextStyle(
                color: const Color(0xFFC6C6C6),
                fontSize: toY(12),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            )).applyConstraint(id: timeLabelId, top: nameLabelId.top, right: menuLabelId.left),
        Padding(padding: EdgeInsets.only(right: toX(20)), child: const Icon(Icons.access_time_outlined, size: 14, color: Colors.white)).applyConstraint(right: timeLabelId.left, top: timeLabelId.top, bottom: timeLabelId.bottom, width: toX(14), height: toY(14)),
        Padding(
            padding: EdgeInsets.only(left: toX(53)),
            child: const Divider(
              thickness: 1,
              height: 1,
              color: Color(0xff424242),
            )).applyConstraint(bottom: parent.bottom, left: messageLabelId.left, right: menuLabelId.left)
      ],
    );
  }

  List<PopupMenuItem> _itemMenu(CxNotification notification) {
    List<PopupMenuItem> list = <PopupMenuItem>[];
    list.add(uiElements.pageMenuItem(
        localise("share"),
        Image(
          image: const AssetImage("assets/images/share.png"),
          width: toX(20),
          height: toY(18),
        ),
        () {}));
    list.add(uiElements.pageMenuItem(
        localise("action"),
        Image(
          image: const AssetImage("assets/images/action.png"),
          width: toX(20),
          height: toY(18),
        ),
        () => applicationModel.setCurrentStateWithParams(FiApplicationStates.notificationActionWidget, notification)));
    list.add(uiElements.pageMenuItem(
        localise("dismiss"),
        Image(
          image: const AssetImage("assets/images/dismiss.png"),
          width: toX(20),
          height: toY(18),
        ),
        () {}));
    return list;
  }
}
