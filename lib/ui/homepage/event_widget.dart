import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart';
import 'package:provider/provider.dart';
import '../../styleguide.dart';

class EventWidget extends StatefulWidget {
  final EventModel event;
  final Future<int> favouriteCount;

  const EventWidget(
      {required Key key, required this.event, required this.favouriteCount})
      : super(key: key);

  @override
  State<EventWidget> createState() => _EventWidgetState();
}

class _EventWidgetState extends State<EventWidget> {
  Future<int> countFavorites(String eventId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('favouriteEvents')
        .where("event", isEqualTo: eventId)
        .get();

    return snapshot.size;
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<FavouriteProvider>(context);
    final Event eventModel;
    List<String> locations = widget.event.location?.split(',') ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 20),
      elevation: 4,
      color: Colors.white,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(24))),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.all(
                Radius.circular(30),
              ),
              child: Image.network(
                widget.event.imageUrl,
                height: 150,
                fit: BoxFit.fitWidth,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.event.title,
                          style: eventTitleTextStyle,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        FittedBox(
                          child: Row(
                            children: <Widget>[
                              Icon(Icons.location_on),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                locations.length != 0
                                    ? "${locations[1]},${locations[3]}"
                                    : "not specified",
                                style: eventLocationTextStyle,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: FutureBuilder<int>(
                      future: countFavorites(widget.event.eventId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          // If still loading, return a placeholder or a loading indicator
                          return Transform.scale(
                              scale: 0.1, child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          // If an error occurred while fetching the count, display the error
                          return Text(
                            'Error: ${snapshot.error}',
                            style: TextStyle(color: Colors.red),
                          );
                        } else {
                          // If the data is available, display the count
                          return Padding(
                            padding: const EdgeInsets.only(left: 26),
                            child: Column(
                              children: [
                                Text(
                                  widget.event.duration ?? "",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                                SizedBox(height: 5),
                                Row(
                                  children: [
                                    Icon(Icons.favorite, color: Colors.red),
                                    Text(snapshot.data.toString(),
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }
                      },
                    ),
                  )

                  /*IconButton(
                    onPressed: () {
                      provider.toggleFavourite(widget.eventModel);
                      provider.addFavourite(widget.eventModel);
                    },
                    icon: Icon(
                      provider.isExist(widget.eventModel)
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: provider.isExist(widget.eventModel)
                          ? Colors.red
                          : null,
                    ),
                  ),*/
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
