import 'package:flutter/cupertino.dart';

import '../../../utils/fi_resources.dart';
import '../../../utils/list/cx_expanded_groups_list.dart';
import '../../../utils/list/fi_multi_list_collapsed_widget.dart';
import '../../../utils/list/fi_multi_list_expanded_widget.dart';
import '../../../utils/list/fi_multi_list_item.dart';
import '../base/cx_timeline_state.dart';
import '../base/cx_timeline_widget.dart';

//ignore: must_be_immutable
class CxMineTimelineWidget extends CxTimelineWidget {


  CxMineTimelineWidget({super.key});


  @override
  State<StatefulWidget> createState() => CxMineTimelineState();

}

class CxMineTimelineState extends CxTimelineState<CxMineTimelineWidget>{





  @override
  @protected
  initDataSource() {
    if(!timelineVisible) {
      dataSource.insert(0, FiMultiListItem(
        autoUpdateTitle: true,
        collapsedWidget: FiMultiLisCollapsedWidget(
          title: localise("my_groups"),
          prefixImageName: "groups_symbol.png",
        ),
        expandedWidget: FiMultiListExpandedGroupsList(groups: widget.model.groups, callback: widget.model.showGroupTimeline),
      ));

      dataSource.insert(1, FiMultiListItem(
        autoUpdateTitle: true,
        collapsedWidget: FiMultiLisCollapsedWidget(
          title: localise("my_tasks"),
          prefixImageName: "my_tasks.png",
        ),
        expandedWidget: FiMultiListExpandedInputTextWidget(),
      ));

      dataSource.insert(2, FiMultiListItem(
        autoUpdateTitle: true,
        collapsedWidget: FiMultiLisCollapsedWidget(
          title: localise("my_insights"),
          prefixImageName: "my_insights.png",
          sufficsImageName: "menu_dots.png",
        ),
        expandedWidget: FiMultiListExpandedInputTextWidget(),
      ));
    }

      dataSource.add(FiMultiListItem(
        isTimeline: true,
        collapsedWidget: FiMultiLisCollapsedWidget(
          onTap: () => showTimeLine(!timelineVisible),
          title: localise("my_timeline"),
          prefixImageName: "my_timeline.png",
          sufficsImage: timelineMenu,
        ),
        //expandedWidget: CxTimelineSearchWidget(model: widget.model, height: toY(100), width: display.width - toX(20),),
      ));

  }
}