import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserCredentialProvider extends ChangeNotifier {
  auth.UserCredential? _userCredential;

  auth.UserCredential? get userCredential => _userCredential;

  bool? _isOrganizer;
  bool? get isOrganizer => _isOrganizer;

  void setUserCredential(auth.UserCredential userCredential, bool isOrganizer) {
    _userCredential = userCredential;
    _isOrganizer = isOrganizer;
    notifyListeners();
  }
}
