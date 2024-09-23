import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import 'package:image_picker/image_picker.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../../utils/cx_media_utils.dart';
import '../../../utils/fi_display.dart';
import '../../../utils/fi_resources.dart';
import '../../../utils/list/fi_multi_list_actions_data_source.dart';
import '../../../utils/list/fi_multi_list_collapsed_widget.dart';
import '../../../utils/list/fi_multi_list_expanded_widget.dart';
import '../../../utils/list/fi_multi_list_item.dart';
import '../../groups/fi_group.dart';
import '../../utils/fi_ui_elements.dart';
import '../base/cx_timeline_state.dart';
import '../base/cx_timeline_widget.dart';
import 'cx_group_timeline_model.dart';

//ignore: must_be_immutable
class CxGroupTimelineWidget extends CxTimelineWidget {
  FiGroup? group;

  CxGroupTimelineWidget({super.key});

  @override
  setParams(params) {
    super.setParams(params);
    if (params is Map<String, dynamic>) {
      group = params[kTargetGroup];
    }
  }

  @override
  State<StatefulWidget> createState() => CxGroupTimelineState();
}

late FiMultiListActionDataSource membersSource;

class CxGroupTimelineState extends CxTimelineState<CxGroupTimelineWidget> {
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
  Widget get contactInfo => uiElements.popupMenu(
      avatarMenuItems(),
      ConstraintLayout(
        width: display.width,
        height: toY(60),
        children: [
          Icon(Icons.edit, color: Colors.white, weight: toX(15)).applyConstraint(right: parent.center, top: parent.top, bottom: parent.bottom, height: matchConstraint),
          Text(
            localise("edit"),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: toY(14),
              fontFamily: 'Inter',
              fontWeight: FontWeight.w400,
              height: 0,
            ),
          ).applyConstraint(left: parent.center, top: parent.top, bottom: parent.bottom),
        ],
      ),
      BoxConstraints.tightFor(width: toX(200)),
      Offset(0, toY(40)));

  @override
  initDataSource() {
    dataSource.add(FiMultiListItem(
      fullExpandBackground: const Color(0xFF292C35),
      autoUpdateTitle: true,
      collapsedWidget: FiMultiLisCollapsedWidget(
        title: localise("group_members"),
        prefixImageName: "members.png",
        onTap: () {
          showMembers(!membersVisible);
        },
      ),
    ));
/*    if (Flavors.isBusiness) {
      dataSource.add(FiMultiListItem(
        autoUpdateTitle: true,
        collapsedWidget: FiMultiLisCollapsedWidget(
          title: localise("group_tasks"),
          prefixImageName: "my_tasks.png",
        ),
        expandedWidget: FiMultiListExpandedInputTextWidget(),
      ));
    }*/

      dataSource.add(FiMultiListItem(
        autoUpdateTitle: true,
        collapsedWidget: FiMultiLisCollapsedWidget(
          title: localise("group_insights"),
          prefixImageName: "my_insights.png",
          sufficsImageName: "menu_dots.png",
        ),
        expandedWidget: FiMultiListExpandedInputTextWidget(),
      ));

    dataSource.add(FiMultiListItem(
      isTimeline: true,
      collapsedWidget: FiMultiLisCollapsedWidget(
        onTap: () => showTimeLine(!timelineVisible),
        title: localise("group_timeline"),
        prefixImageName: "my_timeline.png",
        sufficsImage: timelineMenu,
      ),
      //expandedWidget: CxTimelineSearchWidget(model: widget.model, height: toY(100), width: display.width - toX(20),),
    ));
  }

  @override
  List<PopupMenuItem> pageMenuItems() {
    List<PopupMenuItem> list = <PopupMenuItem>[];
    list.add(uiElements.pageMenuItem(
        localise("add_new_member"),
        Icon(
          Icons.add_circle_outline,
          color: const Color(0xff9B9B9B),
          size: toX(20),
        ), () {
      FiGroup group = (widget.model as CxGroupTimelineModel).group;
      group.addMemberAction(backState: FiApplicationStates.groupTimeline).action?.call();
    }));

    list.add(uiElements.pageMenuItem(
        localise("delete_group"),
        Icon(
          Icons.delete_forever_outlined,
          color: const Color(0xff9B9B9B),
          size: toX(25),
        ),
        () {}));

    return list;
  }

  List<PopupMenuItem> avatarMenuItems() {
    List<PopupMenuItem> list = <PopupMenuItem>[];
    list.add(uiElements.pageMenuItem(
        localise("edit_image"),
        Icon(
          Icons.edit,
          color: const Color(0xff9B9B9B),
          size: toX(20),
        ), () async {
      XFile? file = await CxMediaUtils.loadGalleryImage();
      if (file != null) {

      }
    }));

    list.add(uiElements.pageMenuItem(
        localise("delete_image"),
        Icon(
          Icons.delete_forever_outlined,
          color: const Color(0xff9B9B9B),
          size: toX(25),
        ),
        () {}));

    return list;
  }
}
