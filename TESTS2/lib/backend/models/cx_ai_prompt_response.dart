import 'package:json_annotation/json_annotation.dart';

import 'fi_backend_response.dart';
part 'cx_ai_prompt_response.g.dart';

@JsonSerializable()
class CxAiPromptResponse {

  @JsonKey(includeFromJson: false)
  @JsonKey(includeToJson: false)
  FiBackendResponse? response ;


  @JsonKey(name:'Content')
  String? content ;
  @JsonKey(name:'Generation_settings')
  Map<String,dynamic> generationSettings ={};
  @JsonKey(name:'Model')
  String? model ;
  @JsonKey(name:'Prompt')
  String? prompt ;
  @JsonKey(name:'Stop')
  bool? stop ;
  @JsonKey(name:'Stopped_eos')
  bool? stoppedEos ;
  @JsonKey(name:'Stopped_limit')
  bool? stoppedLimit ;
  @JsonKey(name:'Stopped_word')
  bool? stoppedWord ;
  @JsonKey(name:'Stopping_word')
  String? stoppingWord ;
  @JsonKey(name:'Timings')
  Map<String,dynamic> timings ={};
  @JsonKey(name:'Tokens_cached')
  int? tokensCached ;
  @JsonKey(name:'Tokens_evaluated')
  int? tokensEvaluated ;
  @JsonKey(name:'Tokens_predicted')
  int? tokensPredicted ;
  @JsonKey(name:'Truncated')
  bool? truncated ;

  static CxAiPromptResponse fromResponse( FiBackendResponse response){
    if(response.successful() && response.data != null) {
      CxAiPromptResponse instance = _$CxAiPromptResponseFromJson(response.data!);
      instance.response = response ;
      return instance ;
    }

    CxAiPromptResponse instance = CxAiPromptResponse();
    instance.response = response ;
    return instance ;
  }
}