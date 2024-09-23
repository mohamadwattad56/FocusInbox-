import 'dart:ui';
import 'package:url_launcher/url_launcher.dart';
import '../../../backend/models/fi_user.dart';
import '../../../backend/models/fi_user_notification_settings.dart';
import '../../../backend/users/fi_users.dart';
import '../../../googleapis/fi_callendar_account.dart';
import '../../../googleapis/fi_googleapi_manager.dart';
import '../../../googleapis/fi_email_account.dart';
import '../../../models/main/base/fi_model.dart';
import '../../../models/main/fi_main_model.dart';
import '../../../models/main/fi_main_models_states.dart';
import '../../../utils/list/fi_multi_list_action.dart';

class FiSettingsTabModel extends FiModel {
  static String kEmails = "kEmails";

 // static String kSocials = "kSocials";

  static String kCalendar = "kSCalendar";

  //static String kFeedback = "kFeedback";

  static String kNotificationManualTime = "kNotificationManualTime";

  static String kNotificationRelatedToMe = "kNotificationRelatedTome";

  static String kNotificationAny = "kNotificationAny";

  final Map<String, bool> _notificationStates = {};

  final Map<String, List<dynamic>> _values = {};

  static final FiSettingsTabModel _instance = FiSettingsTabModel._internal();

  FiUserNotificationSettings? notificationSettings ;

  VoidCallback? refreshNotification ;

  FiSettingsTabModel._internal();

  factory FiSettingsTabModel() {
    _instance._values[kEmails] = <dynamic>[];
    //_instance._values[kSocials] = <dynamic>[];
    _instance._values[kCalendar] = <dynamic>[];

    return _instance;
  }

  String get applicationVersionName => "1.0.0.0 DR1";

  FiMultiListAction get emailAction {
    final FiMultiListAction action = FiMultiListAction();
    action.action = () async {
      FiEmailAccount? account = await googleApiManager.addEmail();
      if (account != null) {
        action.add(account.email);
        _instance._values[kEmails]!.add(account);
        usersApi.addEmail(await account.toModel()) ;
      }
    };
    return action;
  }

  FiMultiListAction get calendarAction {
    final FiMultiListAction action = FiMultiListAction();
    action.action = () async {
      FiCalendarAccount? account = await googleApiManager.addCalendar();
      if (account != null) {
        action.add(account.email);
        _instance._values[kCalendar]!.add(account);
        usersApi.addCalendar(await account.toModel()) ;
      }
    };
    return action;
  }

  FiMultiListAction get socialAction {
    final FiMultiListAction action = FiMultiListAction();
    action.action = () async {
      // CxCalendarAccount? account = await googleApiManager.addCalendar();
      // if (account != null) {
      //   action.add(account.email);
      //   _instance._values[kCalendar]!.add(account);
      //   // await usersApi.addEmail(await account.toModel()) ;
      // }
    };
    return action;
  }

  List<String> get emailsAsString {
    List  accounts = _instance._values[kEmails]??<FiEmailAccount>[] ;
    List<String> list = <String>[];
    for(FiEmailAccount account in accounts) {
      list.add(account.email) ;
    }
    return list ;
  }

  List<String> get calendarsAsString {
    List  accounts = _instance._values[kCalendar]??<FiEmailAccount>[] ;
    List<String> list = <String>[];
    for(FiEmailAccount account in accounts) {
      list.add(account.email) ;
    }
    return list ;
  }



  void addEmailAccount(FiEmailAccount fiEmailAccount) {
    _instance._values[kEmails]?.add(fiEmailAccount) ;
  }

  void addCalendarAccount(FiEmailAccount fiEmailAccount) {
    _instance._values[kCalendar]?.add(fiEmailAccount) ;
  }

  void removeEmailAccount(String email){
    _instance._values[kEmails]?.removeWhere((element) => element.email == email) ;
  }

  void removeCalendarAccount(String email){
    _instance._values[kCalendar]?.removeWhere((element) => element.email == email) ;
  }

