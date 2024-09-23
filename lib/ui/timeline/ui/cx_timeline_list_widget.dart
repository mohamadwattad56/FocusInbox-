
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

import '../../../backend/models/cx_timeline_item.dart';
import '../base/fi_timeline_model.dart';
import 'cx_social_item.dart';



class CxTimelineListWidget extends StatefulWidget {
  final FiTimelineModel model;

  const CxTimelineListWidget({super.key, required this.model});

  @override
  State<StatefulWidget> createState() => _CxTimelineListState();
}

class _CxTimelineListState extends State<CxTimelineListWidget> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    int count = 10 ;//widget.model.count;
    return ListView.builder(
        controller: _scrollController,
        itemCount: count,
        itemBuilder: (BuildContext context, int index) {
          return item(index);
        }) ;


  }

  Widget item(int index){
    FiTimelineItem item = FiTimelineItem();//widget.model.itemAtIndex(index) ;
    return FiSocialItemUx(item: item);
    // switch(item.type){
    //   case CxTimelineItemType.calendar :
    //     return CxSocialItemUx(item: item);
    //   default:   return Container() ;
    // }

    //return CxCalendarItem(item: widget.model.itemAtIndex(index),);
  }
}
