import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/utils/constant.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/utils/pickImage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutterprojectfinal/resourcecs/add_data.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  Uint8List? _image;
  void _selectImage() async{
    print('called');
     Uint8List img = await pickImage(ImageSource.gallery);
     setState(() {
       _image = img;
     });
  }
  void _saveProfile()async{
    String resp = await StoreData().saveData(file: _image!);
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
                _image != null ? CircleAvatar(radius: 65,
                  backgroundImage: MemoryImage(_image!))  : CircleAvatar(
                  radius: 65,
                  backgroundImage: AssetImage('assets/images/admin.png'),
                ),
              ],
            ),
            Center(
              child: Row(
                children: [
                  SizedBox(width: 100,),
                  Text(
                    (FirebaseAuth.instance.currentUser != null
                        ? FirebaseAuth.instance.currentUser!.displayName ??
                        "ANONYMOUS"
                        : "ANONYMOUS"),
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  IconButton(onPressed: _selectImage, icon: Icon(Icons.edit)),
                ],
              ),
            ),
            Text( (FirebaseAuth.instance.currentUser != null
                ? FirebaseAuth.instance.currentUser!.email ??
                "ANONYMOUS"
                : "ANONYMOUS"),
              style: TextStyle(fontSize:15, color: gray),
            ),
            SizedBox(height: 40,),
            ListTile(
              title: Text('Notification Center'),
              tileColor: lightGray,
              onTap: (){},
              leading: Icon(Icons.notifications),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Following'),
              tileColor: lightGray,
              onTap: (){},
              leading: Icon(Icons.favorite),
              trailing: Icon(Icons.arrow_forward_ios_outlined),
            ),
            SizedBox(height: 10),
            ListTile(
              title: Text('Settings'),
              tileColor: lightGray,
              onTap: (){},
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
