import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_constraintlayout/flutter_constraintlayout.dart';
import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import '../utils/fi_ui_elements.dart';
import 'fi_registration_model.dart';

class FiRegistrationWidget extends FiBaseWidget {
  const FiRegistrationWidget({super.key});

  @override
  State<StatefulWidget> createState() => _FiRegistrationState();
}

class _FiRegistrationState extends FiBaseState<FiRegistrationWidget> {
  @override
  void initState() {
    super.initState();
    registrationModel.setState(this);
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  @protected
  Widget get content {
    return Stack(
      children: [

        Positioned(
            left: 0,
            right:0,
            top: toY(171.81),
            child: Center(child:Text(localise("welcome_to"),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: toY(38),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  letterSpacing: -1.52,
                    height: toY(1.2)
                )))),

        Positioned(
  left: toX(35),
  right: toX(35),
  top: toY(309),
  child: Center(
    child: uiElements.inputFieldE(
      controller: registrationModel.firstNameController,
      onChange: registrationModel.onUserFirstNameChange,
      prefixIcon: FiUiElements.inputNameIcon,
      hintText: localise("enter_your_first_name"),
      hintStyle: const TextStyle(
        color: Color(0xFFC2C3CB),
        fontSize: 14,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500,
        letterSpacing: -0.28,
      ),
      keyboardType: TextInputType.name, // Optionally specify the keyboard type for better user experience
      inputType: InputType.firstName, // Specify the input type
      context: context, // Pass the BuildContext necessary for SnackBar
    )
  )
),
  Positioned(
            left: toX(35),
            right: toX(35),
            top: toY(398),
            child: Center(
                child: uiElements.inputFieldE(
                  controller: registrationModel.lastNameController,
                  onChange: registrationModel.onUserLastNameChange,
                  prefixIcon: FiUiElements.inputNameIcon,
                  hintText: localise("enter_your_last_name"),
                  hintStyle: const TextStyle(
                    color: Color(0xFFC2C3CB),
                    fontSize: 14,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.28,
                  ),
                  keyboardType: TextInputType.name, // Optionally specify the keyboard type for better user experience
                  inputType: InputType.lastName, // Specify the input type
                  context: context, // Pass the BuildContext necessary for SnackBar
                )
            )
        ),

        Positioned(
            left: toX(35),
            right: toX(35),
            top: toY(488),

            child: Center(child: uiElements.inputFieldE(keyboardType:TextInputType.emailAddress,
              controller: registrationModel.emailController,
              onChange:registrationModel.onMailAddressChange,
                prefixIcon: FiUiElements.inputEmailIcon,
                hintText:localise("enter_your_email"),
                hintStyle: const TextStyle(
              color: Color(0xFFC2C3CB),
              fontSize: 14,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w500,
              letterSpacing: -0.28,
            ),
              inputType: InputType.email, // Specify the input type
              context: context,
            )

        )),
        Positioned(
            left: display.width / 2 - toX(328) / 2,
            top: toY(650),
            width: toX(328),//CHANGED FROM 228
            height: toY(139),//CHANGED FROM 79
            child: _terms()),
        Positioned(
            left: display.width / 2 - toX(343.9997) / 2,
            bottom: toY(30),
            width: toX(343.9997),
            height: toY(65.5238),
            child: uiElements.button(localise("regestration"),
                registrationModel.onRegistrationStart,
               enabled: registrationModel.ifRegistrationAllowed,
              //  enabled: true,
                progressVisible: registrationModel.isRegistrationInProgress
            )
        )
      ],
    );
  }


  Widget _terms(){
    return  SizedBox(
      width: toX(228),
      height: toY(79),
      child:  Text.rich(
        TextSpan(
          children: [
            TextSpan(
              text: localise("by_click"),
              style: const TextStyle(
                color: Color(0xBFACADB9),
                fontSize: 14,//CHANGED FROM 18
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
               // height: 1.5,
                letterSpacing: 0.54,
              ),
            ),
             TextSpan(
              text: localise("terms"),
              style: const TextStyle(
                color: Color(0xFF0677E8),
                fontSize: 14,//CHANGED FROM 18
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
               // height: 1.5,
                letterSpacing: 0.54,
              ),
            ),
            TextSpan(
              text: localise("of_context"),
              style: const TextStyle(
                color: Color(0xBFACADB9),
                fontSize: 14,//CHANGED FROM 18
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                //height: 1.5,
                letterSpacing: 0.54,
              ),
            ),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }


}
