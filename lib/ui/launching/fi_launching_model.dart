import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../backend/users/fi_users.dart';
import '../../firebase_options.dart';
import '../../models/main/base/fi_model.dart';
import '../../models/main/fi_main_model.dart';
import '../../models/main/fi_main_models_states.dart';
import '../../utils/fi_log.dart';
import '../../utils/fi_resources.dart';
import '../base/fi_base_state.dart';
import '../base/fi_base_widget.dart';
import '../navigationbar/contacts/fi_contact.dart';
import '../navigationbar/contacts/fi_contacts_tab_model.dart';
import '../navigationbar/contacts/fi_contacts_tab_widget.dart';
import '../navigationbar/settings/fi_settings_tab_model.dart';
import '../utils/fi_ui_elements.dart';

class FiLaunchingModel extends FiModel {
  static final FiLaunchingModel _instance = FiLaunchingModel._internal();
  String fcmToken = "";
  FiLaunchingModel._internal();
  factory FiLaunchingModel() {
    return _instance;
  }

  int get platform {
    if (Platform.isAndroid) {
      return 0;
    } else if (Platform.isIOS) {
      return 1;
    } else if (Platform.isWindows) {
      return 3;
    } else if (Platform.isLinux) {
      return 4;
    } else if (Platform.isMacOS) {
      return 5;
    }
    return 3;
  }


  Future<void> initFirebaseMessaging() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    var notificationSettings = await messaging.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);

    resources.storage.putBoolean(kPushNotificationTokenPermission, notificationSettings.authorizationStatus == AuthorizationStatus.authorized);

    if (notificationSettings.authorizationStatus == AuthorizationStatus.authorized) {
      String? token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        resources.storage.putString(kPushNotificationToken, token);
        logger.d("Notification token = $token");
        fcmToken = token;
      }

      FirebaseMessaging.onMessage.listen((event) => uiElements.handlePushNotification(event));
    }
  }

  @override
  setState(FiBaseState<FiBaseWidget>? state) {
    super.setState(state);
    if (state != null) {
      _loadUserData();
    }
  }

  _loadUserData() async {
    await resources.load();


    resources.storage.remove(kAccessNotificationToken);

    String token = resources.storage.getString(kAccessNotificationToken);
    if (token.isEmpty) {
      applicationModel.currentState = FiApplicationStates.grantPermissionState;
    }
    else {
      await _continueLaunch();
    }
  }

  _continueLaunch() async
  {
    String token = resources.storage.getString(kAccessNotificationToken);
    applicationModel.currentContact = FiContact(type: FiContactPageType.current, user: await usersApi.loadUser(token)); //await usersApi.loadUser(token) ;
    if (applicationModel.currentContact == null || applicationModel.currentContact!.user == null) {
      applicationModel.currentState = FiApplicationStates.registrationState;
      return;
    }
    else {
      await loadModules() ;
    }
    settings.updateData(applicationModel.currentContact!.user!);
    applicationModel.currentState = FiApplicationStates.navigationScreen;
  }





  reCheckPermissions() async {
    if (!await _checkPermissions()) {
      return;
    }
    _continueLaunch();
  }

  Future<bool> _checkPermissions() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    var notificationSettings = await messaging.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);
    if (notificationSettings.authorizationStatus != AuthorizationStatus.authorized) {
      return false;
    }

    var status = await getContactPermission();
    if (status != PermissionStatus.granted) {
      return false;
    }

    return true;
  }

  Future<PermissionStatus> getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted && permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }



  Future<void> loadModules() async{
    try {
      await initFirebaseMessaging();
      await contacts.load() ;
    } catch (e, stack) {
      logger.d("Permissions $e $stack");
    }
  }

  Future<void> askPermission() async {
    await loadModules() ;
    applicationModel.currentState = FiApplicationStates.registrationState;

  }
}

FiLaunchingModel launchingModel = FiLaunchingModel();