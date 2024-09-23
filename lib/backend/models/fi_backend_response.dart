import 'package:http_status_code/http_status_code.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

part 'fi_backend_response.g.dart';

@JsonSerializable()
class FiBackendResponse {
  int? status;
  String? message;
  Map<String,dynamic>? data ;

  static FiBackendResponse fromHttpResponse(http.Response response){
    FiBackendResponse? backendResponse  ;
    if(response.statusCode == StatusCode.OK) {
      var json = convert.jsonDecode(response.body) as Map<String, dynamic>;
      backendResponse =_$FiBackendResponseFromJson(json);
    }
    else {
      backendResponse = FiBackendResponse();
      backendResponse.status = response.statusCode ;
      backendResponse.message = response.body ;
    }
    return backendResponse ;
  }
  bool successful()  => status == StatusCode.OK ;
}