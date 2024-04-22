import 'package:cloud_firestore/cloud_firestore.dart';

class EventModel {
  String title,
      description,
      startDate,
      endDate,
      startTime,
      endTime,
      category,
      imageUrl;

  double? longitude, latitude;
  String? punchLine, location;
  bool isOnlineEvent;
  String eventId;

  EventModel(
      {required this.eventId,
      required this.title,
      required this.description,
      required this.isOnlineEvent,
      this.location,
      required this.startDate,
      required this.endDate,
      required this.startTime,
      required this.endTime,
      this.punchLine,
      required this.category,
      required this.imageUrl,
      this.longitude,
      this.latitude});

  // Factory method to create Event instance from Firestore document snapshot
  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return EventModel(
      eventId: data['eventId'],
      title: data['title'],
      description: data['description'],
      startDate: data['startDate'],
      endDate: data['endDate'],
      startTime: data['startTime'],
      endTime: data['endTime'],
      category: data['category'],
      imageUrl: data['imageUrl'],
      isOnlineEvent: data['isOnlineEvent'],
      location: data['location'],
      punchLine: data['punchLine'],
      longitude: data['longitude'],
      latitude: data['latitude'],
    );
  }
}
