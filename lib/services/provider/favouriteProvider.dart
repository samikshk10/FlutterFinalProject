import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<EventModel> _favouriteEvents = [];
  List<EventModel> get favouriteEvents => _favouriteEvents;

  void toggleFavourite(EventModel event) async {
    final isFavourite = await isExist(event);
    if (isFavourite) {
      _favouriteEvents.removeWhere((e) => e.eventId == event.eventId);
      await removeFavourite(event.eventId);
    } else {
      _favouriteEvents.add(event);
      await addFavourite(event);
    }
    notifyListeners();
  }

  Future<void> removeFavourite(String eventId) async {
    print("inside remove");
    CollectionReference favouriteEvents =
        FirebaseFirestore.instance.collection('favouriteEvents');

    await favouriteEvents
        .doc('${FirebaseAuth.instance.currentUser!.uid}_$eventId')
        .delete();
  }

  Future<void> addFavourite(EventModel event) async {
    CollectionReference favouriteEvents =
        FirebaseFirestore.instance.collection('favouriteEvents');

    await favouriteEvents
        .doc('${FirebaseAuth.instance.currentUser!.uid}_${event.eventId}')
        .set({
      'event': event.eventId,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
  }

  void clearFavourite() {
    _favouriteEvents.clear();
    notifyListeners();
  }

  Future<bool> isExist(EventModel event) async {
    final CollectionReference favouriteEvents =
        FirebaseFirestore.instance.collection('favouriteEvents');

    final querySnapshot = await favouriteEvents
        .where('userId', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .where('event', isEqualTo: event.eventId)
        .limit(1)
        .get();

    return querySnapshot.docs.isNotEmpty;
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
      print(event.data());
    }

    return events[0];
  }
}
