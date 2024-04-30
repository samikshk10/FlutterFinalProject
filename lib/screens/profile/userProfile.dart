import 'dart:typed_data';

import 'package:ez_validator/ez_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/organizer/addorganizer.dart';
import 'package:flutterprojectfinal/screens/profile/changePassword.dart';
import 'package:flutterprojectfinal/screens/profile/editProfile.dart';
import 'package:flutterprojectfinal/screens/profile/favouritePage.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});
  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  String? displayName = FirebaseAuth.instance.currentUser?.displayName;
  String? photoURL = "";
  bool? isOrganizer = false;
  void updateProfileImage() {
    setState(() {
      photoURL = FirebaseAuth.instance.currentUser?.photoURL;
    });
  }

  void didUpdateWidget(UserProfile oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      displayName = FirebaseAuth.instance.currentUser?.displayName;
    });
    print('First Screen is visible again');
  }

  @override
  void initState() {
    super.initState();
    checkOrganizer();
    updateProfileImage();
  }

  void checkOrganizer() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isOrganizer = preferences.getBool("isOrganizer") ?? false;
    });
  }

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut().then((value) async {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.clear();
        pref.remove("isOrganizer");
      });

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
                photoURL != null
                    ? CircleAvatar(
                        radius: 65,
                        backgroundImage: NetworkImage(photoURL ?? "sd"))
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
                  Center(
                    child: Text(
                      (FirebaseAuth.instance.currentUser != null
                          ? displayName ?? "User"
                          : "User"),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => EditProfile()));

                        updateProfileImage();
                        if (result['displayName'] != null) {
                          setState(() {
                            displayName = result['displayName'];
                          });
                        } else if (result['photoURL'] != null) {
                          setState(() {
                            photoURL = result['photoURL'];
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
            isOrganizer ?? false
                ? SizedBox.shrink()
                : ListTile(
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
              title: Text('Favourites'),
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
              title: Text('Change Password'),
              tileColor: lightGray,
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ChangePasswordPage()));
              },
              leading: Icon(Icons.settings),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            SizedBox(height: 10),
            Expanded(child: SizedBox()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                child: Text(
                  "Logout",
                  style: TextStyle(fontSize: 20),
                ),
                onPressed: () {
                  confirmLogOut(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> confirmLogOut(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to logout?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
            TextButton(
              onPressed: () => _logout(),
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
