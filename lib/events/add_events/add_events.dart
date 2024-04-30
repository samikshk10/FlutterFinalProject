import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutterprojectfinal/app/configs/categoriesList.dart';
import 'package:flutterprojectfinal/screens/widgets/location.dart';
import 'package:geocoding/geocoding.dart';

import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';

import 'package:flutterprojectfinal/validators/eventsValidator.dart';
import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';
import 'package:flutterprojectfinal/widgets/pickers/datetimepicker.dart';
import 'package:flutterprojectfinal/widgets/pickers/file_picker.dart';
import 'package:intl/intl.dart';

import 'package:firebase_storage/firebase_storage.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _selectedFile;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _filePickerController = TextEditingController();
  bool _isOneDayEvent = false;

  String EventDuration = "";

  DateTime? _startDate;
  DateTime? _endDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  bool isLoading = false;
  String _dateErrorText = "";
  String _timeErrorText = "";

  double? _longitude, _latitude;

  List<String> dates = [];

  UploadTask? uploadTask;
  List<String> categories = CategoryList().categories;

  String? _selectedCategory;
  String calculateEventDuration(DateTime? startDate, DateTime? endDate,
      TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startDate == null ||
        endDate == null ||
        startTime == null ||
        endTime == null) {
      return ''; // Return empty string if any of the values are null
    }

    // Calculate the difference in days and hours between start and end date times
    final difference = endDate.difference(startDate).inHours +
        endTime.hour -
        startTime.hour -
        (endDate.hour - startDate.hour) * 24;

    // Calculate days and hours
    final days = difference ~/ 24;
    final hours = difference % 24;

    // Build the duration string
    String duration = '';
    if (days > 0) {
      duration += '${days}D';
    }
    if (hours > 0) {
      if (duration.isNotEmpty) {
        duration += ' ';
      }
      duration += '${hours}H';
    }

    return duration;
  }

  void _resetForm() {
    _formKey.currentState?.reset();
    _titleController.clear();
    _descriptionController.clear();
    _locationController.clear();
    _filePickerController.clear();
    _selectedFile = null;
    _startDate = null;
    _endDate = null;
    _startTime = null;
    _endTime = null;
    _isOneDayEvent = false;
    _selectedCategory = null;
    _dateErrorText = "";
    _timeErrorText = "";
  }

