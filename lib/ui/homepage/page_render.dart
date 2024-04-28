import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/events/add_events/add_events.dart';
import 'package:flutterprojectfinal/screens/auth/admin/manageEventsPage.dart';
import 'package:flutterprojectfinal/screens/auth/login/login_screen.dart';
import 'package:flutterprojectfinal/screens/customWidgets/navbar.dart';
import 'package:flutterprojectfinal/screens/explore/explorePage.dart';
import 'package:flutterprojectfinal/ui/homepage/homepage.dart';
import 'package:flutterprojectfinal/screens/profile/userProfile.dart';

class PageRender extends StatefulWidget {
  final bool isLoggedInAsOrganizer;

  const PageRender({Key? key, required this.isLoggedInAsOrganizer})
      : super(key: key);

  @override
  _PageRenderState createState() => _PageRenderState();
}

class _PageRenderState extends State<PageRender> {
  int _selectedIndex = 0;

  final List<Widget> _page = [HomePage(), ExplorePage(), UserProfile()];

  final List<Widget> _pages = [
    HomePage(),
    ExplorePage(),
    ManageEventsPage(),
    UserProfile()
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
          isLoggedInAsOrganizer: widget.isLoggedInAsOrganizer,
          onItemTapped: _onItemTapped,
        ),
      ),
      body: widget.isLoggedInAsOrganizer
          ? _pages[_selectedIndex]
          : _page[_selectedIndex],
    );
  }
}
