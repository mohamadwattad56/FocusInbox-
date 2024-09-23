
import 'package:flutter/material.dart';
import '../../utils/fi_display.dart';
import '../dialogs/fi_dialog.dart';
import 'fi_base_widget.dart';

typedef DialogWidget = Widget Function(BuildContext context, StateSetter setState);

class FiBaseState<T extends FiBaseWidget> extends State<T> {


  static BuildContext? currentContext ;
  FiDialogWidget? _dialog ;
  StateSetter? dialogStateState ;
  @override
  Widget build(BuildContext context) {
    currentContext = context ;
    Widget widget =  Container(
      width: display.width,
      height: display.height,
      clipBehavior: Clip.antiAlias,
      decoration:ShapeDecoration(
        color: const Color(0xff141620),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(toX(0)),
        ),
      ) ,
      child: SizedBox(
          width: display.width,
          height: display.height,
          child: Stack(children: [
            content,
            if(_dialog != null) Positioned(
                left: _dialog!.left,
                top:  _dialog!.top,
                width: _dialog!.width,
                height: _dialog!.height,
                child: _dialog!.dialog)
          ],)
      ),
    ) ;

    return widget ;
  }

  @protected
  showPopupDialog(FiDialogWidget dialog){
    showDialog(
      context: currentContext!,
      builder: (BuildContext context) {
        return SimpleDialog(
          insetPadding: EdgeInsets.only(bottom: display.height - (dialog.height + dialog.top)),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          children: [
            SizedBox(
              width: dialog.width,
              height: dialog.height,
              child:  dialog.dialog,
            ),
          ],
        );
      },
    );
  }



  @protected
  showPopupInputDialog(FiDialogWidget dialog){
    showDialog(
      context: currentContext!,
      builder: (BuildContext context) {
        return SimpleDialog(
          insetPadding: EdgeInsets.only(bottom: display.height - (dialog.height + dialog.top)),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          children: [
            dialog.dialog,
          ],
        );
      },
    );
  }

  showAlertDialog(Widget dialog ,double width, double height,{bool dismissable = true}){
    showDialog(
      barrierDismissible:dismissable,
      context: currentContext!,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.only(bottom: display.height/2 - height/2),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
              builder:(BuildContext context, StateSetter setState){
                return dialog ;
              }),
        )  ;
      },
    );
  }

  showStateFullAlertDialog(double width, double height,DialogWidget widget,{bool dismissable = true}){
    showDialog(
      barrierDismissible:dismissable,
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.only(bottom: display.height/2 - height),
          titlePadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: StatefulBuilder(
              builder:(BuildContext context, StateSetter setState) =>  widget(context,setState)),
        )  ;
      },
    );
  }



  hidePopupDialog(){
    if(_dialog != null){
      setState(() {
        _dialog = null ;
      });
    }
  }

  ///
  /// Will rebuild this widget
  updateState({VoidCallback? callback}){
    print("Calling updateState ${State}"); // Debug output
    setState(() {
      callback?.call() ;
      print("State updated ${State}"); // Confirm state update

    });
  }

  @protected Color get backgroundColor => const Color(0xff131621) ;



  @protected Widget get content => Container() ;


}
