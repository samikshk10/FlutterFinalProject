import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/auth/login/login_screen.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        appBarTheme: AppBarTheme(
            backgroundColor: Colors.purple,
            titleTextStyle: TextStyle(fontSize: 24, color: Colors.white)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
      },
    ));
