import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterprojectfinal/services/provider/userCredentialProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../resourcecs/add_data.dart';
import '../../utils/pickImage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;
  TextEditingController _nameController = TextEditingController();

  void _selectImage() async {
    print('called');
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  void _saveProfile(BuildContext context) async {
    print(_nameController.text);
    // String resp = await StoreData().saveData(file: _image!);
    // Access the UserCredential from the provider

    auth.UserCredential? userCredential =
        Provider.of<UserCredentialProvider>(context, listen: false)
            .userCredential;

    if (userCredential != null) {
      // Use the userCredential object
      await userCredential.user?.updateDisplayName(_nameController.text);
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController.text =
        auth.FirebaseAuth.instance.currentUser?.displayName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Details'),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Stack(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 65, backgroundImage: MemoryImage(_image!))
                    : CircleAvatar(
                        radius: 65,
                        backgroundImage: AssetImage('assets/images/admin.png'),
                      ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: IconButton(
                    onPressed: () {
                      _selectImage();
                    },
                    icon: Icon(Icons.add_a_photo),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Text(
                'Name',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              onTap: () {},
              tileColor: Colors.grey[200],
              title: TextFormField(
                controller: _nameController,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  _saveProfile(context);
                  Navigator.pop(context, _nameController.text);
                },
                child: Text('Save Changes'))
          ],
        ),
      ),
    );
  }
}
