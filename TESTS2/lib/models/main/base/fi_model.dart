import 'package:flutter/cupertino.dart';

import '../../../ui/base/fi_base_state.dart';

class FiModel with WidgetsBindingObserver{

  FiBaseState? _modelState ;


  set modelState(FiBaseState? state) {
    setState(state);
  }

  setState(FiBaseState? state){
    print("Setting state in model: $state"); // Add debug output

    _modelState = state ;
    if (_modelState != null) {
      WidgetsBinding.instance.addObserver(this);
    } else {
      WidgetsBinding.instance.removeObserver(this);
    }
  }



  resetState(FiBaseState? state){
    if(state == _modelState){
      print("Resetting state in model"); // Add debug output
      _modelState = null ;
    }
  }

  FiBaseState? get modelState => _modelState ;

  update({VoidCallback? callback}) => _modelState?.updateState(callback:callback)  ;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {}
}