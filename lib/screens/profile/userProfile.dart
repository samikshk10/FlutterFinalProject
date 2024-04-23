import 'dart:typed_data';

import 'package:ez_validator/ez_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/organizer/addorganizer.dart';
import 'package:flutterprojectfinal/screens/profile/editProfile.dart';
import 'package:flutterprojectfinal/screens/profile/favouritePage.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? displayName = FirebaseAuth.instance.currentUser?.displayName;
  void didUpdateWidget(UserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      displayName = FirebaseAuth.instance.currentUser?.displayName;
    });
    print('First Screen is visible again');
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/');
    } catch (e) {
      print("Error occurred during logout: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 30),
            Stack(
              children: [
                FirebaseAuth.instance.currentUser?.photoURL != null
                    ? CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(
                            FirebaseAuth.instance.currentUser?.photoURL ??
                                "sd"))
                    : CircleAvatar(
                        radius: 65,
                        backgroundImage: AssetImage('assets/images/admin.png'),
                      ),
              ],
            ),
            Center(
              child: Row(
                children: [
                  SizedBox(
                    width: 100,
                  ),
                  Text(
                    (FirebaseAuth.instance.currentUser != null
                        ? displayName ?? "User"
                        : "User"),
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () async {
                        final name = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile()));
                        if (name != null) {
                          setState(() {
                            displayName = name;
                          });
                        }
                      },
                      icon: Icon(Icons.edit)),
                ],
              ),
            ),
            Text(
              (FirebaseAuth.instance.currentUser != null
                  ? FirebaseAuth.instance.currentUser!.email ?? "ANONYMOUS"
                  : "ANONYMOUS"),
              style: TextStyle(fontSize: 15, color: gray),
            ),
            SizedBox(
              height: 40,
            ),
            ListTile(
              title: Text('Be a Organizer'),
              tileColor: lightGray,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddOrganizerScreen()));
              },
              leading: Icon(Icons.person_add_alt_1_rounded),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Following'),
              tileColor: lightGray,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavouritePage()));
              },
              leading: Icon(Icons.favorite),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Settings'),
              tileColor: lightGray,
              onTap: () {},
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            SizedBox(height: 10),
            Expanded(child: SizedBox()),
            CustomButton(label: 'Logout', press: _logout)
          ],
        ),
      ),
    );
  }
}
