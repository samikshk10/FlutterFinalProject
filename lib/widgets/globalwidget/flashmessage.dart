import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

class FlashMessage {
  static void show(BuildContext context,
      {required String message, bool isSuccess = false}) {
    toastification.show(
      context: context,
      title: Text(message),
      foregroundColor: Colors.white,
      backgroundColor: !isSuccess ? Colors.redAccent : Colors.blue[300]!,
      autoCloseDuration: const Duration(seconds: 5),
    );
  }
}
