import 'package:flutter/material.dart';
import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

class LocationFind extends StatelessWidget {
  const LocationFind({Key? key}) : super(key: key);
  Map<String, double> PickLocation(PickedData pickedData) {
    return {
      'lat': pickedData.latLong.latitude,
      'long': pickedData.latLong.longitude
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick Location'),
      ),
      body: OpenStreetMapSearchAndPick(
        zoomInIcon: Icons.add,
        zoomOutIcon: Icons.remove,
        buttonColor: Colors.blue,
        buttonText: 'Pick Location',
        onPicked: (pickedData) {
          PickLocation(pickedData);
          Navigator.pop(context, PickLocation(pickedData));
        },
      ),
    );
  }
}
