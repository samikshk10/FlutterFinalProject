import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/event.dart';

class FavouriteProvider extends ChangeNotifier {
  final List<Event> _favouriteEvents = [];
  List<Event> get favouriteEvents => _favouriteEvents;

  void toggleFavourite(Event event) {
    if (_favouriteEvents.contains(event)) {
      _favouriteEvents.remove(event);
    } else {
      _favouriteEvents.add(event);
    }
    notifyListeners();
  }

  void clearFavourite() {
    _favouriteEvents.clear();
    notifyListeners();
  }

  bool isExist(Event event) {
    final isExist = _favouriteEvents.contains(event);
    return isExist;
  }

  void addFavourite(Event event) {
    CollectionReference favouriteEvents =
        FirebaseFirestore.instance.collection('favouriteEvents');

    favouriteEvents.add({
      'event': event.eventId,
      'userId': FirebaseAuth.instance.currentUser!.uid,
    });
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
