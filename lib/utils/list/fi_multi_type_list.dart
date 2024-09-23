//import 'package:connectx/utils/cx_log.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../fi_display.dart';
import 'fi_multi_list_data_source.dart';
import 'fi_multi_list_expanded_widget.dart';
import 'fi_multi_list_item.dart';

class FiMultiTypeList extends StatefulWidget {
  ScrollController? controller;
  bool? isSingleInputTypeEnabled ;
  FiMultiListDataSource dataSource = FiMultiListDataSource();
  List<int>? indexesOfItemsToForceVisibility = <int>[];
  FiMultiTypeList({super.key, required this.dataSource, this.controller,this.indexesOfItemsToForceVisibility,this.isSingleInputTypeEnabled});

  @override
  State<StatefulWidget> createState() => FiMultiTypeListState();


}

class FiMultiTypeListState extends State<FiMultiTypeList> {
  int expandedItemIndex = -1;

  FiMultiListItem? expanded;

  @override
  void initState() {
    widget.controller ??= ScrollController();
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        controller: widget.controller,
        padding: EdgeInsets.zero,
        itemCount: widget.dataSource.length,
        itemBuilder: (BuildContext context, int index) {
          FiMultiListItem item = widget.dataSource.itemAtIndex(index);

          item.expandedWidget?.onKeyboardVisibilityChanged = (state) {
            if (!state) {
              setState(() {
                //expanded?.collapse();
                if (widget.dataSource.isSingleMode) {
                  widget.dataSource.showSingle(index: index, show: false);
                  if (index + 1 == widget.dataSource.length && widget.controller != null) {
                    widget.controller?.animateTo(
                      widget.controller!.position.maxScrollExtent + toY(60),
                      curve: Curves.easeOut,
                      duration: const Duration(milliseconds: 300),
                    );
                  }
                }
              });
              _onItemClick(index);
              //widget.dataSource.refreshAll() ;
            }
          };

          if(widget.isSingleInputTypeEnabled??true) {
            if (item.expandedWidget != null && item.expandedWidget is FiMultiListExpandedInputTextWidget) {


              item.expandedWidget!.onTextBoxClick = () {
                setState(() {
                  if (!widget.dataSource.isInSingleMode(index)) {
                    widget.dataSource.showSingle(index: index, show: true);
                  }
                });
              };
            }

          }
          else {
            item.expandedWidget?.inFocus = true ;
          }
          item.onCollapsedItemClick = () {
            _onItemClick(index);
          };
          if(item.isOpen){
            _onItemClick(index);
            item.isOpen = false ;
          }
          return Padding(padding: EdgeInsets.only(top: toY(10)), child: item);
        });
  }

  void collapseAll() {
    widget.dataSource.collapseAll() ;
    expanded = null ;
  }

  void _onItemClick(int index) {
    if (widget.dataSource.isSingleMode) return;

    FiMultiListItem clicked = widget.dataSource.itemAtIndex(index);
    if (clicked == expanded) {
      expanded?.collapse();
      expanded = null;
    } else {
      expanded?.collapse();
      clicked.expand();
      expanded = clicked;
      if(widget.dataSource.length > 6) {
        if (widget.indexesOfItemsToForceVisibility?.contains(index) ?? false) {
          widget.controller?.animateTo(
            widget.controller!.position.maxScrollExtent + toY(60),
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
        else if (index + 1 == widget.dataSource.length && widget.controller != null) {
          widget.controller?.animateTo(
            widget.controller!.position.maxScrollExtent + toY(60),
            curve: Curves.easeOut,
            duration: const Duration(milliseconds: 300),
          );
        }
      }
    }
  }
}
