import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  bool isLoading = true;
  Map<String, EventModel> events = {};

  @override
  void initState() {
    super.initState();
    // Call getFavourites only if isLoading is true
    if (isLoading) {
      getFavourites();
    }
  }

  Future<void> getFavourites() async {
    CollectionReference favouriteEvents =
        FirebaseFirestore.instance.collection('favouriteEvents');
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final snapshot =
        await favouriteEvents.where('userId', isEqualTo: currentUserUid).get();
    for (var doc in snapshot.docs) {
      final eventId = doc['event'];
      final eventSnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventId', isEqualTo: eventId)
          .get();
      if (!eventSnapshot.isNullOrEmpty) {
        final eventData = eventSnapshot.docs.first.data();
        final event = EventModel.fromMap(eventData);
        events[eventId] = event;
      }
    }
    // Set isLoading to false only after data fetching is complete
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(events);
    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Page'),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : events.isEmpty
              ? Center(
                  child: Text('No favorite events.'),
                )
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final eventId = events.keys.toList()[index];
                    print("here $eventId");
                    final event = events[eventId]!;
                    return ListTile(
                      title: Text(event.title),
                      // Add more details about the event if needed
                    );
                  },
                ),
    );
  }
}
