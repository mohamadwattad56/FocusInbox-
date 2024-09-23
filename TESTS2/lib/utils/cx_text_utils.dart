
import 'package:flutter/material.dart';

class FiTextUtils {

  static int lineNumbers(String text,TextStyle style) {
    final textSpan = TextSpan(
      text: text,
      style: style,
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();
    return tp.computeLineMetrics().length ;
  }

  static double stringWidth(String text,TextStyle style){
    final textSpan = TextSpan(
      text: text,
      style: style,
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();
    return tp.width ;
  }

  static Size calculateTextBoxSize(String text,TextStyle style,double maxWidth,{int typeFormat = 0}) {
    final textSpan = TextSpan(
      text: text,
      style: style,
    );
    final tp = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    tp.layout();
    if(tp.width > maxWidth){
      if(typeFormat == 0) {
        List<String> delByDot = text.split(".");
        if (delByDot.length >= 2) {
          text = addNewLineBeforeNumber(text,'.');
          return calculateTextBoxSize(text, style, maxWidth,typeFormat:1);
        }
      }
      else if(typeFormat == 1){
        List<String> delByDot = text.split(" ");
        if (delByDot.length >= 2) {
          text = addNewLineBeforeNumber(text,' ');
          return calculateTextBoxSize(text, style, maxWidth,typeFormat:2);
        }
      }

    }


    return Size(tp.width,tp.height) ;
  }

  static String addNewLineBeforeNumber(String input,String character) {
    return input.replaceAll(character, ".\n") ;
  }
}