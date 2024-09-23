import 'dart:convert';
import 'dart:typed_data';

import 'package:http_status_code/http_status_code.dart';


import '../../utils/fi_image_data.dart';
import '../../utils/fi_log.dart';
import '../../utils/fi_resources.dart';
import '../config/fi_backend_config.dart';
import '../models/fi_backend_response.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../models/fi_download_image_model.dart';

enum FiImageType { user, group }

typedef FiImageDownloadCallback = void Function(Uint8List? item, Error? error);

class FiImagesManager {
  static final FiImagesManager _instance = FiImagesManager._internal();

  FiImagesManager._internal();

  factory FiImagesManager() {
    return _instance;
  }

  Future<FiBackendResponse> uploadImage(String ownerId, FiImageData image) async {
    FiBackendResponse? response;
    try {
      logger.d("upload image : $ownerId} path = ${image.image.path}");
      String token = resources.storage.getString(kAccessNotificationToken);
      var uri = Uri(scheme: backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/images/upload');
      logger.d("create group : $uri");
      var request = http.MultipartRequest("post", uri)
        ..fields["Token"] = token
        ..fields["Owner"] = ownerId
        ..files.add(await http.MultipartFile.fromPath("image", image.image.path));
      var responseAnswer = await request.send();
      response = FiBackendResponse();
      response.status = responseAnswer.statusCode;
      response.message = "";

      // response = CxBackendResponse.fromHttpResponse(await http.post(uri, body:jsonEncode(model.toJson()),headers: defaultHeaders).timeout(backendConfig.timeout));
      return response;
    } catch (err, stack) {
      logger.d("create group : $err $stack");
      response = FiBackendResponse();
      response.status = StatusCode.METHOD_FAILURE;
      response.message = err.toString();
      return response;
    }
  }

  Future<bool> downloadImage(String imageId, FiImageDownloadCallback callback) async {
    try {
      String token = resources.storage.getString(kAccessNotificationToken);
      Map<String, String> defaultHeaders = {"Content-Type": "application/json", 'accept': 'application/json', "Token": token};
      var uri = Uri(scheme: backendConfig.scheme, host: backendConfig.host, port: backendConfig.port, path: '/images/download');
      var request = http.Request("Get", uri);
      request.body = jsonEncode(FiDownloadImageModel(imageId).toJson());
      request.headers.addAll(defaultHeaders);
      var response = await request.send();
      if (response.statusCode != 200) {
        return false;
      }
      final List<int> imageBuffer = <int>[];
      response.stream.listen((value) {
        imageBuffer.addAll(value);
      }, onDone: () {
        logger.d("AI CHAT RESPONSE: ${response.statusCode}");
        Uint8List buffer = Uint8List.fromList(imageBuffer);
        callback.call(buffer, null);
      }, cancelOnError: false).onError((error) {
        callback.call(null, error);
      });
    } catch (err) {
      logger.d("Stream error $err");
      return false;
    }
    return true;
  }
}

FiImagesManager imagesApi = FiImagesManager();
