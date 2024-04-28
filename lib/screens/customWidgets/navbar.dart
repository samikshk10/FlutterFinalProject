import 'package:flutter/material.dart';

class MyNavigationBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped;
  final bool isLoggedInAsOrganizer;

  const MyNavigationBar({
    Key? key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.isLoggedInAsOrganizer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
        height: 60,
        elevation: 0,
        animationDuration: const Duration(seconds: 3),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysHide,
        selectedIndex: selectedIndex,
        backgroundColor: Colors.white,
        onDestinationSelected: onItemTapped,
        destinations: isLoggedInAsOrganizer
            ? [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.search),
                  label: "User",
                ),
                NavigationDestination(
                  icon: Icon(Icons.event),
                  label: "Event",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ]
            : [
                NavigationDestination(
                  icon: Icon(Icons.home),
                  label: "Home",
                ),
                NavigationDestination(
                  icon: Icon(Icons.search),
                  label: "User",
                ),
                NavigationDestination(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ]);
  }
}
