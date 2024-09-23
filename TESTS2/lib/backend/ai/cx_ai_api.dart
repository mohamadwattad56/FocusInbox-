import 'dart:async';
import 'dart:convert';

import 'package:FocusInbox/models/main/fi_main_model.dart';
import 'package:http_status_code/http_status_code.dart';

import '../../utils/fi_log.dart';
import '../../utils/fi_resources.dart';
import '../config/fi_backend_config.dart';
import '../models/cx_ai_prompt.dart';
import '../models/cx_ai_prompt_response.dart';
import 'package:http/http.dart' as http;

import '../models/fi_backend_response.dart';
import '../url_config.dart';

class FiAiApi {
  static final FiAiApi _instance = FiAiApi._internal();

  FiAiApi._internal();

  factory FiAiApi() {
    return _instance;
  }

  Future<CxAiPromptResponse> completion(FiAiPrompt prompt) async {
    CxAiPromptResponse? response;
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json',"Token":token};

      var uri = Uri(scheme: backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/ai/completion');
      logger.d("ai completion : $uri");
      FiBackendResponse bResponce = FiBackendResponse.fromHttpResponse(await http.post(uri, body: prompt.toJson(), headers: defaultHeaders).timeout(const Duration(seconds: 10)));
      response = CxAiPromptResponse.fromResponse(bResponce);
    } catch (err) {
      FiBackendResponse bResponce = FiBackendResponse();
      bResponce.status = StatusCode.METHOD_FAILURE;
      bResponce.message = err.toString();
      response = CxAiPromptResponse.fromResponse(bResponce);
    }
    return response;
  }



  Future<bool> chat(FiAiPrompt prompt) async {
    try {
      String? uuid = applicationModel.currentContact?.user?.uuid;

      /*if (uuid == null) {
        logger.d("UUID is null. Cannot send chat request.");
        return false;
      }*/

      // Prepare the request headers with the UUID instead of the token
      Map<String, String> defaultHeaders = {
        "Content-Type": "application/json",
        'accept': 'application/json',
        //"UUID": uuid
      };
      /*   Uri uri = Uri.http(baseUrl, '/user/get_status', {'uuid': uuid});

      logger.d("VerificateUser : $uri");
      // response = FiBackendResponse.fromHttpResponse(await http.get(uri, headers: defaultHeaders).timeout(const Duration(seconds: 10)));
      var httpResponse = await http.get(uri, headers: defaultHeaders).timeout(const Duration(seconds: 100));
*/
      // Create the URI for the chat endpoint
      //var uri = Uri(scheme: backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/ai/chat');
      Uri uri = Uri.http(baseUrl, '/user/ask-ai');
      // Log the request URI
      logger.d("Sending chat request to: $uri");

      // Create the request
      var request = http.Request("Post", uri);
      request.body = jsonEncode(prompt.toJson());
      request.headers.addAll(defaultHeaders);

      // Send the request
      var response = await request.send();

      // Check the response status
      if (response.statusCode != 200) {
        logger.d("AI CHAT RESPONSE: ${response.statusCode}");
        return false;
      }

      // Handle the response stream
      response.stream.listen((value) {
        String responseBody = utf8.decode(value);
        Map<String, dynamic> jsonResponse = jsonDecode(responseBody);

        String aiResponse = jsonResponse['data']; // Extract the AI response

        logger.d(aiResponse); // Log the response for debugging

        prompt.receiver.call(aiResponse); // Pass the AI response to the receiver callback
      }, onDone: prompt.onDone, cancelOnError: false);


    } catch (err) {
      logger.d("Stream error $err");
      return false;
    }
    return true;
  }

}

FiAiApi aiApi = FiAiApi();
