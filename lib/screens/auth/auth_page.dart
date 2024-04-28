import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/auth/login/login_screen.dart';
import 'package:flutterprojectfinal/ui/homepage/page_render.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authpage extends StatefulWidget {
  @override
  State<Authpage> createState() => _AuthpageState();
}

class _AuthpageState extends State<Authpage> {
  bool? isOrganizer = false;
  void checkOrganizer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isOrganizer = preferences.getBool("isOrganizer") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkOrganizer();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return PageRender(
              isLoggedInAsOrganizer: isOrganizer ?? false,
            );
          }
          return LoginScreen();
        },
      ),
    );
  }
}
