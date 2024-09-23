//import 'package:connectx/utils/cx_log.dart';
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

import '../fi_display.dart';
import '../fi_resources.dart';
import 'fi_multi_list_actions_data_source.dart';
import 'fi_multi_list_expanded_widget.dart';

//ignore: must_be_immutable
class FiMultiListExpandedActionListWidget extends FiMultiListExpandedWidget {
  FiMultiListActionDataSource? actionDataSource;

  String? actionText;

  bool? isAction;

  bool keyBoardActive = true;

  FiMultiListExpandedActionListWidget({super.key, this.actionDataSource, this.actionText, this.isAction, this.keyBoardActive = true}) {
    int count = actionDataSource?.length ?? 0;
    if(count > 3) {
      count = 3 ;
    }
    super.height = toY((count + 1) * 40);
  }

  @override
  State<StatefulWidget> createState() => _FiMultiListExpandedActionListState();
}

class _FiMultiListExpandedActionListState extends State<FiMultiListExpandedActionListWidget> {
  @override
  void initState() {
    widget.actionDataSource?.onUpdate = () {
      setState(() {
        int count = widget.actionDataSource?.length ?? 0;
        widget.height = toY((count + 1) * 40);
        widget.onRefresh?.call();
      });
    };

    super.initState();
    if (!widget.keyBoardActive) {
      widget.onKeyboardVisibilityChanged = null;
    }
  }
  final _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    int count = widget.actionDataSource?.length ?? 0;

    // widget.height = toY((count + 1) * 60);
    return Container(
        // width: toX(widget.width ?? display.width),
        height: toY((count + 1) * 40),
        decoration: ShapeDecoration(
          color: widget.fullExpandBackground ?? const Color(0xFF767B80),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(toX(12.84)),
              bottomRight: Radius.circular(toX(12.84)),
            ),
          ),
        ),
        child: ListView.builder(
            controller: _scrollController,
            padding: EdgeInsets.zero,
            itemCount: count + (widget.isAction ?? true ? 1 : 0),
            itemBuilder: (BuildContext context, int index) {
              if (widget.isAction ?? true && index == count) {
                return Padding(padding: EdgeInsets.only(left: toX(10)), child: _addAction(widget.actionDataSource?.action.action));
              } else {
                return _listItem(index);
              }
            }));
  }

  Widget _addAction(VoidCallback? onTapAdd) {
    ConstraintId imageId = ConstraintId("action_${hashCode}_imageId_$hashCode");
    return GestureDetector(
        onTap: onTapAdd,
        child: Padding(
            padding: EdgeInsets.only(top: toY(0)),
            child: ConstraintLayout(
              width: matchParent,
              height: toY(40),
              children: [
                Padding(padding: EdgeInsets.only(left: toX(15), bottom: toY(20)), child: const Image(image: AssetImage("assets/images/nice_plus.png"))).applyConstraint(id: imageId, left: parent.left, top: parent.top, bottom: parent.bottom, width: toX(42), height: toY(64)),
                Padding(
                    padding: EdgeInsets.only(left: toX(0), bottom: toY(0)),
                    child: Text(
                      widget.actionText ?? localise("add_more"),
                      style: TextStyle(
                        color: const Color(0xFF88898C),
                        fontSize: toY(16),
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                      ),
                    )).applyConstraint(left: imageId.right, top: parent.top, bottom: parent.bottom, height: matchConstraint),
              ],
            )));
  }

  Widget _listItem(int index) {
    ConstraintId titleId = ConstraintId("item_${hashCode}_imageId_$index");
    ConstraintId buttonId = ConstraintId("item_${hashCode}_buttonId_$index");
    ConstraintId guideLineId = ConstraintId("item_${hashCode}_guideLineId_$index");
    ConstraintId guideLineId2 = ConstraintId("item_${hashCode}_guideLineId2_$index");
    return Padding(
        padding: EdgeInsets.only(left: toX(10), right: toX(10)),
        child: ConstraintLayout(
          width: matchParent,
          height: toY(40),
          children: [
            Guideline(
              id: guideLineId,
              guidelinePercent: 0.9,
            ),
            Guideline(
              id: guideLineId2,
              guidelinePercent: 0.13,
            ),


            Text(
              overflow: TextOverflow.ellipsis,
              widget.actionDataSource?.items?[index] ?? "",
              style: TextStyle(

                color: Colors.white,
                fontSize: toY(16),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
              ),
            ).applyConstraint(
                id: titleId,
                left: guideLineId2.right,
                right: guideLineId.left,
                top: parent.top,
                bottom: parent.bottom,
                width: matchConstraint
            ),

            GestureDetector(
                onTap: (){
                //  logger.d("Delete index: $index");
                  widget.actionDataSource?.delete?.call(widget.actionDataSource?.items?[index]) ;
                },
                child:Padding(
                padding: EdgeInsets.only(
                    right: toX(0),bottom:toY(0),),
                    child:  Icon(
                      Icons.remove_circle,
                      color: Colors.white,
                      size: toX(23),
                    ))).applyConstraint(id:buttonId,zIndex:100,left:guideLineId.right,right: parent.right, top: titleId.top, bottom: titleId.bottom,width: toX(44))
            //
          ],
        ));
  }
}
