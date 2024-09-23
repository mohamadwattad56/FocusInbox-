import 'package:flutter/cupertino.dart';

class FiKeyboardHelper {
  FocusNode node = FocusNode();
  final ScrollController scrollController = ScrollController();
  final TextEditingController textEditingController = TextEditingController(text: "");
  bool inputEnabled = false;
}