import 'package:flutter/cupertino.dart';

import 'fi_base_state.dart';


///
/// Base widget implementation
/// All UI components in the App should inheritance from this class
class FiBaseWidget extends StatefulWidget {

  const  FiBaseWidget({super.key});

  Future<bool> get onWillPop {
    return Future.value(false);
  }

  setParams(dynamic params){}

  @override
  State<StatefulWidget> createState() => FiBaseState();
}

