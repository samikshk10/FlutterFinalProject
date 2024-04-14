import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/auth/login/login_screen.dart';
import 'package:flutterprojectfinal/screens/auth/signup/signup_screen.dart';
import 'package:flutterprojectfinal/screens/customWidgets/navbar.dart';
import 'package:flutterprojectfinal/ui/homepage/homepage.dart';

class PageRender extends StatefulWidget {
  @override
  _PageRenderState createState() => _PageRenderState();
}

class _PageRenderState extends State<PageRender> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SignUpScreen(),
    LoginScreen(),
    SignUpScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index.clamp(0, _pages.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
        child: MyNavigationBar(
          selectedIndex: _selectedIndex,
          onItemTapped: _onItemTapped,
        ),
      ),
      body: _pages[_selectedIndex],
    );
  }
}
