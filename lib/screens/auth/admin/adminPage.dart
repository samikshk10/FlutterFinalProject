import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String _currentPage = 'Dashboard';
  late FirebaseFirestore _firestore; // Declare Firestore instance
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
      // Fetch data from Firestore collections
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
      body: _buildPageContent(),
    );
  }

  Widget _buildPageContent() {
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else {
      switch (_currentPage) {
        case 'Manage Events':
          return _buildManageEventsPage();
        case 'Manage Users':
          return _buildManageUsersPage();
        case 'Settings':
          return _buildSettingsPage();
        default:
          return _buildDashboardPage();
      }
    }
  }

  Widget _buildDashboardPage() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Users',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$_numberOfUsers',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Events',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$_numberOfEvents',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Number of Organizers',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '$_numberOfOrganizers',
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageEventsPage() {
    return Center(
      child: Text('Manage Events Page'),
    );
  }

  Widget _buildManageUsersPage() {
    return Center(
      child: Text('Manage Users Page'),
    );
  }

  Widget _buildSettingsPage() {
    return Center(
      child: Text('Settings Page'),
    );
  }
}
