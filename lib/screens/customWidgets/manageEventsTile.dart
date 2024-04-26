import 'package:flutter/material.dart';

class ManageEventsTile extends StatelessWidget {
  final String title;
  final String date;
  final String location;
  final String imageUrl;
  final Function onTap;
  final Function onDelete;

  const ManageEventsTile({
    required this.title,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(title),
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
    );
  }

  Future<bool> confirmDelete(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Event'),
          content: Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text('CANCEL'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: Text('DELETE'),
            ),
          ],
        );
      },
    );
  }
}
