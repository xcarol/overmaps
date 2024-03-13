import 'package:flutter/material.dart';

class SnackMessage {
  static void autoHideSnackBar(var context, String message,
      {int duration = 3}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(message),
      duration: Duration(seconds: duration),
    ));
  }
}
