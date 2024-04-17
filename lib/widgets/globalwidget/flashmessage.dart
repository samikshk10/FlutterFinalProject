import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FlashMessage {
  static void show(BuildContext context,
      {required String message, bool isSuccess = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 3,
      backgroundColor: isSuccess ? Colors.blue[300]! : Colors.redAccent,
      textColor: Colors.white,
    );
  }
}
