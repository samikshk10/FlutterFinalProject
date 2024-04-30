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
  String? location, duration, createdAt;
  String eventId;

  EventModel(
      {required this.eventId,
      required this.title,
      required this.description,
      this.location,
      this.duration,
      required this.startDate,
      required this.endDate,
      required this.startTime,
      required this.endTime,
      required this.category,
      required this.imageUrl,
      this.longitude,
      this.latitude,
      this.createdAt});

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
        location: data['location'],
        longitude: data['longitude'],
        latitude: data['latitude'],
        duration: data['duration'],
        createdAt: data['createdAt']);
  }

  factory EventModel.fromMap(Map<String, dynamic> data) {
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
        location: data['location'],
        longitude: data['longitude'],
        latitude: data['latitude'],
        duration: data['duration'],
        createdAt: data['createdAt']);
  }
}
