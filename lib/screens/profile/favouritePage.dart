import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ez_validator/ez_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/screens/customWidgets/manageEventsTile.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart';
import 'package:flutterprojectfinal/ui/event_detail/event_details.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  bool isLoading = false;
  Map<String, EventModel> events = {};

  @override
  void initState() {
    super.initState();

    getFavourites();
  }

  Future<void> getFavourites() async {
    setState(() {
      isLoading = true;
    });
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
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(events);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          'Your Favourites',
          style: TextStyle(color: Colors.black),
        ),
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
                    final event = events[eventId]!;
                    return ManageEventsTile(
                        deleteDialogContent:
                            "Are you sure you want to remove from Favourite?",
                        title: event.title,
                        date: event.startDate,
                        location: event.location ?? "not specified",
                        imageUrl: event.imageUrl,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailPage(
                                eventModel: events[eventId]!,
                                provider:
                                    Provider.of<FavouriteProvider>(context),
                                key: Key('event_details_${event.title}'),
                              ),
                            ),
                          );
                        },
                        onDeleteConfirmed: () {
                          Provider.of<FavouriteProvider>(context, listen: false)
                              .removeFavourite(event.eventId);
                        },
                        onDelete: () {});
                  },
                ),
    );
  }
}
