import 'package:flutter/material.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import'fi_registration_widget.dart';
import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import '../launching/fi_launching_model.dart';
import '../utils/fi_ui_elements.dart';
import 'fi_registration_model.dart';

class FiUserFailedLoginWidget extends FiBaseWidget {
  const FiUserFailedLoginWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FiUserFailedLoginWidgetState();
}

class _FiUserFailedLoginWidgetState extends FiBaseState<FiUserFailedLoginWidget>
{
  @override
  void initState() {
    super.initState();
    registrationModel.setState(this);

  }

  @override
  void dispose() {
  //  registrationModel.setState(this);
    super.dispose();
  }


  @override
  Widget get content => Stack(
      children: [
      Positioned(
          top: toY(115),
          left: 0,
          right: 0,
          child: Center(
              child: Image(image: const AssetImage("assets/images/email_logo.png"),
                  width: toX(122),
                  height: toX(125)))
      ),
        Positioned(
            top: toY(277),
            left: 0,
            right: 0,
            child: Text(
              localise("whatsapp_authentication"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: const Color.fromRGBO(255, 255, 255, 1),
                  fontSize: toY(30),
                  fontWeight: FontWeight.bold,
                  height: 1.5
              ),
            )),
        Positioned(
            top: toY(515),
            left: 0,
            right: 0,
            child: Text(
              localise("authentication_failed_explanation"),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color:const Color.fromRGBO(0x94, 0x94, 0x94, 1.0),
                  fontSize: toY(18),
                //  fontWeight: FontWeight.bold,
                  height: 1.5
              ),
            )),
        Positioned(
            left: display.width / 2 - toX(343.9997) / 2,
            bottom: toY(30),
            width: toX(343.9997),
            height: toY(65.5238),
            child: uiElements.button(localise("try_again"),
               registrationModel.onRegistrationBackFromFail,
               // launchingModel.askPermission,
                enabled: true,
                progressVisible: (registrationModel.isRegistrationInProgress))
        )

  ]
  );


}