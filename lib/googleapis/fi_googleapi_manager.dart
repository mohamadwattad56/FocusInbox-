
//import 'package:connectx/utils/cx_log.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'fi_callendar_account.dart';
import 'fi_email_account.dart';

class FiEmailsManager {



  static final FiEmailsManager _instance = FiEmailsManager._internal();

  FiEmailsManager._internal();
  late GoogleSignIn _googleEmailSignIn ;
  late GoogleSignIn _googleCalendarSignIn ;
  factory FiEmailsManager() {
    _instance._googleEmailSignIn = GoogleSignIn(
      scopes: [
        'https://mail.google.com/',
        'https://www.googleapis.com/auth/contacts.readonly',
        'https://www.googleapis.com/auth/cloud-platform',
        'https://www.googleapis.com/auth/calendar',
        'https://www.googleapis.com/auth/calendar.events',
        'https://www.googleapis.com/auth/calendar.settings.readonly'
      ],
    );
    _instance._googleCalendarSignIn = GoogleSignIn(
      scopes: [
        'https://www.googleapis.com/auth/calendar',
      ],
    );
    return _instance;
  }

  Future<FiCalendarAccount?> loadCalendar() async{
    try{
      GoogleSignInAccount? account =   await _googleCalendarSignIn.signIn();
      if(account != null){
        return FiCalendarAccount(account:account) ;
      }
    }
    catch(err,stack){
    //  logger.d("CxEmailsManager: $err\n$stack");
    }
    return null ;
  }

  Future<FiEmailAccount?> loadEmail() async{
    try{
      GoogleSignInAccount? account =   await _googleEmailSignIn.signIn();
      if(account != null){
        return FiEmailAccount(account: account) ;
      }
    }
    catch(err,stack){
     // logger.d("CxEmailsManager: $err\n$stack");
    }
    return null ;
  }

  Future<FiCalendarAccount?> addCalendar() async {
    try {
      if(await _googleCalendarSignIn.isSignedIn()) {
        _googleCalendarSignIn.disconnect() ;
      }
      GoogleSignInAccount? account =   await _googleCalendarSignIn.signIn();
      if(account != null){
        return FiCalendarAccount(account:account) ;
      }
    } catch (err, stack) {
      //logger.d("CxEmailsManager: $err\n$stack");
    }
    return null ;
  }

  Future<FiEmailAccount?> addEmail() async {
    try {
      if(await _googleEmailSignIn.isSignedIn()) {
        _googleEmailSignIn.disconnect() ;
      }
      GoogleSignInAccount? account =   await _googleEmailSignIn.signIn();
      if(account != null){
        return  FiEmailAccount(account:account) ;
      }
    } catch (err, stack) {
    //  logger.d("CxEmailsManager: $err\n$stack");
    }
    return null ;
  }

  Future<void> disconnect() async{
    if(await _googleEmailSignIn.isSignedIn()){
      await _googleEmailSignIn.signOut();
    }
  }

  void removeEmail(FiEmailAccount email) {
    if (email.account !=null && email.account!.email == email.email){
      _googleEmailSignIn.disconnect() ;
    }
  }
}

FiEmailsManager googleApiManager = FiEmailsManager();
