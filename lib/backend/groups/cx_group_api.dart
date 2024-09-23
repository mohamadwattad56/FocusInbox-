import 'dart:convert';

import 'package:http_status_code/http_status_code.dart';

import '../../utils/fi_log.dart';
import '../../utils/fi_resources.dart';
import '../config/fi_backend_config.dart';
import 'package:http/http.dart' as http;
import '../models/fi_backend_response.dart';
import '../models/fi_group_model.dart';

class FiGroupApi {
  static final FiGroupApi _instance = FiGroupApi._internal();

  FiGroupApi._internal();

  factory FiGroupApi() {
    return _instance;
  }

  Future<FiBackendResponse> create(CxGroupModel model) async {
    FiBackendResponse? response;
    try {
      logger.d("create group : ${model.toJson()}");
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/groups/create');
      logger.d("create group : $uri");
      response = FiBackendResponse.fromHttpResponse(await http.post(uri, body:jsonEncode(model.toJson()),headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err,stack) {
      logger.d("create group : $err $stack");
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }

  Future<FiBackendResponse> list() async {
    FiBackendResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/groups/list');
      logger.d("create group : $uri");
      response = FiBackendResponse.fromHttpResponse(await http.get(uri, headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err,stack) {
      logger.d("create group : $err $stack");
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }

  Future<FiBackendResponse> fetchOrganization() async {
    FiBackendResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};
      var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/organization/fetch');
      logger.d("create group : $uri");
      response = FiBackendResponse.fromHttpResponse(await http.get(uri, headers: defaultHeaders).timeout(backendConfig.timeout));
      return response ;
    } catch (err,stack) {
      logger.d("create group : $err $stack");
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response ;
    }
  }



}

FiGroupApi groupsApi = FiGroupApi();