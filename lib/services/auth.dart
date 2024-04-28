import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/services/provider/userCredentialProvider.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class AuthMethods {
  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static Future<dynamic> loginWithEmailAndPassword(
      BuildContext context, email, String password) async {
    try {
      String res = "Some error occured";

      auth.UserCredential result = await auth.FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      if (!result.user!.emailVerified) {
        return "Please verify your email";
      }
      Provider.of<UserCredentialProvider>(context, listen: false)
          .setUserCredential(result, false);

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
        case 'invalid-credential':
          return "Incorrect email or password";
      }
      return 'Unexpected firebase error, Please try again.';
    } catch (e, s) {
      debugPrint('$e$s');
      return 'Login failed, Please try again.';
    }
  }

  static Future<dynamic> checkAdmin(String email, String password) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('admin')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;
        if (doc['password'] == password) {
          return "success";
        } else {
          return "incorrect email or password";
        }
      } else {
        return "This email doesnt belong to admin";
      }
    } catch (e) {
      return "Some error occured";
    }
  }

  static Future<dynamic> checkOrganiser(String email) async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('organizers')
          .where('email', isEqualTo: email)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot doc = querySnapshot.docs.first;

        if (doc["status"] == "pending") {
          return "Your organizer request  is yet approved";
        } else if (doc["status"] == "rejected") {
          return "Your organizer request has been rejected";
        } else if (doc["status"] == "approved") {
          return "success";
        }
      } else {
        return "This email doesnt belong to organizer";
      }
    } catch (e) {
      return "Some error occured";
    }
  }

  static Future<dynamic> signupEmailandPassword(
      String email, String password, String username) async {
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        QuerySnapshot querySnapshot = await firestore
            .collection('admin')
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          return "this email is already registered ";
        }
        auth.UserCredential userCred = await auth.FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        await userCred.user!.updateDisplayName(username);
        await userCred.user!.sendEmailVerification();

        return "success";
      } else {
        return "Please enter email and password";
      }
    } on auth.FirebaseAuthMultiFactorException catch (e) {
      print(e.code + "this is code");
      print(e.message);
      if (e.code == 'user-not-found') {
        return 'Email not found';
      } else if (e.code == 'invalid-credential') {
        return ('Wrong password provided for that user');
      }
    }
  }

  static Future<dynamic> signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;
    auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );
    final auth.UserCredential userCredential =
        await auth.FirebaseAuth.instance.signInWithCredential(credential);
    Provider.of<UserCredentialProvider>(context, listen: false)
        .setUserCredential(userCredential, false);

    return 'successs';
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await auth.FirebaseAuth.instance.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      print(e.code + "this is code");
      print(e.message);
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'invalid-credential') {
        print('Wrong password provided for that user.');
      }
    }
  }
}
