import 'dart:convert';
import 'package:http_status_code/http_status_code.dart';
import '../../utils/fi_log.dart';
import '../../utils/fi_resources.dart';
import '../config/fi_backend_config.dart';
import '../models/fi_backend_response.dart';
import '../models/fi_user.dart';
import 'package:http/http.dart' as http;
import '../models/fi_user_email.dart';
import '../models/fi_user_phone.dart';
import '../models/fi_user_notification_settings.dart';
import '../url_config.dart';
class FiUsers {
  static final FiUsers _instance = FiUsers._internal();

  FiUsers._internal();

  factory FiUsers() {
    return _instance;
  }

  Future<FiUser?> loadUser(String mail) async{
    FiBackendResponse? response;
    try {
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Mail":mail};
    //  var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/information');
      //Uri uri = Uri.http('10.0.2.2:27345', '/user/information',{'email': mail});
      Uri uri = Uri.http(baseUrl, '/user/info', {'email': mail});
      logger.d("loadUser url : $uri");
      response = FiBackendResponse.fromHttpResponse(await http.get(uri, headers: defaultHeaders).timeout(backendConfig.timeout));
      if(response.successful()){
        FiUser user = FiUser.fromJson(response.data!) ;
        return user ;
      }
    } catch (err) {
      logger.d("loadUser error : $err");
    }
    return null ;
  }

  Future<FiBackendResponse> addEmail(FiUserEmail userEmail) async {
    FiBackendResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/email/add');
      logger.d("addEmail : $uri");
      response = FiBackendResponse.fromHttpResponse(await http.post(uri,body: userEmail.toJson(), headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err) {
      logger.d("addEmail : $err");
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }


  Future<FiBackendResponse> updateSettings(FiUserNotificationSettings settings) async {
    FiBackendResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/settings/notification');
      logger.d("updateSettings : $uri");
      response = FiBackendResponse.fromHttpResponse(await http.post(uri,body: settings.toJson(), headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err) {
      logger.d("updateSettings : $err");
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }

/*  Future<CxBackendResponse> listEmails() async {
    CxBackendResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/email/list');
      logger.d("addEmail : $uri");
      response = CxBackendResponse.fromHttpResponse(await http.post(uri, headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err) {
      logger.d("addEmail : $err");
      response = CxBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }*/

  Future<FiBackendResponse> addCalendar(FiUserEmail userEmail) async {
    FiBackendResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/calendar/add');
      logger.d("addCalendar : $uri");
      response = FiBackendResponse.fromHttpResponse(await http.post(uri,body: userEmail.toJson(), headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err) {
      logger.d("addCalendar : $err");
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }

/*  Future<CxBackendResponse> listCalendars() async {
    CxBackendResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/calendar/list');
      logger.d("addEmail : $uri");
      response = CxBackendResponse.fromHttpResponse(await http.post(uri, headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err) {
      logger.d("addEmail : $err");
      response = CxBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }*/

/*  Future<CxBackendResponse> convert(CxGroupUserModel model) async {
    CxBackendResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/convert/register');
      logger.d("convert : $uri");
      response = CxBackendResponse.fromHttpResponse(await http.post(uri,body: jsonEncode(model.toJson), headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err) {
      logger.d("addCalendar : $err");
      response = CxBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }*/

  Future<FiBackendResponse> addPhone(FiUserPhone userPhone)async{
    FiBackendResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/settings/add/phone');
      logger.d("addPhone : $uri");
      response = FiBackendResponse.fromHttpResponse(await http.post(uri,body:jsonEncode(userPhone.toJson()) , headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err) {
      logger.d("addPhone : $err");
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }
}

FiUsers usersApi = FiUsers();