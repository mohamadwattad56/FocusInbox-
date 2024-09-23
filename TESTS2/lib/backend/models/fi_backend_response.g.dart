// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fi_backend_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FiBackendResponse _$FiBackendResponseFromJson(Map<String, dynamic> json) =>
    FiBackendResponse()
          ..status = json['status'] is int ? json['status'] as int? : int.tryParse(json['status'].toString())
          ..message = json['message'] as String?
          ..data = json['data'] as Map<String, dynamic>?;

Map<String, dynamic> _$FiBackendResponseToJson(FiBackendResponse instance) =>
    <String, dynamic>{
          'status': instance.status,
          'message': instance.message,
          'data': instance.data,
    };