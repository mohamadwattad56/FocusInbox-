import 'package:flutter/cupertino.dart';

import '../../models/main/base/fi_model.dart';
import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../groups/fi_group.dart';
import '../timeline/group/cx_group_timeline_model.dart';
import '../utils/fi_ui_elements.dart';

class CxCustomGroupsModel extends FiModel {
  static final CxCustomGroupsModel _instance = CxCustomGroupsModel._internal();
  final TextEditingController _searchController = TextEditingController();
  bool inSearch = false;
  final List<FiGroup> _list = <FiGroup>[] ;
  final List<FiGroup> _searched = <FiGroup>[] ;

  CxCustomGroupsModel._internal();

  factory CxCustomGroupsModel() {
    return _instance;
  }

  bool get isNotEmpty => _list.isNotEmpty;

  TextEditingController get groupSearchController => _searchController;

  ValueChanged<String> get onSearch => (text){
    if(text.trim().isEmpty){
      update(callback: (){
        _searched.clear();
        inSearch = false ;
      }) ;
    }
    Iterable<FiGroup> result = _list.where((element) => element.name!.toLowerCase().contains(text.toLowerCase())) ;
    update(callback: (){
      inSearch = result.isNotEmpty ;
      _searched.clear();
      _searched.addAll(result);
    }) ;
  };
  
  VoidCallback get stopSearch => (){
    update(callback: (){
      _searched.clear();
      inSearch = false ;
    }) ;
  } ;

  int get groupCount => inSearch ? _searched.length : _list.length;

  bool get isEmpty => _list.isEmpty;

  List<FiGroup> get allGroups => _list;



  FiGroup groupAtIndex(int i) {
    return inSearch ? _searched[0]: _list[i] ;
  }

  void showTimeLineForGroup(FiGroup group) {
    CxGroupTimelineModel timelineModel = CxGroupTimelineModel(group: group);
    applicationModel.setCurrentStateWithParams(FiApplicationStates.groupTimeline, {kBackState:FiApplicationStates.customGroupsList,kTimeline:timelineModel}) ;
  }

  void addGroup(FiGroup group) {
    _list.add(group) ;
  }
  
}

CxCustomGroupsModel customGroupsModel = CxCustomGroupsModel();