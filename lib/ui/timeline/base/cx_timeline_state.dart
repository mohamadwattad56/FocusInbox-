
import 'package:flutter/material.dart';

import '../../../models/main/fi_main_model.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../../utils/fi_display.dart';
import '../../../utils/fi_resources.dart';
import '../../../utils/list/fi_multi_list_collapsed_widget.dart';
import '../../../utils/list/fi_multi_list_data_source.dart';
import '../../../utils/list/fi_multi_list_item.dart';
import '../../../utils/list/fi_multi_type_list.dart';
import '../../../utils/list/fi_timeline_search_widget.dart';
import '../../base/fi_base_state.dart';
import '../../utils/fi_ui_elements.dart';
import '../ui/cx_timeline_list_widget.dart';
import '../ui/cx_timeline_members_widget.dart';
import 'cx_timeline_widget.dart';

//CxBaseState<T extends CxBaseWidget> extends State<T>
class CxTimelineState<T extends CxTimelineWidget> extends FiBaseState<T> {
  final FiMultiListDataSource dataSource = FiMultiListDataSource();

  bool timelineVisible = false;
  bool membersVisible = false;

  @override
  void initState() {
    widget.onWillPopCallBack = () async {
      if (timelineVisible) {
        showTimeLine(false);
        return;
      }
      if (membersVisible) {
        showMembers(false);
        return;
      }
      widget.onWillPopCallBack = null;
      await widget.onWillPop;
    };
    widget.model.setState(this);
    initDataSource();
    super.initState();
  }

  @protected
  initDataSource() {}

  clearDataSource() {
    dataSource.clear();
  }

  Widget get timelineMenu {
    return uiElements.popupMenu(<PopupMenuItem>[
      uiElements.pageMenuItem(
          localise("filter_by"),
          Image(
            image: const AssetImage("assets/images/filter_by.png"),
            width: toX(20),
            height: toY(18),
          ), () {
        applicationModel.setCurrentStateWithParams(FiApplicationStates.timelineFilter, {kBackState: widget.model.backState});
      }),
      uiElements.pageMenuItem(
          localise("clear_filter"),
          Image(
            image: const AssetImage("assets/images/clear_filter.png"),
            width: toX(20),
            height: toY(18),
          ),
          widget.model.clearFilters),
      uiElements.pageMenuItem(
          localise("collapse"),
          Image(
            image: const AssetImage("assets/images/collapse.png"),
            width: toX(20),
            height: toY(18),
          ), () {
        setState(() {
          showTimeLine(false);
        });
      })
    ], Image(image: const AssetImage("assets/images/menu_dots.png"), width: toX(32), height: toX(32)), BoxConstraints.tightFor(width: toX(165)), Offset(0, toY(40)));
  }

  @override
  void dispose() {
    widget.model.setState(null);
    widget.timelineItem = null;
    membersVisible = false;
    timelineVisible = false;
    super.dispose();
  }

  @override
  Widget get content {
    if (timelineVisible) {
      return contentTimeline;
    } else if (membersVisible) {
      return contentMembers;
    }
    return Stack(
      children: [
        uiElements.backButton(() async {
          await widget.onWillPop;
        }),

          Positioned(
              top: toY(112),
              left: toX(155),
              width: toX(105),
              height: toX(105),
              child: CircleAvatar(
                radius: toX(131 / 2),
                backgroundColor: const Color(0xff0677E8),
                child: CircleAvatar(radius: toX(129 / 2), backgroundColor: const Color(0xff292C35), child: ClipOval(child: widget.model.logo)),
              )),
        if (widget.model.pageMenuSupported) Positioned(top: toY(60), left: toX(363), width: toX(41), height: toX(41), child: uiElements.popupMenu(pageMenuItems(), Image(image: const AssetImage("assets/images/menu_dots.png"), width: toX(32), height: toX(32)), BoxConstraints.tightFor(width: toX(200)), Offset(0, toY(40)))),
        Positioned(
            top: toY(widget.model.logoVisible ? 230 : 112),
            left: toX(35),
            right: toX(35),
            child: Center(
                child: Text(
              overflow: TextOverflow.ellipsis,
              widget.model.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(27),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ))),
        Positioned(top: toY(widget.model.logoVisible ? 272 : 162), left: 0, right: 0, child: contactInfo),
        Positioned(top: toY(widget.model.logoVisible ? 342 : 232), left: toX(0), right: toX(0), bottom: toY(20), child: items),

      ],
    );
  }

