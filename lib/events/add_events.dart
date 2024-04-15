import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/formField.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _durationController = TextEditingController();
  TextEditingController _punchLine1Controller = TextEditingController();
  TextEditingController _punchLine2Controller = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _longitudeController = TextEditingController();
  TextEditingController _latitudeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
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
            customFormField(
              controller: _descriptionController,
              type: TextInputType.text,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Description cannot be empty';
                }
                return null;
              },
              label: 'Description',
              prefix: Icons.description,
            ),
            customFormField(
              controller: _locationController,
              type: TextInputType.text,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Location cannot be empty';
                }
                return null;
              },
              label: 'Location',
              prefix: Icons.location_on,
            ),
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
            customFormField(
              controller: _dateController,
              type: TextInputType.datetime,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Date cannot be empty';
                }
                return null;
              },
              label: 'Date',
              prefix: Icons.calendar_today,
            ),
            customFormField(
              controller: _longitudeController,
              type: TextInputType.number,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Longitude cannot be empty';
                }
                return null;
              },
              label: 'Longitude',
              prefix: Icons.gps_fixed,
            ),
            customFormField(
              controller: _latitudeController,
              type: TextInputType.number,
              validate: (value) {
                if (value == null || value.isEmpty) {
                  return 'Latitude cannot be empty';
                }
                return null;
              },
              label: 'Latitude',
              prefix: Icons.gps_fixed,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle form submission here
              },
              child: Text('Add Event'),
            ),
          ],
        ),
      ),
    );
  }
}
