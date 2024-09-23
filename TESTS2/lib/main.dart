import 'dart:async';
import 'focusinbox_app.dart';
import 'utils/fi_log.dart';
import 'package:flutter/material.dart';


FutureOr<void> main() async {
  logger.d("APPLICATION START") ;
  WidgetsFlutterBinding.ensureInitialized();
  logger.d("APPLICATION START: ensureInitialized") ;
  await Future.delayed(const Duration(milliseconds: 1000));
  logger.d("APPLICATION START: READY") ;
  runApp(const FocusInboxApp());
}