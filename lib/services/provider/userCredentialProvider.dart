import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserCredentialProvider extends ChangeNotifier {
  auth.UserCredential? _userCredential;

  auth.UserCredential? get userCredential => _userCredential;

  void setUserCredential(auth.UserCredential userCredential) {
    _userCredential = userCredential;
    notifyListeners();
  }
}
