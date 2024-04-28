// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:ez_validator/ez_validator.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutterprojectfinal/model/organizerModel.dart';
// import 'package:flutterprojectfinal/widgets/globalwidget/flashmessage.dart';

// class ManageUsersPage extends StatefulWidget {
//   @override
//   State<ManageUsersPage> createState() => _ManageUsersPageState();
// }

// enum userStatus { active, blocked }

// class _ManageUsersPageState extends State<ManageUsersPage> {
//   final userStatus status = userStatus.active;
//   userStatus _selectedStatus = userStatus.active;

//   Future<List<OrganizerModel>> _fetchOrganizer(userStatus status) async {
//     QuerySnapshot querySnapshot =
//         await FirebaseFirestore.instance.collection('organizers').get();

//     return querySnapshot.docs
//         .where((doc) => doc['status'].toString() == status.name)
//         .map((doc) => OrganizerModel.fromFirestore(doc))
//         .toList();
//   }

//   void _refreshOrganizers(userStatus status) async {
//     setState(() {
//       _selectedStatus = status;
//     });
//   }

//   Future<bool> onApprove(BuildContext context, OrganizerModel organizer) async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('organizers')
//         .where("organizerId", isEqualTo: organizer.organizerId)
//         .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       DocumentSnapshot organizerDoc = querySnapshot.docs.first;
//       String documentId = organizerDoc.id;

//       await FirebaseFirestore.instance
//           .collection('organizers')
//           .doc(documentId)
//           .update({'status': 'approved'});

//       _refreshOrganizers(OrganizerStatus
//           .approved); // Assuming pending requests are shown after rejection (optional, adjust as needed)
//       // Return true if organizer is approved
//       return true;
//     } else {
//       // Return false if organizer is not found
//       return false;
//     }
//   }

//   Future<bool> onReject(BuildContext context, OrganizerModel organizer) async {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection('organizers')
//         .where("organizerId", isEqualTo: organizer.organizerId)
//         .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       DocumentSnapshot organizerDoc = querySnapshot.docs.first;
//       String documentId = organizerDoc.id;
//       // Assuming pending requests are shown after rejection (optional, adjust as needed)

//       await FirebaseFirestore.instance
//           .collection('organizers')
//           .doc(documentId)
//           .update({'status': 'rejected'});
//       _refreshOrganizers(OrganizerStatus.rejected);

//       return true;
//     } else {
//       return false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: DefaultTabController(
//         length: 3, // Define the number of tabs

//         child: Stack(
//           children: [
//             SingleChildScrollView(
//               child: SafeArea(
//                 child: Padding(
//                   padding:
//                       const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 16),
//                       _buildTabBar(context), // New method to build tabs
//                       const SizedBox(height: 16),
//                       _buildTabs(),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showDialog(BuildContext context, OrganizerModel organizer) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("User Details"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () async {
//                 // Approve action
//                 bool isApproved = await onApprove(context, organizer);
//                 Navigator.of(context).pop();

//                 // Show flash message based on approval status
//                 if (isApproved) {
//                   FlashMessage.show(context,
//                       message: "Organizer Request has been approved",
//                       desc: organizer.email,
//                       isSuccess: true);
//                 } else {
//                   FlashMessage.show(context,
//                       message:
//                           "No organizer found with ID: ${organizer.organizerId}",
//                       isSuccess: false);
//                 }
//               },
//               child: Text(
//                 'Make Active',
//                 style: TextStyle(color: Colors.green),
//               ),
//             ),
//             TextButton(
//               onPressed: () async {
//                 bool isRejected = await onReject(context, organizer);
//                 Navigator.of(context).pop();

//                 // Show flash message based on approval status
//                 if (isRejected) {
//                   FlashMessage.show(context,
//                       message: "Organizer Request has been rejected",
//                       desc: organizer.email,
//                       isSuccess: false);
//                 } else {
//                   FlashMessage.show(context,
//                       message:
//                           "No organizer found with ID: ${organizer.organizerId}",
//                       isSuccess: false);
//                 }
//               },
//               child: Text(
//                 'Reject',
//                 style: TextStyle(color: Colors.red),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Widget _buildTabBar(BuildContext context) {
//     return Container(
//       width: double.infinity,
//       child: TabBar(
//         indicatorColor: Colors.black,
//         tabs: [
//           Tab(
//             text: "active",
//           ),
//           Tab(text: "blocked"),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabs() {
//     return Container(
//       height: 300, // Adjust height as needed
//       child: TabBarView(
//         children: [
//           // Contents of the first tab,

//           _buildListView(userStatus.active),
//           // Contents of the second tab
//           _buildListView(userStatus.blocked),
//           // Contents of the third tab
//         ],
//       ),
//     );
//   }

//   Widget _buildListView(userStatus status) {
//     setState(() {
//       _selectedStatus = status;
//     });

//     return FutureBuilder<List<OrganizerModel>>(
//       future: _fetchOrganizer(_selectedStatus),
//       builder:
//           (BuildContext context, AsyncSnapshot<List<OrganizerModel>> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Center(child: CircularProgressIndicator());
//         } else if (snapshot.hasError) {
//           return Text('Error: ${snapshot.error}');
//         } else {
//           List<OrganizerModel> organizers =
//               snapshot.data as List<OrganizerModel>;

//           if (organizers.isNullOrEmpty) {
//             return Center(child: Text('No requests found'));
//           }
//           SizedBox(height: 26);
//           return ListView.builder(
//             itemCount: organizers.length,
//             itemBuilder: (context, index) {
//               OrganizerModel organizer = organizers[index];
//               DateTime dt = organizer.createdAt.toDate();
//               return Container(
//                 padding: EdgeInsets.only(bottom: 12),
//                 child: Card(
//                   surfaceTintColor: Colors.transparent,

//                   elevation: 4.0, // Adjust shadow elevation as desired
//                   shadowColor: Colors.grey.withOpacity(0.5), // Set shadow color

//                   child: ListTile(
//                     onTap: () {
//                       // Show detailed information and action buttons
//                       _showDialog(context, organizer);
//                     },
//                     title: Text(organizer.organizerName),
//                     subtitle: Text(organizer.email),
//                     trailing: Text(dt
//                         .toString()), // Assuming createdAt is the date requested
//                   ),
//                 ),
//               );
//             },
//           );
//         }
//       },
//     );
//   }
// }

// Widget _buildDetail(String title, String content) {
//   return Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Text(
//         title,
//         style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//       ),
//       Text(content),
//     ],
//   );
// }
