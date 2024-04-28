import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/events/add_events/add_events.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/screens/customWidgets/manageEventsTile.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart';
import 'package:flutterprojectfinal/ui/event_detail/event_details.dart';
import 'package:provider/provider.dart';

class ManageEventsPage extends StatefulWidget {
  @override
  State<ManageEventsPage> createState() => _ManageEventsPageState();
}

class _ManageEventsPageState extends State<ManageEventsPage> {
  Future<List<EventModel>> _fetchUserEvents() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();
    print(FirebaseAuth.instance.currentUser!.uid);
    return querySnapshot.docs
        .where((doc) => doc['userId'] == FirebaseAuth.instance.currentUser!.uid)
        .map((doc) => EventModel.fromFirestore(doc))
        .toList();
  }

  @override
  void initState() {
    super.initState();
    _fetchUserEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 40),
            child: Center(
              child: Container(
                child: Text(
                  'Your Events',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<EventModel>>(
              future: _fetchUserEvents(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  return Center(child: Text('No events found'));
                } else {
                  List<EventModel> events = snapshot.data as List<EventModel>;
                  return ListView.builder(
                    itemCount: events.length,
                    itemBuilder: (context, index) {
                      final event = events[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ManageEventsTile(
                          title: event.title,
                          date: event.startDate,
                          location: event.location ?? "not specified",
                          imageUrl: event.imageUrl,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DetailPage(
                                  eventModel: events[index],
                                  provider:
                                      Provider.of<FavouriteProvider>(context),
                                  key: Key('event_details_${event.title}'),
                                ),
                              ),
                            );
                          },
                          onDelete: () {},
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          // Navigate to the screen to add events
          // For example:
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => AddEventScreen()));
        },
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
