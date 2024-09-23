
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_to_text.dart';






class CxAudioUtils{
  static final CxAudioUtils _instance = CxAudioUtils._internal();
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false ;
  bool _speechInitDone = false ;
  Record? _record ;
  String? path ;
  final List<String> _aggregatedSpeechWords = <String>[] ;
  String _currentLocaleId = '';
  List<LocaleName> speechLocaleNames = [];

  Future<void> initSpeech() async {
    if(_speechEnabled == false) {
      _speechEnabled = await _speechToText.initialize(
        onError: (error) {},
      );

      if(_speechEnabled){
        speechLocaleNames = await _speechToText.locales();
        var systemLocale = await _speechToText.systemLocale();
        _currentLocaleId = systemLocale?.localeId ?? '';
      }
    }
    _speechInitDone = true ;
  }



  CxAudioUtils._internal();

  factory CxAudioUtils() {
    return _instance;
  }



  Future<bool> startSpeechListening(ValueChanged<String>? onResult) async {

    if(!_speechEnabled ) {
      if(_speechInitDone){
        return false ;
      }
      await initSpeech();
    }

    _aggregatedSpeechWords.clear() ;

    if(_speechEnabled) {
      await _speechToText.listen(onResult: (result){
        String word = result.recognizedWords ;
        if(word.isNotEmpty){
          _aggregatedSpeechWords.add(word);
          onResult?.call(_aggregatedSpeechWords.join(" ")) ;
        }
      },localeId: _currentLocaleId,);
    }
    return _speechEnabled ;
  }

  Future<bool> stopSpeechListening() async {
    await _speechToText.stop();
    return true ;
  }

  VoidCallback get startAudioRecording => () async {
    /*await _record?.stop() ;
    _record = Record();
    if (await getAudioRecordingPermissions() == PermissionStatus.granted) {

      String name = "record_${DateTime.now().millisecondsSinceEpoch}" ;
      path = await fileUtils.createFilePath(name) ;
      await _record!.start(path:path) ;
    }
  */};

  VoidCallback get stopAudioRecording => () async {
      /*if(_record?.isRecording() != null){
        await _record?.stop() ;
        path = null ;
      }*/
  };

  Future<PermissionStatus> getAudioRecordingPermissions() async {

    PermissionStatus permissionStatus = await Permission.audio.status;
   /* if(await _record!.hasPermission()) {
        if(await _speechToText.hasPermission) {
          permissionStatus = await Permission.storage.status;
          if (permissionStatus != PermissionStatus.granted &&
              permissionStatus != PermissionStatus.permanentlyDenied) {
            permissionStatus = await Permission.storage.request();
          }
        }
    }*/

    return permissionStatus ;
  }
}

CxAudioUtils audioUtils = CxAudioUtils();