import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/auth/login/login_screen.dart';
import 'package:flutterprojectfinal/screens/auth/signup/signup_screen.dart';
import 'package:flutterprojectfinal/ui/homepage/home_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      appBarTheme: AppBarTheme(
          backgroundColor: Colors.purple,
          titleTextStyle: TextStyle(fontSize: 24, color: Colors.white)),
    ),
    initialRoute: '/home',
    routes: {
      '/': (context) => LoginScreen(),
      '/signup': (context) => SignUpScreen(),
      '/home': (context) => HomePage()
    },
  ));
}
