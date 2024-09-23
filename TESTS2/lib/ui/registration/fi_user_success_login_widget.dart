
import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';

import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import '../utils/fi_ui_elements.dart';
import 'fi_registration_model.dart';

class FiUserSuccessLoginWidget extends FiBaseWidget {
  const FiUserSuccessLoginWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FiUserSuccessLoginWidgetState();
}

class _FiUserSuccessLoginWidgetState extends FiBaseState<FiUserSuccessLoginWidget> {


  @override
  void initState() {
    super.initState();
    registrationModel.setState(this);
  }

  @override
  void dispose() {
    registrationModel.setState(null);
    super.dispose();
  }

  @override

  Widget get content => Stack(
        children: [
          Positioned(
              top: toY(198),
              left: 0,
              right: 0,
              child: Center(child: Image(
                  image: const AssetImage("assets/images/_success_login_icon.png"),
                  width: toX(250),
                  height: toX(250)))
          ),
          Positioned(
              top: toY(507),
              left: 0,
              right: 0,
              child: Center(
                child: Text(localise("congrats"),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: const Color.fromRGBO(255, 255, 255, 1), fontSize: toY(45), fontWeight: FontWeight.bold, height: 1.5 /*PERCENT not supported*/
                        )),
              )),
          Positioned(
              top: toY(584),
              left: 0,
              right: 0,
              child: Text(
                localise("account_created_successfully"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xBFACADB9),
                  fontSize: toY(18),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w400,
                  height: 1.28,
                  letterSpacing: 0.54,
                ),
              )),
          Positioned(
              top: toY(746),
              left: toX(115),
              right:toX(115),
              child: uiElements.button(localise("get_started"), () {
               applicationModel.currentState = FiApplicationStates.navigationScreen ;
          }))
        ],
      );
}
