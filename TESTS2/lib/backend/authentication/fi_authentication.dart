import 'package:http/http.dart' as http;
import 'package:http_status_code/http_status_code.dart';
import '../../utils/fi_log.dart';
import '../config/fi_backend_config.dart';
import '../models/fi_backend_response.dart';
import '../models/fi_user_registration_model.dart';
import '../../backend/url_config.dart'; // Import the config file

class FiAuthentication {

  static final FiAuthentication _instance = FiAuthentication._internal();

  FiAuthentication._internal();

  factory FiAuthentication() {
    return _instance;
  }

  ///
  /// Start user registration
  Future<FiBackendResponse> registerUser(FiUserRegistrationModel model) async
  {
    FiBackendResponse? response;
    try {
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json'};
      ///var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/registration');
      //Uri uri = Uri.http('10.0.2.2:27345', '/user/register');
      Uri uri = Uri.http(baseUrl, '/user/register');
    logger.d("registerUser : $uri");
      //http.post(uri, body: model.toJson(), headers: defaultHeaders);

      response = FiBackendResponse.fromHttpResponse(await http.post(uri, body: model.toJson(), headers: defaultHeaders).timeout(const Duration(seconds: 10)));

    } catch (err) {
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
    }
    return response;
  }


  Future<FiBackendResponse> verificationUser(String? uuid) async {
    FiBackendResponse? response;
    try {
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json'};
     /// var uri = Uri(scheme:backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/user/verification');
      //Uri uri = Uri.http('10.0.2.2:27345',  '/user/get_status', {'uuid': uuid});
      Uri uri = Uri.http(baseUrl, '/user/get_status', {'uuid': uuid});

      logger.d("VerificateUser : $uri");
      // response = FiBackendResponse.fromHttpResponse(await http.get(uri, headers: defaultHeaders).timeout(const Duration(seconds: 10)));
      var httpResponse = await http.get(uri, headers: defaultHeaders).timeout(const Duration(seconds: 100));

      response = FiBackendResponse.fromHttpResponse(httpResponse);
    }
    catch (err) {
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
    }
    return response;
  }

}

FiAuthentication authenticationApi = FiAuthentication() ;