
import 'package:flutter/cupertino.dart';



class FiDialogWidget {
  final Widget _dialog ;
  double left, top,width,height ;
  bool dismissable = true ;

  FiDialogWidget(this._dialog,{required this.left,required this.top,required this.width,required this.height, this.dismissable = true}) ;

  Widget get dialog  => _dialog ;
}


