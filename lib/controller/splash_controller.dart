import 'package:flutter/material.dart';
import 'package:note_app/utils/app_utils.dart';
import 'dart:async';

class SplashController with ChangeNotifier {
  void initTimer(dynamic route) => Timer(Duration(seconds: 3),
      () => Navigator.pushReplacement(navState.currentContext!, route));
}
