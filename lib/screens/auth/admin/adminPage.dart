import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/auth/admin/dashboard.dart';
import 'package:flutterprojectfinal/screens/auth/admin/manageEventsPage.dart';
import 'package:flutterprojectfinal/screens/auth/admin/manageUsersPage.dart';
import 'package:flutterprojectfinal/screens/auth/admin/settingsPage.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String _currentPage = 'Dashboard';
  late FirebaseFirestore _firestore;
  int _numberOfUsers = 0;
  int _numberOfEvents = 0;
  int _numberOfOrganizers = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeFirestore().then((_) {
      _fetchData();
    });
  }

  Future<void> _initializeFirestore() async {
    await Firebase.initializeApp();
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> _fetchData() async {
    try {
      QuerySnapshot usersSnapshot = await _firestore.collection('users').get();
      QuerySnapshot eventsSnapshot =
          await _firestore.collection('events').get();
      QuerySnapshot organizersSnapshot =
          await _firestore.collection('organizers').get();

      setState(() {
        _numberOfUsers = usersSnapshot.size;
        _numberOfEvents = eventsSnapshot.size;
        _numberOfOrganizers = organizersSnapshot.size;
        _isLoading = false;
      });
    } catch (error) {
      print("Error fetching data: $error");
    }
  }

  void _navigateTo(String pageName) {
    setState(() {
      _currentPage = pageName;
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget pageContent;
    switch (_currentPage) {
      case 'Dashboard':
        pageContent = DashboardPage();
        break;
      case 'Manage Events':
        pageContent = ManageEventsPage();
        break;
      case 'Manage Users':
        pageContent = ManageUsersPage();
        break;
      case 'Settings':
        pageContent = SettingsPage();
        break;
      default:
        pageContent = DashboardPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page - $_currentPage'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Event Finder Admin',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: Text('Dashboard'),
              onTap: () => _navigateTo('Dashboard'),
            ),
            ListTile(
              title: Text('Manage Events'),
              onTap: () => _navigateTo('Manage Events'),
            ),
            ListTile(
              title: Text('Manage Users'),
              onTap: () => _navigateTo('Manage Users'),
            ),
            ListTile(
              title: Text('Settings'),
              onTap: () => _navigateTo('Settings'),
            ),
          ],
        ),
      ),
      body: _isLoading ? _buildLoadingIndicator() : pageContent,
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
