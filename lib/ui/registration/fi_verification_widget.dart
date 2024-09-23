import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../utils/fi_display.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import '../utils/fi_ui_elements.dart';
import 'fi_registration_model.dart';

class FiVerificationWidget extends FiBaseWidget {
  const FiVerificationWidget({super.key});

  @override
  Future<bool> get onWillPop {
    registrationModel.onRegistrationBack();
    return Future.value(false);
  }

  @override
  State<StatefulWidget> createState() => _FiVerificationWidgetState();
}

class _FiVerificationWidgetState extends FiBaseState<FiVerificationWidget> {
  @override
  void initState() {
    super.initState();
    registrationModel.setState(this);
    registrationModel.startResendAllowTimer();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (registrationModel.onSendVerificationCode != null) {
        registrationModel.onSendVerificationCode!.call();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    registrationModel.stopVerifyCode();
    //registrationModel.verificationSmsCodeController.dispose();
  }

  @override
  @protected
  Widget get content => Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
              top: toY(277),
              left: 0,
              right: 0,
              child: Center(
                child: Text(localise("whatsapp"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontSize: toY(30),
                        fontWeight: FontWeight.bold,
                        height: 1.5)),
              )),
          Positioned(
              top: toY(311),
              left: 0,
              right: 0,
              child: Center(
                child: Text(localise("authentication_process"),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: const Color.fromRGBO(255, 255, 255, 1),
                        fontSize: toY(25),
                        fontWeight: FontWeight.bold,
                        height: 1.5)),
              )),
          Positioned(
            top: toY(394.5),
            child: SizedBox(
              height: toY(85),
              width: toX(85),
              child: const Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 1.0, // Full circle background
                    strokeWidth: 5,
                    backgroundColor: Color(0xFF0677E8),
                  ),
                  CircularProgressIndicator(
                    strokeWidth: 5,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xFFA4C6E8)),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              top: toY(528),
              left: 0,
              right: 0,
              child: Text(
                localise("we_sent_qr"),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: const Color.fromRGBO(0x94, 0x94, 0x94, 1.0),
                    fontSize: toY(18),
                    //  fontWeight: FontWeight.bold,
                    height: 1.5),
              )),
          Positioned(
              top: toY(638),
              left: toX(180),
              width: toX(196),
              height: toX(22),
              child: Text(
                registrationModel.resendTimerValue,
                style:  TextStyle(
                  color: const Color(0xFFACADB9),
                  fontSize: toY(20),
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.29,
                ),
              )),
          /*
          Positioned(left: centerOnDisplayByWidth(toX(300)), top: toY(473), width: toX(300), height: toY(66), child: uiElements.button(localise("verify"), registrationModel.onSendVerificationCode, enabled: registrationModel.sendVerificationIsAllowed, progressVisible: registrationModel.verificationInProgress)),
         */
         // Positioned(left: centerOnDisplayByWidth(toX(300)), top: toY(740), width: toX(300), height: toY(66), child: uiElements.button(localise("send_again"), registrationModel.onResendCode, enabled: registrationModel.resendCodeAllowed, progressVisible: registrationModel.resendCodeInProgress)),

        ],
      );
}
