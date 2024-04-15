import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';
import 'package:flutterprojectfinal/widgets/pickers/datetimepicker.dart';
import 'package:flutterprojectfinal/widgets/pickers/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart' as Dio;
import 'package:firebase_storage/firebase_storage.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  File? _selectedFile;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _punchLine1Controller = TextEditingController();
  TextEditingController _punchLine2Controller = TextEditingController();
  TextEditingController _filePickerController = TextEditingController();

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;

  bool isOneDayEvent = true;
  List<String> dates = [];

  UploadTask? uploadTask;
// Inside the onPressed callback of your "Add Event" button
  void _addEvent() async {
    // Check if an image is selected
    if (_selectedFile == null) {
      // Show an error message and return if no image is selected
      print("Please select an image.");
      return;
    }
    String fileName =
        'event_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    // Reference to the Firebase Storage bucket
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('event_images/thumbnail/${fileName}');
    setState(() {
      uploadTask = ref.putFile(_selectedFile!);
    });

    // Upload the file to Firebase Storage

    final snapshot = await uploadTask!.whenComplete(() {});

    final imageUrl = await snapshot.ref.getDownloadURL();
    print('Download link>>> $imageUrl');
    setState(() {
      uploadTask = null;
    });

    // Reference to the Firestore collection
    CollectionReference events =
        FirebaseFirestore.instance.collection('events');

    // Add the event data to Firestore
    events.add({
      'title': _titleController.text,
      'description': _descriptionController.text,
      'location': _locationController.text,
      'duration': _durationController.text,
      'punchLine1': _punchLine1Controller.text,
      'punchLine2': _punchLine2Controller.text,
      'startDate': _startDate != null ? _startDate!.toIso8601String() : null,
      'endDate': _endDate != null ? _endDate!.toIso8601String() : null,
      'startTime': _startTime != null ? _startTime!.format(context) : null,
      'endTime': _endTime != null ? _endTime!.format(context) : null,
      'imageUrl': imageUrl, // Store the download URL of the image
      // Add other fields as needed
    }).then((value) {
      // Show success message or navigate to another screen
      print("Event added successfully!");
    }).catchError((error) {
      // Show error message
      print("Failed to add event: $error");
    });
  }

  Future<void> pickThumbnailImage() async {
    try {
      PlatformFile? pickedFile = await ETFilePicker.selectAnImage();
      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path!);
          _filePickerController.text = _selectedFile!.path.split('/').last;
        });
      } else {
        // User canceled image selection

        FlashMessage(false, message: 'No image selected');
      }
    } catch (error) {
      // Handle any errors occurred during image selection
      FlashMessage(false, message: error.toString());
    }
  }

  void pickDate(BuildContext context) async {
    dates = isOneDayEvent
        ? await DateTimePicker.datePicker(context)
        : await DateTimePicker.dateRangePicker(context);
    print("this is dates $dates");
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
      ),
      dialogBackgroundColor: Colors.white,
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: theme, child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked;
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final ThemeData theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
      ),
      dialogBackgroundColor: Colors.white,
    );
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: theme, child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
      ),
      dialogBackgroundColor: Colors.white,
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: theme, child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        _startTime = picked;
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final ThemeData theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
      ),
      dialogBackgroundColor: Colors.white,
    );
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: theme, child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  SizedBox(height: 8),
                  customFormField(
                    controller: _titleController,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Title cannot be empty';
                      }
                      return null;
                    },
                    label: 'Title',
                    prefix: Icons.title,
                  ),
                  SizedBox(height: 16),
                  customFormField(
                    controller: _descriptionController,
                    type: TextInputType.text,
                    maxLines: 5,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Description cannot be empty';
                      }
                      return null;
                    },
                    label: 'Description',
                  ),
                  SizedBox(height: 16),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: customFormField(
                              controller: _locationController,
                              type: TextInputType.text,
                              readonly: true,
                              validate: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Location cannot be empty';
                                }
                                return null;
                              },
                              label: 'Location',
                              prefix: Icons.location_on,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.location_on),
                            onPressed: () {
                              // Add your location button functionality here
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  customFormField(
                    controller: _durationController,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Duration cannot be empty';
                      }
                      return null;
                    },
                    label: 'Duration',
                    prefix: Icons.access_time,
                  ),
                  SizedBox(height: 16),
                  customFormField(
                    controller: _punchLine1Controller,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Punch Line 1 cannot be empty';
                      }
                      return null;
                    },
                    label: 'Punch Line 1',
                    prefix: Icons.format_quote,
                  ),
                  SizedBox(height: 16),
                  customFormField(
                    controller: _punchLine2Controller,
                    type: TextInputType.text,
                    validate: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Punch Line 2 cannot be empty';
                      }
                      return null;
                    },
                    label: 'Punch Line 2',
                    prefix: Icons.format_quote,
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: ListTile(
                            title: const Text('Start Date'),
                            subtitle: Text(_startDate != null
                                ? DateFormat.yMd().format(_startDate!)
                                : 'Not set'),
                            leading: IconButton(
                              icon: const Icon(
                                Icons.calendar_today,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () => _selectStartDate(context),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ListTile(
                            title: const Text('End Date'),
                            subtitle: Text(_endDate != null
                                ? DateFormat.yMd().format(_endDate!)
                                : 'Not set'),
                            leading: IconButton(
                              icon: const Icon(
                                Icons.calendar_today,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () => _selectEndDate(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          child: ListTile(
                            title: const Text('Start Time'),
                            subtitle: Text(_startTime != null
                                ? _startTime!.format(context)
                                : 'Not set'),
                            leading: IconButton(
                              icon: const Icon(
                                Icons.access_time,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () => _selectStartTime(context),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          child: ListTile(
                            title: const Text('End Time'),
                            subtitle: Text(_endTime != null
                                ? _endTime!.format(context)
                                : 'Not set'),
                            leading: IconButton(
                              icon: const Icon(
                                Icons.access_time,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () => _selectEndTime(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Stack(
                    children: [
                      _selectedFile != null
                          ? Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: FileImage(_selectedFile!),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            )
                          : Container(
                              height: 200,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                image: DecorationImage(
                                  image: Image.asset('assets/images/photo.png')
                                      .image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          width: 36,
                          height: 36,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 3,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _selectedFile = null;
                                  _filePickerController.text =
                                      ''; // Reset file path field
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: customFormField(
                          controller: _filePickerController,
                          type: TextInputType.text,
                          readonly: true,
                          validate: (value) {
                            if (value == null || value.isEmpty) {
                              return 'File path cannot be empty';
                            }
                            return null;
                          },
                          label: 'Pick a thumbnail Image',
                          prefix: Icons.attach_file,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.attach_file),
                        onPressed: () async {
                          pickThumbnailImage();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildProgress(),
            CustomButton(label: 'Add Event', press: _addEvent),
          ],
        ),
      ),
    );
  }

  Widget _buildProgress() => StreamBuilder<TaskSnapshot>(
        stream: uploadTask?.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data;
            final progress = snap!.bytesTransferred / snap.totalBytes;
            return Text('${(progress * 100).toStringAsFixed(2)}%');
          } else {
            return Text('0%');
          }
        },
      );
}
