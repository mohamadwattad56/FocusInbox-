import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http_status_code/http_status_code.dart';
import '../../backend/authentication/fi_authentication.dart';
import '../../backend/models/fi_backend_response.dart';
import '../../backend/models/fi_user_registration_model.dart';
import '../../backend/users/fi_users.dart';
import '../../models/main/base/fi_model.dart';
import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../../utils/fi_log.dart';
import '../../utils/fi_resources.dart';
import '../launching/fi_launching_model.dart';
import '../navigationbar/contacts/fi_contact.dart';
import '../navigationbar/contacts/fi_contacts_tab_widget.dart';

class FiRegistrationModel extends FiModel {
  static final FiRegistrationModel _instance = FiRegistrationModel._internal();

  Timer? _resendCodeTimer;
  int _timoutForEnableResendCode = 5*60 ; //TODO: 5 * 60
  bool _isTimerStarted = false ;
  String? _userFirstName ;
  String? _userLastName ;
  bool _isResendAllowed = false ;
  String? _mailAddress ;
  bool _verificationInProgress = false ;
  bool _resendCodeInProgress = false ;
  bool _isRegistationInProgress = false ;
  FiUserRegistrationModel? _userRegistrationModel;
  FiRegistrationModel._internal();



  //////////////////////////////////////////
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  ///////////////////////////////////////////



  factory FiRegistrationModel() {
    return _instance;
  }
///////////////////////////////////////////
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
  }
///////////////////////////////////////////
  ValueChanged<String> get onUserFirstNameChange => (username) {
        _userFirstName = username ;
  };

  ValueChanged<String> get onUserLastNameChange => (username) {
      _userLastName = username ;
  };

  ValueChanged<String> get onMailAddressChange => (mailaddress) {
      _mailAddress = mailaddress ;
  };




  bool get ifRegistrationAllowed => _isRegistationInProgress == false &&  _userFirstName != null && _userLastName != null && _mailAddress != null && _userFirstName!.isNotEmpty  && _userLastName!.isNotEmpty && _mailAddress!.isNotEmpty && _userFirstName!.length > 3;

  bool get isRegistrationInProgress => _isRegistationInProgress ;




  VoidCallback? get onRegistrationStart => !ifRegistrationAllowed ? null : ()
  {
    logger.d("Start user registration [$_userFirstName : $_mailAddress]") ;
    update(callback: () async{
      _isRegistationInProgress = true ;
      _userRegistrationModel = FiUserRegistrationModel(_userFirstName!, _userLastName!,_mailAddress!,launchingModel.platform,launchingModel.fcmToken);
      FiBackendResponse response = await authenticationApi.registerUser(_userRegistrationModel!) ;
      update(callback: (){
        _isRegistationInProgress = false ;
        if(response.successful())
        {
          applicationModel.currentState = FiApplicationStates.verificationState;
        }
        else
        {
          resources.storage.remove(kAccessNotificationToken);
          applicationModel.currentState = FiApplicationStates.userFailedLoginState;
        }
      });

    });

  };


  VoidCallback? get onResendCode => () {
    update(callback: () async {
      _resendCodeInProgress = true;
      _isResendAllowed = false;
      _timoutForEnableResendCode = 5 * 60 ; //TODO: 5 * 60
      FiBackendResponse response = await authenticationApi.registerUser(_userRegistrationModel!);
      _resendCodeInProgress = false;
      if (response.successful()) {
        logger.d("Resend successful, awaiting user verification.");
      } else {
        logger.d("Resend failed, please try again.");
      }
      startResendAllowTimer();
    });
  };


  bool get resendCodeAllowed => _resendCodeInProgress == false && _isResendAllowed;


  VoidCallback? get onSendVerificationCode => ()  {
    update(callback: () async {
      _verificationInProgress = true;
      bool verified = false;

      applicationModel.currentContact = FiContact(
          type: FiContactPageType.current,
          user: await usersApi.loadUser(_userRegistrationModel!.email)
      );

      while (!verified) {
        FiBackendResponse response = await authenticationApi.verificationUser(applicationModel.currentContact?.user?.uuid);
        if (response.successful()) {
         resources.storage.putString(kAccessNotificationToken,  applicationModel.currentContact!.user!.token);
          applicationModel.currentState = FiApplicationStates.userSuccessLoginState;
          verified = true;
        } else if (response.status != StatusCode.OK) {
          // Implement your waiting logic here - potentially including a sleep or backoff
          await Future.delayed(const Duration(seconds: 10));  // Wait for 10 seconds before trying again
        }
      }

      update(callback: () {
        _verificationInProgress = false;
      });
    });
  };





  get sendVerificationIsAllowed => _verificationInProgress == false ;

  bool get verificationInProgress => _verificationInProgress;

  bool get resendCodeInProgress => _resendCodeInProgress ;






  void onRegistrationBack() async {
    await Future.delayed(const Duration(seconds: 1));
    applicationModel.currentState = FiApplicationStates.registrationState;
  }




  void onRegistrationBackFromFail() async {
    update(callback: ()
    {
      _timoutForEnableResendCode = 5 * 60 ; //TODO: 5 * 60
      _isRegistationInProgress = false;
      _verificationInProgress = false;
      _resendCodeInProgress = false;
      applicationModel.currentState = FiApplicationStates.registrationState;
    });
  }




  void onVerificationBack() async {
    await Future.delayed(const Duration(seconds: 1));
    applicationModel.currentState = FiApplicationStates.verificationState;
  }



  VoidCallback get onStartRegistration => () {
    applicationModel.currentState = FiApplicationStates.registrationState;
  };




  VoidCallback get onStartVerification => () {
        applicationModel.currentState = FiApplicationStates.verificationState;
      };




  VoidCallback get onStartUserSuccessLogin => () {
    applicationModel.currentState = FiApplicationStates.userSuccessLoginState;
  };


  String? get mailAddress => _mailAddress;
  String? get userName => _userFirstName;

  startResendAllowTimer(){
    if(!_isTimerStarted) {

      const oneSec = Duration(seconds: 1);
      _resendCodeTimer = Timer.periodic(oneSec, (Timer timer)
      {
          if (_timoutForEnableResendCode == 0) {
            update(callback: () {
              timer.cancel();
              _isResendAllowed = true;
              applicationModel.currentState = FiApplicationStates.userFailedLoginState ;
            //  _verificationSmsCodeController.clear() ;
            });
          } else {
            update(callback: () {
              _timoutForEnableResendCode--;
            });
          }
        },
      );
      _isTimerStarted = true ;
    }
  }

  String get resendTimerValue {
    int sec = _timoutForEnableResendCode % 60;
    int min = (_timoutForEnableResendCode / 60).floor();
    String minute = min.toString().length <= 1 ? "0$min" : "$min";
    String second = sec.toString().length <= 1 ? "0$sec" : "$sec";
    return "$minute : $second";
  }



  void stopVerifyCode()
  {
    if(_isTimerStarted) {
       _resendCodeTimer?.cancel();
      _isTimerStarted = false ;
    }
  }

}

FiRegistrationModel registrationModel = FiRegistrationModel();
