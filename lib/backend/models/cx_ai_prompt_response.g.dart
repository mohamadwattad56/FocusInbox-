// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cx_ai_prompt_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CxAiPromptResponse _$CxAiPromptResponseFromJson(Map<String, dynamic> json) =>
    CxAiPromptResponse()
      ..content = json['Content'] as String?
      ..generationSettings = json['Generation_settings'] as Map<String, dynamic>
      ..model = json['Model'] as String?
      ..prompt = json['Prompt'] as String?
      ..stop = json['Stop'] as bool?
      ..stoppedEos = json['Stopped_eos'] as bool?
      ..stoppedLimit = json['Stopped_limit'] as bool?
      ..stoppedWord = json['Stopped_word'] as bool?
      ..stoppingWord = json['Stopping_word'] as String?
      ..timings = json['Timings'] as Map<String, dynamic>
      ..tokensCached = json['Tokens_cached'] as int?
      ..tokensEvaluated = json['Tokens_evaluated'] as int?
      ..tokensPredicted = json['Tokens_predicted'] as int?
      ..truncated = json['Truncated'] as bool?;

Map<String, dynamic> _$CxAiPromptResponseToJson(CxAiPromptResponse instance) =>
    <String, dynamic>{
      'Content': instance.content,
      'Generation_settings': instance.generationSettings,
      'Model': instance.model,
      'Prompt': instance.prompt,
      'Stop': instance.stop,
      'Stopped_eos': instance.stoppedEos,
      'Stopped_limit': instance.stoppedLimit,
      'Stopped_word': instance.stoppedWord,
      'Stopping_word': instance.stoppingWord,
      'Timings': instance.timings,
      'Tokens_cached': instance.tokensCached,
      'Tokens_evaluated': instance.tokensEvaluated,
      'Tokens_predicted': instance.tokensPredicted,
      'Truncated': instance.truncated,
    };
