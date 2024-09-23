import 'package:flutter/cupertino.dart';
class CxAiBubbleClipper extends CustomClipper<Path> {
  CxAiBubbleClipper();
  @override
  Path getClip(Size size) {
    var path = Path();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}