  Widget get contentTimeline {
    return Stack(
      children: [
        uiElements.backButton(() async {
          await widget.onWillPop;
        }),
        if (widget.model.pageMenuSupported) Positioned(top: toY(60), left: toX(363), width: toX(41), height: toX(41), child: uiElements.popupMenu(pageMenuItems(), Image(image: const AssetImage("assets/images/menu_dots.png"), width: toX(32), height: toX(32)), BoxConstraints.tightFor(width: toX(200)), Offset(0, toY(40)))),
        Positioned(
            top: toY(90),
            left: toX(35),
            right: toX(35),
            child: Center(
                child: Text(
              overflow: TextOverflow.ellipsis,
              widget.model.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(27),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ))),
        //Positioned(top: toY(widget.model.logoVisible ? 272 : 162), left: 0, right: 0, child: contactInfo),
        Positioned(
            top: toY(151),
            left: toX(0),
            right: toX(0),
            bottom: toY(20),
            child: Stack(
              children: [
                Positioned(
                    top: toY(10),
                    left: toX(20),
                    right: toX(20),
                    height: toY(60),
                    child: FiMultiListItem(
                      collapsedWidget: FiMultiLisCollapsedWidget(
                        isDirectTapAllowed: true,
                        onTap: () => showTimeLine(!timelineVisible),
                        title: widget.model.timelineName,
                        prefixImageName: "my_timeline.png",
                        sufficsImage: timelineMenu,
                      ),
                      //expandedWidget: CxTimelineSearchWidget(model: widget.model, height: toY(100), width: display.width - toX(20),),
                    )),
                Positioned(top: toY(165), left: toX(20), right: toX(20), bottom: 0, child: CxTimelineListWidget(model: widget.model)),
                Positioned(top: toY(70), left: toX(20), right: toX(20), height: toY(110), child: Container(color: const Color(0xFF131621))),
                Positioned(top: toY(70), left: toX(20), right: toX(20), height: toY(100), child: FiTimelineSearchWidget(model: widget.model, type: FiTimelineSearchType.timelineSearch)),
              ],
            )),
      ],
    );
  }

  Widget get contentMembers {
    return Stack(
      children: [
        uiElements.backButton(() async {
          await widget.onWillPop;
        }),
        if (widget.model.pageMenuSupported) Positioned(top: toY(60), left: toX(363), width: toX(41), height: toX(41), child: uiElements.popupMenu(pageMenuItems(), Image(image: const AssetImage("assets/images/menu_dots.png"), width: toX(32), height: toX(32)), BoxConstraints.tightFor(width: toX(200)), Offset(0, toY(40)))),
        Positioned(
            top: toY(90),
            left: toX(35),
            right: toX(35),
            child: Center(
                child: Text(
              overflow: TextOverflow.ellipsis,
              widget.model.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(27),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ))),
        Positioned(
            top: toY(126),
            left: toX(35),
            right: toX(35),
            child: Center(
                child: Text(
              localise("members"),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: toY(20),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                height: 0,
              ),
            ))),
        Positioned(
            top: toY(157),
            left: toX(35),
            right: toX(35),
            child: Center(
                child: Text(
              "${widget.model.members.length} ${localise("members")}",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF666666),
                fontSize: toX(15),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0,
              ),
            ))),
        Positioned(
            top: toY(190),
            left: toX(0),
            right: toX(0),
            bottom: toY(20),
            child: Stack(
              children: [
                Positioned(
                    top: toY(10),
                    left: toX(20),
                    right: toX(20),
                    height: toY(60),
                    child: FiMultiListItem(
                      collapsedWidget: FiMultiLisCollapsedWidget(
                        isDirectTapAllowed: true,
                        onTap: () => showMembers(!membersVisible),
                        title: localise("group_members"),
                        prefixImageName: "groups_symbol.png",
                        sufficsImage: timelineMenu,
                      ),
                      //expandedWidget: CxTimelineSearchWidget(model: widget.model, height: toY(100), width: display.width - toX(20),),
                    )),
                Positioned(top: toY(165), left: toX(20), right: toX(20), bottom: 0, child: CxTimelineMembersWidget(model: widget.model)),
                Positioned(top: toY(70), left: toX(20), right: toX(20), height: toY(110), child: Container(color: const Color(0xFF131621))),
                Positioned(
                    top: toY(95),
                    left: toX(43),
                    right: toX(43),
                    height: toY(100),
                    child: FiTimelineSearchWidget(
                      model: widget.model,
                      type: FiTimelineSearchType.membersSearch,
                    )),
              ],
            ))
      ],
    );
  }

  List<PopupMenuItem> pageMenuItems() {
    List<PopupMenuItem> list = <PopupMenuItem>[];

    return list;
  }

  @protected
  Widget get contactInfo => SizedBox(
      width: display.width,
      height: 60,
      child: Stack(
        children: [
          Positioned(
              top: toY(0),
              left: 0,
              right: 0,
              child: Center(
                  child: Opacity(
                opacity: 0.52,
                child: Text(
                  widget.model.name,
                  style: TextStyle(
                    color: const Color(0xFFE5E4E8),
                    fontSize: toY(14),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))),
          Positioned(
              top: toY(21),
              left: 0,
              right: 0,
              child: Center(
                  child: Opacity(
                opacity: 0.52,
                child: Text(
                  widget.model.phone,
                  style: TextStyle(
                    color: const Color(0xFFE5E4E8),
                    fontSize: toY(14),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ))),
          Positioned(
              top: toY(40),
              left: 0,
              right: 0,
              child: Center(
                  child: Opacity(
                opacity: 0.52,
                child: Text(
                  widget.model.occupation,
                  style: TextStyle(
                    color: const Color(0xFFE5E4E8),
                    fontSize: toY(14),
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )))
        ],
      ));

  @protected
  Widget get items {
    return FiMultiTypeList(dataSource: dataSource);
  }

  @protected
  showTimeLine(bool state) {
    setState(() {
      timelineVisible = state;
      if (timelineVisible) {
        clearDataSource();
      } else {
        initDataSource();
      }
      // initDataSource();
    });
  }

  @protected
  showMembers(bool state) {
    setState(() {
      membersVisible = state;
      if (membersVisible) {
        clearDataSource();
      } else {
        initDataSource();
      }
      // initDataSource();
    });
  }
}
