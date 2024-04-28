import 'package:cloud_firestore/cloud_firestore.dart';

class OrganizerModel {
  String organizerId,
      description,
      organizerName,
      phoneNumber,
      email,
      name,
      status;
  String? websiteUrl;
  Timestamp createdAt;
  OrganizerModel(
      {required this.organizerId,
      required this.description,
      required this.organizerName,
      required this.phoneNumber,
      this.websiteUrl,
      required this.email,
      required this.name,
      required this.status,
      required this.createdAt});

  // Factory method to create Event instance from Firestore document snapshot
  factory OrganizerModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return OrganizerModel(
      organizerId: data['organizerId'],
      description: data['description'],
      organizerName: data['organizerName'],
      phoneNumber: data['phoneNumber'],
      websiteUrl: data['websiteUrl'],
      email: data['email'],
      name: data['name'],
      status: data['status'],
      createdAt: data['createdAt'],
    );
  }

  factory OrganizerModel.fromMap(Map<String, dynamic> data) {
    return OrganizerModel(
      organizerId: data['organizerId'],
      description: data['description'],
      organizerName: data['organizerName'],
      phoneNumber: data['phoneNumber'],
      websiteUrl: data['websiteUrl'],
      email: data['email'],
      name: data['name'],
      status: data['status'],
      createdAt: data['createdAt'],
    );
  }
}
