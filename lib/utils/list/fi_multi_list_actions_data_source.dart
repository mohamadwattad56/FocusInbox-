
import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'fi_multi_list_action.dart';

class FiMultiListActionDataSource {

  List<String>? items ;
  FiMultiListAction action ;
  ValueChanged<dynamic>? delete ;
  int get length => items?.length??0 ;

  VoidCallback? onUpdate ;

  FiMultiListActionDataSource({required this.action,this.items,this.delete}){
    action.update = (value){
      add(value);
    };
  }


  add(String item){
     items?.add(item) ;
     if(onUpdate != null) {
       onUpdate!.call();
     }
  }

  void remove(item) {
    items?.removeWhere((element) => element == item) ;
    if(onUpdate != null) {
      onUpdate!.call();
    }
  }

}