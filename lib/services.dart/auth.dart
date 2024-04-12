import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthMethods {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<dynamic> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      String res = "Some error occured";

      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return res = "success";
    } on auth.FirebaseAuthException catch (exception, s) {
      debugPrint('$exception$s');
      switch ((exception).code) {
        case 'invalid-email':
          return 'Email address is malformed.';
        case 'wrong-password':
          return 'Wrong password.';
        case 'user-not-found':
          return 'No user corresponding to the given email address.';
        case 'user-disabled':
          return 'This user has been disabled.';
        case 'too-many-requests':
          return 'Too many attempts to sign in as this user.';
      }
      return 'Unexpected firebase error, Please try again.';
    } catch (e, s) {
      debugPrint('$e$s');
      return 'Login failed, Please try again.';
    }
  }

  static Future<dynamic> signupEmailandPassword(
      String email, String password) async {
    print(email + password);
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        return "signup successfully";
      } else {
        return "Please enter email and password";
      }
    } on auth.FirebaseAuthMultiFactorException catch (e) {
      print(e.code + "this is code");
      print(e.message);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'invalid-credential') {
        print('Wrong password provided for that user.');
      }
    }
  }

  static Future<dynamic> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
    print(userCredential.user?.displayName);
    return 'success';
  }
}
