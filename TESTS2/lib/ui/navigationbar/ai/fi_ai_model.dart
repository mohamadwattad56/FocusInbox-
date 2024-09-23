import 'package:flutter/cupertino.dart';
import '../../../backend/ai/cx_ai_api.dart';
import '../../../backend/models/cx_ai_prompt.dart';
import '../../../models/main/base/fi_model.dart';
import '../../../utils/cx_audio_utils.dart';
import '../../base/fi_base_state.dart';
import '../../base/fi_base_widget.dart';
import 'fi_ai_chat_item.dart';
import 'fi_ai_tab_widget.dart';

CxAiModel ai = CxAiModel();

class CxAiModel extends FiModel {
  static final CxAiModel _instance = CxAiModel._internal();
  String _question = "";
  final List<FiAiChatItem> items =<FiAiChatItem>[];
  final Map<String,FiAiChatItem> aiAnswers = {} ;

  CxAiModel._internal();


  factory CxAiModel() {
    return _instance;
  }

  bool get inChat => items.isNotEmpty ;

  ValueChanged<String> get onQuestion => (question) {
    _question = question ;

  };

  @override
  setState(FiBaseState<FiBaseWidget>? state) {
     super.setState(state);
     if(state!=null){
       audioUtils.initSpeech();
     }
  }

  VoidCallback get ask => () {
    update(callback: () {
      if (_question.isNotEmpty) {
        // Add the user's question as a chat item
        FiAiChatItem userQuestionItem = FiAiChatItem(true, _question);
        items.add(userQuestionItem);

        // Create a new item for the AI response
        FiAiChatItem aiResponseItem = FiAiChatItem(false, _question); // Define the AI response item here
        items.add(aiResponseItem);

        // Create the prompt
        FiAiPrompt prompt = FiAiPrompt(_question);

        // Set up the receiver for AI response
        prompt.onDataReceiver = (answerPart) {
          aiResponseItem.answer = answerPart; // Set the answer in the chat item
          aiResponseItem.displayNextCharacter(() {
            // Update the UI after each character is added
            update(callback: () {
              FiAiTabState state = modelState as FiAiTabState;
              state.scrollDown();
            });
          });
        };

        // Clear the input field
        if (modelState is FiAiTabState) {
          (modelState as FiAiTabState).textController.clear();
        }

        // Clear the question input field
        _question = "";

        // Start the chat with the AI
        aiApi.chat(prompt);
      }
    });
  };



  ValueChanged<String> get  onChatAnswer =>(answerPart){

  };

  int get questionsCount => items.length ;

  VoidCallback get loadHistory => (){

  };

  VoidCallback get clearHistory => (){

  };

  void clear() {
    aiAnswers.clear();
    items.clear();
  }
}
