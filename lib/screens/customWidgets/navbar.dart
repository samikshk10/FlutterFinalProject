import 'package:flutter/material.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // You can put your navigation logic here
      switch (index) {
        case 0:
          Navigator.pushNamed(context, '/');
          break;
        case 1:
          Navigator.pushNamed(context, '/signup');
          break;
        case 2:
          Navigator.pushNamed(context, '/');
          break;
        case 3:
          Navigator.pushNamed(context, '/signup');
          break;
        default:
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 60,
      elevation: 0,
      animationDuration: const Duration(seconds: 3),
      labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
      selectedIndex: _selectedIndex,
      backgroundColor: Colors.white,
      onDestinationSelected: _onItemTapped,
      destinations: [
        NavigationDestination(
          icon: Icon(
            Icons.home,
          ),
          label: "Home",
        ),
        NavigationDestination(
          icon: Icon(Icons.person),
          label: "User",
        ),
        NavigationDestination(icon: Icon(Icons.event), label: "Event"),
        NavigationDestination(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
