import 'package:flutter/material.dart';

class ManageEventsTile extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final Function onTap;
  final Function onDelete;
  final Function onDeleteConfirmed; // Add this line
  final String deleteDialogContent; // Add this line

  const ManageEventsTile(
      {required this.title,
      required this.date,
      required this.location,
      required this.imageUrl,
      required this.onTap,
      required this.onDelete,
      required this.onDeleteConfirmed,
      required this.deleteDialogContent});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(title), // Unique key for each tile
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
        onDismissed: (_) => onDelete(),
        child: Container(
          margin: EdgeInsets.symmetric(vertical: 5),
          child: Card(
            elevation: 5,
            child: ListTile(
              onTap: () => onTap(),
              leading: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
              title: Text(title),
              subtitle: Text('$date\n$location'),
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
          content: Text(deleteDialogContent),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
                onDeleteConfirmed(); // Call the callback function
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
