import 'package:json_annotation/json_annotation.dart';
part 'fi_download_image_model.g.dart';

@JsonSerializable()
class FiDownloadImageModel {
  String id ;
  FiDownloadImageModel(this.id) ;

  Map<String,dynamic> toJson() => _$FiDownloadImageModelToJson(this);
}