import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageEventsTile extends StatefulWidget {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final Function onTap;
  final String eventId;
  final Function onDelete;
  final Function onDeleteConfirmed; // Add this line
  final String deleteDialogContent; // Add this line

  const ManageEventsTile(
      {required this.title,
      required this.date,
      required this.location,
      required this.imageUrl,
      required this.onTap,
      required this.eventId,
      required this.onDelete,
      required this.onDeleteConfirmed,
      required this.deleteDialogContent});

  @override
  State<ManageEventsTile> createState() => _ManageEventsTileState();
}

class _ManageEventsTileState extends State<ManageEventsTile> {
  int _favoriteCount = 0;

  Future<int> countFavorites(String eventId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('favouriteEvents')
        .where("event", isEqualTo: eventId)
        .get();

    return snapshot.size;
  }

  Future<void> _fetchFavoriteCount() async {
    int count = await countFavorites(widget.eventId);
    setState(() {
      _favoriteCount = count;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchFavoriteCount();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(widget.title), // Unique key for each tile
        background: Container(
          color: Colors.red,
          alignment: Alignment.centerRight,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
        direction: DismissDirection.endToStart,
        confirmDismiss: (_) => confirmDelete(context),
        onDismissed: (_) => widget.onDelete(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 7),
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Card(
            elevation: 5,
            child: ListTile(
              onTap: () => widget.onTap(),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(widget.imageUrl),
              ),
              title: Text(widget.title),
              subtitle: Text(
                  '${DateFormat("y/MM/dd").format(DateTime.parse(widget.date.toString()))}\n${widget.location.split(",")[1]},${widget.location.split(",")[3]}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.favorite,
                    color: Colors.red,
                  ),
                  SizedBox(width: 4),
                  Text(
                    _favoriteCount.toString(),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<bool> confirmDelete(BuildContext context) async {
    final result = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Remove'),
          content: Text(widget.deleteDialogContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                widget.onDeleteConfirmed(); // Call the callback function
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('No'),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }
}
