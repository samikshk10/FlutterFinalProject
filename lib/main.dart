import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/events/add_events/add_events.dart';
import 'package:flutterprojectfinal/screens/auth/login/login_screen.dart';
import 'package:flutterprojectfinal/screens/auth/signup/signup_screen.dart';
import 'package:flutterprojectfinal/ui/homepage/page_render.dart';
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
    initialRoute: '/addevent',
    routes: {
      '/': (context) => LoginScreen(),
      '/signup': (context) => SignUpScreen(),
      '/home': (context) => PageRender(),
      '/addevent': (context) => AddEventScreen()
    },
  ));
}
