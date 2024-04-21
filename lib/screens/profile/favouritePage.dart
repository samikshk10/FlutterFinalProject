import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  void initState() {
    super.initState();
    getFavourites();
  }

  Future<Event> getFavourites() async {
    CollectionReference favouriteEvents =
        FirebaseFirestore.instance.collection('favouriteEvents');

    final snapshot = await favouriteEvents
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get();

    final List<Event> events = [];
    for (var doc in snapshot.docs) {
      final eventId = doc['event'];
      final event = await FirebaseFirestore.instance
          .collection('events')
          .doc(eventId)
          .get();
      print("hello::${event.data()}");
      print("snapshotData:${doc.data()}");
    }

    return events[0];
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);
    final events = provider.favouriteEvents;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favourite Page'),
      ),
      body: events.isEmpty
          ? Center(
              child: Text('No favorite events.'),
            )
          : ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                final event = events[index];
                return ListTile(
                  title: Text(event.title),
                  // Add more details about the event if needed
                );
              },
            ),
    );
  }
}
