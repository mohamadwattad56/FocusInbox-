import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

import '../../ui/groups/fi_group.dart';
import '../fi_display.dart';
import 'fi_multi_list_expanded_widget.dart';


//ignore: must_be_immutable

typedef OnGroupListItemClickCallback = void Function(dynamic item);

//ignore: must_be_immutable
class FiMultiListExpandedGroupsList extends FiMultiListExpandedWidget {
  List<FiGroup> groups;
  OnGroupListItemClickCallback callback;

  FiMultiListExpandedGroupsList({super.key, required this.groups, required this.callback}){
    int rowsCount = (groups.length /4).round() ;
    rowsCount = min(rowsCount, 3) ;
    height = rowsCount*toY(90) +  toY(90) ;
  }

  @override
  State<StatefulWidget> createState() => _CxMultiListExpandedGroupsList();
}

class _CxMultiListExpandedGroupsList extends State<FiMultiListExpandedGroupsList> {
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _scrollController,
        thumbVisibility: true,
        child: GridView.builder(
      shrinkWrap: true,
      itemCount: widget.groups.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
      ),
      itemBuilder: (BuildContext context, int index) {
        FiGroup group = widget.groups[index];
        ConstraintId logoId = ConstraintId("logo_${index}_${group.name}");
        return InkWell(
            onTap: () {
              widget.callback.call(group);
            },
            child: ConstraintLayout(
              width: toX(35),
              height: toX(45),
              children: [
                group.logoWithSize(size: 50,fontSize: 18,scale: 2).applyConstraint(id: logoId, left: parent.left, right: parent.right, top: parent.top, width: toX(50), height: toX(50)),
                Padding(padding: EdgeInsets.only(top:toY(5)),child:Text(
                  group.name!,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: toY(10),
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w400,
                  ),
                )).applyConstraint(left: parent.left, right: parent.right, top: logoId.bottom)
              ],
            ));
      },
    ));
  }
}