  void updateData(FiUser user) {
    if(user.email.isNotEmpty){
      FiEmailAccount accountEmail = FiEmailAccount(dbEmail: user.email);
      _instance._values[kEmails]!.add(accountEmail);

    }

  /*  if(user.calendars.isNotEmpty){
      for(String email in user.calendars) {
        FiEmailAccount accountEmail = FiEmailAccount(dbEmail: email);
        _instance._values[kCalendar]!.add(accountEmail);
      }
    }*/

    if(user.settings != null && user.settings!.isNotEmpty) {
      notificationSettings = FiUserNotificationSettings.fromJson(user.settings!);
    }
    else {
      notificationSettings = FiUserNotificationSettings(allowedFrom: 0, allowedTo: 0, relatedToMe: false, any: false);
    }

    _notificationStates[kNotificationManualTime] = notificationSettings?.isManualTimeSet??false ;
    _notificationStates[kNotificationRelatedToMe] =  notificationSettings?.relatedToMe??false ;
    _notificationStates[kNotificationAny] =  notificationSettings?.any??false ;
  }

  Future<void> load() async {
    FiEmailAccount? accountEmail = await googleApiManager.loadEmail();
    if (accountEmail != null) {
      _instance._values[kEmails]!.add(accountEmail);
      await usersApi.addEmail(await accountEmail.toModel());
    }
    FiCalendarAccount? accountCallendar = await googleApiManager.loadCalendar();
    if (accountCallendar != null) {
      _instance._values[kCalendar]!.add(accountCallendar);
      await usersApi.addCalendar(await accountCallendar.toModel());
    }
  }

  int get settingsCount => 10;





 /* VoidCallback get loginToOrganization => () async {
        applicationModel.setCurrentStateWithParams(CxApplicationStates.organizationLogin, {kBackState:CxApplicationStates.navigationScreen});
      };
*/
/*
  VoidCallback get inviteCoworker => () async {};
*/

  VoidCallback get showPersonalInformation => () async {
    applicationModel.currentState = FiApplicationStates.personalInformation ;
  };

 /* VoidCallback get showFeedbackScreen => () async {
        String email = Uri.encodeComponent("alexander@innovio.co.il");
        String subject = Uri.encodeComponent("Hello ConnectX");

        Uri mail = Uri.parse("mailto:$email?subject=$subject");
        if (await launchUrl(mail)) {
          //email app opened
        } else {
          //email app is not opened
        }
      };*/

  int valuesCount(String key) => _values[key]?.length ?? 0;

  List<String> valuesAsStrings(String key) {
    List<String> items = <String>[];
    if (_values.containsKey(key)) {
      Iterator<dynamic> it = _values[key]!.iterator;
      if (it.moveNext()) {
        do {
          dynamic current = it.current;
          if (current is FiEmailAccount) {
            items.add(current.email);
          }
          if (current is FiCalendarAccount) {
            items.add(current.email );
          }
        } while (it.moveNext());
      }
    }
    return items;
  }

  bool notificationStateFor(String key) {
    if (!_notificationStates.containsKey(key)) {
      _notificationStates[key] = false;
    }
    return _notificationStates[key]!;
  }

  void setNotificationState(String key, bool value) {
    if(FiSettingsTabModel.kNotificationManualTime == key && !value){
      notificationSettings?.allowedTo = 0 ;
      notificationSettings?.allowedFrom = 0 ;
    }
    update(callback: () {
      _notificationStates[key] = value ;
      refreshNotification?.call() ;
    });
  }

  bool get isManualTimeSetEnabled => _notificationStates[FiSettingsTabModel.kNotificationManualTime]??false ;

  String valueAtIndex(String key, int index) {
    if (valuesCount(key) > index) {
      var item = _values[key]![index];
      if (item is FiEmailAccount) {
        FiEmailAccount account = item;
        return account.account != null ? account.account!.email : account.email ;
      }
      if (item is FiCalendarAccount) {
        FiCalendarAccount account = item;
        return account.account != null ? account.account!.email : account.email;
      }
      return item;
    }
    return "";
  }

  void setNotificationRefreshCallback(VoidCallback? refresh) {
    refreshNotification = refresh ;
  }


}

FiSettingsTabModel settings = FiSettingsTabModel();
