import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutterprojectfinal/validators/addOrganizerSchema.dart';

import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';

import 'package:flutterprojectfinal/validators/eventsValidator.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';

class AddOrganizerScreen extends StatefulWidget {
  @override
  _AddOrganizerScreenState createState() => _AddOrganizerScreenState();
}

class _AddOrganizerScreenState extends State<AddOrganizerScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  TextEditingController _organizationNameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _websiteController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();

  void _resetForm() {
    _formKey.currentState?.reset();
    _organizationNameController.clear();
    _descriptionController.clear();
    _websiteController.clear();
    _phoneNumberController.clear();
  }

// Inside the onPressed callback of your "Add Event" button
  void _addOrganizer() async {
    CollectionReference organizers =
        FirebaseFirestore.instance.collection('organizers');

    // Add the event data to Firestore
    organizers.add({
      'organizerId': FirebaseAuth.instance.currentUser!.uid,
      'description': _descriptionController.text,
      'organizerName': _organizationNameController.text,
      'phoneNumber': _phoneNumberController.text,
      'websiteUrl': _websiteController.text,
      'email': FirebaseAuth.instance.currentUser!.email,
      'name': FirebaseAuth.instance.currentUser!.displayName,
      'status': 'pending',
      'createdAt': FieldValue.serverTimestamp(),
    }).then((value) {
      // Show success message or navigate to another screen
      FlashMessage.show(context,
          message: "Organizer request has been sent",
          desc: "Please wait till it gets verified",
          isSuccess: true);
      _resetForm();
    }).catchError((error) {
      // Show error message
      FlashMessage.show(context,
          message: "Error sending request. please try again!");
    }).whenComplete(() {
      setState(() {
        isLoading = false; // Set isLoading to false after completing the task
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Be a Organizer'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    SizedBox(height: 8),
                    customFormField(
                      controller: _organizationNameController,
                      type: TextInputType.text,
                      validate: (String? value) {
                        final errors = addOrganizerSchema
                            .catchErrors({"organizerName": value});
                        return errors["organizerName"];
                      },
                      label: 'Organizer/Company Name',
                      prefix: Icons.person,
                    ),
                    SizedBox(height: 16),
                    customFormField(
                      controller: _descriptionController,
                      type: TextInputType.text,
                      maxLines: 5,
                      validate: (String? value) {
                        final errors =
                            eventSchema.catchErrors({"description": value});
                        return errors["description"];
                      },
                      label: 'Description/About Organizer',
                    ),
                    SizedBox(height: 16),
                    customFormField(
                      controller: _phoneNumberController,
                      type: TextInputType.text,
                      validate: (String? value) {
                        final errors = addOrganizerSchema
                            .catchErrors({"phoneNumber": value});
                        return errors["phoneNumber"];
                      },
                      label: 'Phone Number',
                      prefix: Icons.phone,
                    ),
                    SizedBox(height: 16),
                    customFormField(
                      controller: _websiteController,
                      type: TextInputType.text,
                      validate: (String? value) {
                        final errors = addOrganizerSchema
                            .catchErrors({"websiteUrl": value});
                        return errors["websiteUrl"];
                      },
                      label: 'WebsiteUrl',
                      prefix: Icons.web,
                    ),
                  ],
                ),
              ),
              isLoading
                  ? CircularProgressIndicator()
                  : Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10)),
                        child: Text(
                          "Send Request",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _addOrganizer();
                          }
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }
}
