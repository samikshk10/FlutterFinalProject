import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutterprojectfinal/services/provider/userCredentialProvider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../resourcecs/add_data.dart';
import '../../utils/pickImage.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({Key? key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  Uint8List? _image;
  String? imageUrl;
  String? displayName;
  bool isLoading = false;

  TextEditingController _nameController = TextEditingController();
  Future<String> uploadImage(Uint8List imageBytes, String userId) async {
    String filePath = 'profileimage/$userId';
    firebase_storage.Reference reference =
        firebase_storage.FirebaseStorage.instance.ref().child(filePath);
    await reference.putData(imageBytes);
    String downloadURL = await reference.getDownloadURL();
    return downloadURL;
  }

  void _selectImage() async {
    print('called');
    Uint8List img = await pickImage(ImageSource.gallery);
    setState(() {
      _image = img;
    });
  }

  Future<void> _saveProfile(BuildContext context) async {
    setState(() {
      isLoading = true;
    });
    String? userId = Provider.of<UserCredentialProvider>(context, listen: false)
        .userCredential
        ?.user
        ?.uid;
    auth.UserCredential? userCredential =
        Provider.of<UserCredentialProvider>(context, listen: false)
            .userCredential;
    if (userId != null && _image != null) {
      String downloadURL = await uploadImage(_image!, userId);
      userCredential?.user?.updatePhotoURL(downloadURL);
      setState(() {
        imageUrl = downloadURL;
      });
    }

    if (userCredential != null) {
      await userCredential.user
          ?.updateDisplayName(_nameController.text)
          .then((value) => setState(() {
                displayName = _nameController.text;
              }));
      setState(() {
        isLoading = false;
      });
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 10)),
                child: isLoading
                    ? CircularProgressIndicator()
                    : Text(
                        "Save Changes",
                        style: TextStyle(fontSize: 20),
                      ),
                onPressed: () {
                  _saveProfile(context).then((value) {
                    setState(() {
                      isLoading = false;
                    });
                    Navigator.pop(context, {
                      'displayName': _nameController.text,
                      'photoURL': imageUrl
                    });
                  });
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