// Inside the onPressed callback of your "Add Event" button
  void _addEvent() async {
    bool dateError = false;
    bool timeError = false;

    if (_startDate.isNullOrEmpty || _endDate.isNullOrEmpty) {
      setState(() {
        dateError = true;
      });
    }

    if (_startTime.isNullOrEmpty || _endTime.isNullOrEmpty) {
      setState(() {
        timeError = true;
      });
    }

    if (dateError || timeError) {
      setState(() {
        _dateErrorText = dateError ? "Please select date" : "";
        _timeErrorText = timeError ? "Please select time" : "";
      });
      return;
    }
    String fileName =
        'event_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    Reference ref = FirebaseStorage.instance
        .ref()
        .child('event_images/thumbnail/${fileName}');
    setState(() {
      uploadTask = ref.putFile(_selectedFile!);
      isLoading = true;
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

    String _eventDuration =
        calculateEventDuration(_startDate, _endDate, _startTime, _endTime);
    print(FirebaseAuth.instance.currentUser!.uid);
    // Add the event data to Firestore
    events.add({
      'eventId': DateTime.now().millisecondsSinceEpoch.toString(),
      'title': _titleController.text,
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'description': _descriptionController.text,
      'location': _locationController.text,
      'duration': _eventDuration,
      'startDate': _startDate != null ? _startDate!.toIso8601String() : null,
      'endDate': _endDate != null ? _endDate!.toIso8601String() : null,
      'startTime': _startTime != null ? _startTime!.format(context) : null,
      'endTime': _endTime != null ? _endTime!.format(context) : null,
      'imageUrl': imageUrl,
      'category': _selectedCategory,
      'longitude': _longitude.isNullOrEmpty ? null : _longitude,
      'latitude': _latitude.isNullOrEmpty ? null : _latitude
    }).then((value) {
      // Show success message or navigate to another screen
      FlashMessage.show(context,
          message: "Event added successfully!", isSuccess: true);
      _resetForm();
      print("Event added successfully!");
    }).catchError((error) {
      // Show error message
      FlashMessage.show(context,
          message: "Error adding event please try again!");
      print("Failed to add event: $error");
    }).whenComplete(() {
      setState(() {
        isLoading = false; // Set isLoading to false after completing the task
      });
    });
  }

  Future<void> pickThumbnailImage(BuildContext context) async {
    try {
      PlatformFile? pickedFile = await ETFilePicker.selectAnImage(context);
      if (pickedFile != null) {
        setState(() {
          _selectedFile = File(pickedFile.path!);
          _filePickerController.text = _selectedFile!.path.split('/').last;
        });
      } else {
        // User canceled image selection

        FlashMessage.show(context, message: "No image selected");
      }
    } catch (error) {
      // Handle any errors occurred during image selection
      FlashMessage.show(context, message: error.toString());
    }
  }

  Future<List<String>> pickDate(BuildContext context) async {
    dates = _isOneDayEvent
        ? await DateTimePicker.datePicker(context)
        : await DateTimePicker.dateRangePicker(context);
    return dates;
  }

  Future<List<String>> _selectTimeRange(BuildContext context) async {
    final ThemeData theme = Theme.of(context).copyWith(
      colorScheme: ColorScheme.fromSwatch(
        primarySwatch: Colors.deepPurple,
      ),
      dialogBackgroundColor: Colors.white,
    );

    TimeOfDay? startTime = await showTimePicker(
      context: context,
      initialTime: _startTime ?? TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: theme,
          child: Builder(
            builder: (BuildContext context) {
              return child!;
            },
          ),
        );
      },
    );

    if (startTime != null) {
      TimeOfDay? endTime = await showTimePicker(
        context: context,
        initialTime: _endTime ?? TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: theme,
            child: Builder(
              builder: (BuildContext context) {
                return child!;
              },
            ),
          );
        },
      );

      if (endTime != null) {
        setState(() {
          _startTime = startTime;
          _endTime = endTime;
        });

        String startString = _startTime!.format(context);
        String endString = _endTime!.format(context);

        return [startString, endString];
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
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
                      controller: _titleController,
                      type: TextInputType.text,
                      validate: (String? value) {
                        final errors =
                            eventSchema.catchErrors({"title": value});
                        return errors["title"];
                      },
                      label: 'Title',
                      prefix: Icons.title,
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
                      label: 'Description',
                    ),
                    SizedBox(height: 16),

                    // Dropdown for event categories
                    DropdownButtonFormField<String>(
                      value: _selectedCategory,
                      onChanged: (String? value) {
                        setState(() {
                          _selectedCategory = value;
                        });
                      },
                      items: categories.map((String category) {
                        return DropdownMenuItem<String>(
                          value: category,
                          child: Text(category),
                        );
                      }).toList(),
                      decoration: InputDecoration(
                        labelText: 'Select Category',
                        prefixIcon: Icon(Icons.category),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please select a category';
                        }
                        return null;
                      },
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
                                validate: (String? value) {
                                  final errors = eventSchema
                                      .catchErrors({"location": value});
                                  return errors["location"];
                                },
                                label: 'Location',
                                prefix: Icons.location_on,
                              ),
                            ),
                            IconButton(
                              icon: Icon(Icons.location_on),
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LocationFind()),
                                ) as Map<String, double>?;

                                if (result != null) {
                                  _latitude = result['lat'];
                                  _longitude = result['long'];
                                  if (_latitude != null && _longitude != null) {
                                    List<Placemark> placemarks =
                                        await placemarkFromCoordinates(
                                            _latitude ?? 0, _longitude ?? 0);
                                    Placemark place = placemarks[0];

                                    setState(() {
                                      _locationController.text =
                                          "${place.street ?? "n/a"}, ${place.subLocality ?? "n/a"}, ${place.administrativeArea ?? "n/a"},${place.subAdministrativeArea ?? "n/a"}, ${place.country ?? "n/a"}";
                                    });
                                  }
                                } else {
                                  print("location is not pick");
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 16),

                    Row(
                      children: [
                        Text("Is it one day event"),
                        Checkbox(
                          value: _isOneDayEvent,
                          onChanged: (newValue) {
                            setState(() {
                              _isOneDayEvent = newValue!;
                            });
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Start Date'),
                              subtitle: Text(_startDate != null
                                  ? DateFormat.yMd().format(_startDate!)
                                  : 'Not set'),
                              leading: IconButton(
                                icon: const Icon(
                                  Icons.calendar_today,
                                  color: Colors.deepPurple,
                                ),
                                onPressed: () async {
                                  List<String> dates = await pickDate(context);
                                  if (dates.length == 0) {
                                    setState(() {
                                      _dateErrorText = "Please select a date";
                                    });
                                  } else if (dates.length == 1) {
                                    setState(() {
                                      _startDate = DateTime.parse(dates[0]);
                                      _endDate = DateTime.parse(dates[0]);
                                      _dateErrorText = "";
                                    });
                                  } else {
                                    setState(() {
                                      _startDate = DateTime.parse(dates[0]);
                                      _endDate = DateTime.parse(dates[1]);
                                      _dateErrorText = "";
                                    });
                                  }
                                },
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    _dateErrorText != ""
                        ? Text(
                            _dateErrorText,
                            style: TextStyle(color: Colors.red),
                          )
                        : Container(),

                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            child: ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: const Text('Start Time'),
                              subtitle: Text(_startTime != null
                                  ? _startTime!.format(context)
                                  : 'Not set'),
                              leading: IconButton(
                                  icon: const Icon(
                                    Icons.access_time,
                                    color: Colors.deepPurple,
                                  ),
                                  onPressed: () async {
                                    List<String> timeRange =
                                        await _selectTimeRange(context);
                                    if (timeRange.length == 0) {
                                      setState(() {
                                        _timeErrorText = "Please select a time";
                                      });
                                    } else {
                                      setState(() {
                                        print("hello");
                                        _timeErrorText = "";
                                        _startTime = TimeOfDay.fromDateTime(
                                            DateFormat.jm()
                                                .parse(timeRange[0]));
                                        _endTime = TimeOfDay.fromDateTime(
                                            DateFormat.jm()
                                                .parse(timeRange[1]));
                                      });
                                    }
                                  }),
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
                            ),
                          ),
                        ),
                      ],
                    ),
                    _timeErrorText != ""
                        ? Text(
                            _timeErrorText,
                            style: TextStyle(color: Colors.red),
                          )
                        : Container(),
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
                                    image:
                                        Image.asset('assets/images/photo.png')
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
                            validate: (String? value) {
                              final errors =
                                  eventSchema.catchErrors({"imageUrl": value});
                              return errors["imageUrl"];
                            },
                            label: 'Pick a thumbnail Image',
                            prefix: Icons.attach_file,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.attach_file),
                          onPressed: () async {
                            pickThumbnailImage(context);
                          },
                        ),
                      ],
                    ),
                    _buildProgress(),
                  ],
                ),
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
                          "Add Events",
                          style: TextStyle(fontSize: 20),
                        ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _addEvent();
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
