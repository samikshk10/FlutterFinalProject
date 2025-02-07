import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:provider/provider.dart';

import '../../model/event.dart';
import 'event_details_background.dart';
import 'event_details_content.dart';

class EventDetailsPage extends StatelessWidget {
  final EventModel event;

  const EventDetailsPage({required Key key, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Provider<EventModel>.value(
        value: event,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            EventDetailsBackground(),
            EventDetailsContent(),
          ],
        ),
      ),
    );
  }
}
