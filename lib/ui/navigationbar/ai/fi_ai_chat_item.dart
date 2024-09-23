import 'package:flutter/cupertino.dart';

import '../../../utils/fi_display.dart';
import '../../../utils/cx_text_utils.dart';
class FiAiChatItem {
  bool my;
  String question;
  String _answer = "";
  String _displayedAnswer = ""; // The answer that will be gradually displayed

  int lines = 1;

  FiAiChatItem(this.my, this.question);

  String maxString = "";
  double maxStringWidth = 0;
  double maxStringWidthOnDisplay = toX(100);
  double width = 0;

  static var style = TextStyle(
    fontSize: toY(12),
    fontFamily: 'Roboto',
    fontWeight: FontWeight.w500,
  );

  // Set the full answer and start displaying it gradually
  set answer(String data) {
    _answer = data;
    _displayedAnswer = ""; // Start with an empty string
  }

  String get answer => _displayedAnswer;

  // Function to gradually display the answer character by character
  void displayNextCharacter(VoidCallback onComplete) {
    if (_displayedAnswer.length < _answer.length) {
      _displayedAnswer += _answer[_displayedAnswer.length];
      Future.delayed(const Duration(milliseconds: 50), () {
        displayNextCharacter(onComplete); // Continue displaying characters
        onComplete(); // Call the callback to update the UI
      });
    }
  }
}
