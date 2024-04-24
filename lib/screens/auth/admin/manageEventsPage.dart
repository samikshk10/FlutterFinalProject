import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/screens/customWidgets/manageEventsTile.dart';

class ManageEventsPage extends StatelessWidget {
  final List<Map<String, String>> events = [
    {
      'title': 'Event 1',
      'date': '2022/04/20',
      'location': 'Location 1',
      'imageUrl': 'https://picsum.photos/250?image=1',
    },
    {
      'title': 'Event 2',
      'date': '2022/04/21',
      'location': 'Location 2',
      'imageUrl': 'https://picsum.photos/250?image=2',
    },
    {
      'title': 'Event 3',
      'date': '2022/04/22',
      'location': 'Location 3',
      'imageUrl': 'https://picsum.photos/250?image=3',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ManageEventsTile(
              title: event['title']!,
              date: event['date']!,
              location: event['location']!,
              imageUrl: event['imageUrl']!,
              onTap: () {
                print('Tapped on ${event['title']}');
              },
              onDelete: () {
                print('Deleted ${event['title']}');
              },
            ),
          );
        },
      ),
    );
  }
}
