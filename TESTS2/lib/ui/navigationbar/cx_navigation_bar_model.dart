
import 'package:FocusInbox/ui/navigationbar/settings/fi_settings_tab_widget.dart';
import 'package:flutter/cupertino.dart';

import '../../models/main/base/fi_model.dart';
import '../base/fi_base_state.dart';
import 'ai/fi_ai_model.dart';
import 'ai/fi_ai_tab_widget.dart';
import 'contacts/fi_contacts_tab_widget.dart';
import 'home/cx_home_screen_tab_widget.dart';
import 'notifications/cx_notification_tab_widget.dart';





class CxNavigationBarModel extends FiModel {
  static final CxNavigationBarModel _instance = CxNavigationBarModel._internal();
  int _selectedIndex = 0 ;
  int _lastSelectedIndex = 0 ;
  final Map<int,Widget> _tabs = {};


  CxNavigationBarModel._internal();

  factory CxNavigationBarModel() {
    return _instance;
  }

  int get selectedIndex => _selectedIndex;

  VoidCallback get closeAiDialog => (){
    update(callback: (){
      ai.clear();
      _selectedIndex = _lastSelectedIndex ;
      _lastSelectedIndex = _selectedIndex ;
    });
  };

  set selectedIndex(int value) {
    update(callback: (){
      _selectedIndex = value;
    }) ;

  }

  @override
  setState(FiBaseState? state){
    super.setState(state) ;
    if(state != null) {
      _tabs[1] = const FiHomeScreenTabWidget();
      _tabs[0] = const FiContactsTabWidget();
      _tabs[2] = const FiAiTabWidget();
      _tabs[3] = const CxNotificationsTabWidget();
      _tabs[4] = const FiSettingsTabWidget();
    }
    else {
      _tabs.clear() ;
    }
  }



  Widget get tabAtIndex => _selectedIndex < _tabs.length ? _tabs[_selectedIndex]! : Container();

  void onTabClick(int i) {
    update(callback: (){
      if(_selectedIndex != i){
        _lastSelectedIndex = _selectedIndex ;
        _selectedIndex = i ;
      }
    });
  }

}

CxNavigationBarModel navigationBar = CxNavigationBarModel();