import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/auth/admin/dashboard.dart';
import 'package:flutterprojectfinal/screens/auth/admin/manageEventsPage.dart';
import 'package:flutterprojectfinal/screens/auth/admin/changePasswordAdmin.dart';
import 'package:flutterprojectfinal/screens/auth/admin/organizer/organizer_request.dart';
import 'package:flutterprojectfinal/screens/auth/admin/settingsPage.dart';
import 'package:flutterprojectfinal/screens/auth/auth_page.dart';
import 'package:flutterprojectfinal/services/auth.dart';

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
      QuerySnapshot organizersSnapshot = await _firestore
          .collection('organizers')
          .where("status", isEqualTo: "approved")
          .get();

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
    Widget? pageContent;
    switch (_currentPage) {
      case 'Dashboard':
        pageContent = DashboardPage();
        break;

      case 'Organizer Request':
        pageContent = OrganizerRequestCard();
        break;
      case 'Change Password':
        pageContent = ChangePasswordAdmin();
        break;
      case 'LogOut':
        pageContent = Container();
        break;

      default:
        pageContent = DashboardPage();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Admin - $_currentPage'),
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
                'Event Sphere Admin',
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
              title: Text('Organizer Request'),
              onTap: () => _navigateTo('Organizer Request'),
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () => _navigateTo('Change Password'),
            ),
            ListTile(
                title: Text("Logout"),
                onTap: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => Authpage()));
                }),
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
