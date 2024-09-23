

import 'package:flutter/cupertino.dart';

class FiMultiListAction {
  VoidCallback? action ;
  ValueChanged<dynamic>? update ;

  FiMultiListAction({ this.action});

  add(String value) {
    update?.call(value) ;
  }
}