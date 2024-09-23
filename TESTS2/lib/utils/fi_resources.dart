import 'package:flutter/cupertino.dart';
import 'package:localization/localization.dart';
import 'package:shared_preferences/shared_preferences.dart';
const String kUserName = "user_name";
const String kPushNotificationToken = "user_push_notification_token";
const String kPushNotificationTokenPermission = "user_push_notification_permission";
const String kAccessNotificationToken = "user_access_token";
const String kAccessSocialRegistered = "user_register_to_use_social";

class FiPreferences {
  final SharedPreferences _preferences;
  static Map<String, dynamic>? customerInfo;
  FiPreferences(this._preferences);

  ///
  /// Set string value in device storage. Sync mode
  Future<void> putString(String key, String value) async =>
      _preferences.setString(key, value);

  Future<void> remove(String key) async =>
      _preferences.remove(key) ;

  ///
  /// Set int value in device storage. Sync mode
  void putInt(String key, int value) => _preferences.setInt(key, value);

  ///
  /// Set String value in device storage. Async mode
  void putStringAsync(String key, String value) async =>
      await _preferences.setString(key, value);

  String getString(String key,{String? defaultValue}) => _preferences.getString(key)??defaultValue??"" ;

  int getInt(String key,{int? defaultValue}) => _preferences.getInt(key)??defaultValue??0 ;
  ///
  /// Set int value in device storage. Async mode
  void putIntAsync(String key, int value) async =>
      await _preferences.setInt(key, value);

  putBoolean(String key,bool value) async {
    await _preferences.setBool(key, value) ;
  }

  bool  getBoolean(String key,{bool defaultValue = false}){
    return _preferences.getBool(key)??defaultValue ;
  }
  ///
  /// Get push notification token
  String? getPushToken() => _preferences.getString("firebase_messaging_token");

  ///
  /// Set push notification token
  void setPushNotification(String token) =>
      _preferences.setString("firebase_messaging_token", token);

  Future<void> removeAll() async{
    Set<String> keys =  _preferences.getKeys() ;
    Iterator<String> it =  keys.iterator ;
    if(it.moveNext()){
      do{
        await _preferences.remove(it.current) ;
      }
      while(it.moveNext());
    }
  }
}

class FiResources {
  static final FiResources _instance = FiResources._internal();

  static final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>() ;
  late FiPreferences storage ;
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey  ;
  BuildContext? get context => _navigatorKey.currentContext ;

  FiResources._internal();



  factory FiResources(){
    return _instance ;
  }

  Future<void> load() async{
    storage = FiPreferences(await SharedPreferences.getInstance());
  }
}

FiResources resources = FiResources();



String  localise(String key) => key.i18n();