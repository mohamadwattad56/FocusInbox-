import 'dart:ui';

import 'fi_multi_list_item.dart';

class FiMultiListDataSource {
  int _single = -1 ;
  bool _showSingle = false ;

  final List<FiMultiListItem> _items = <FiMultiListItem>[];
  int get length => _showSingle ? 1 : _items.length ;

  bool get isSingleMode => _showSingle;

  bool get isNotEmpty => _items.isNotEmpty;

  add(FiMultiListItem item) => _items.add(item) ;

  insert(int index ,FiMultiListItem item){
    if(_items.length > index){
      _items.removeAt(index);
    }
    _items.insert(index, item) ;
  }

  void showSingle({required index ,required bool show}) {

    bool rebuild = _showSingle && !show ;

    _single = index ;
    _showSingle = show ;

    if(rebuild){

    }
  }

  FiMultiListItem itemAtIndex(int index) {
    if(_showSingle){
      return _items[_single];
    }
    return _items[index] ;
  }

  bool isInSingleMode(int index) {
    return index == _single && _showSingle ;
  }



  void clear() => _items.clear() ;

  void removeUpdatables(){
    _items.removeWhere((element){
      return element.isUpdatable ;
    }) ;
  }

  void enableNext(int index, bool state,{bool allAfter = false}) {
    for(int i = index ; i < _items.length ;i++) {
      if(!_items[i].enabled) {
        _items[i].setEnabled(state) ;
        if(!allAfter) {
          return;
        }
      }
    }
  }

  bool hasDisabledItems(){
    for(int i = 0 ; i < _items.length ;i++) {
      if(!_items[i].enabled) {
        return true;
      }
    }
    return false ;
  }

  bool hasDisabledItemsBeforeIndex(int index){
    for(int i = 0 ; i < (index < _items.length ? index : _items.length) ;i++) {
      if(!_items[i].enabled) {
        return true;
      }
    }
    return false ;
  }

  refreshAll({int startIndex = 0}){
    for(int i = startIndex ; i < _items.length ;i++) {
      _items[i].update() ;
    }
  }

  void collapseAll() {
    for(int i = 0 ; i < _items.length ;i++) {
      _items[i].collapsedWidget.onCollapseChange?.call(true) ;
      _items[i].expandedWidget?.onCollapsedChange?.call(true) ;
    }
  }

}