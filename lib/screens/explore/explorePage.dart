import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/screens/explore/filtersPage.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart';
import 'package:flutterprojectfinal/ui/event_detail/event_details.dart';
import 'package:flutterprojectfinal/ui/event_details/event_details_page.dart';
import 'package:flutterprojectfinal/ui/homepage/event_widget.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:flutterprojectfinal/app_state.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  List<EventModel> LocalEvents = [];

  Future<List<EventModel>> _fetchEvents() async {
    LocalEvents.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();

    querySnapshot.docs.forEach((doc) {
      LocalEvents.add(EventModel.fromFirestore(doc));
    });

    return LocalEvents;
  }

  String _status = 'Online';
  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          SearchBar(
            leading: Icon(Icons.search),
            hintText: 'Search for...',
          ),
          RadioListTile(
              title: Text('Offline'),
              value: 'Offline',
              groupValue: _status,
              onChanged: (value) {
                setState(() {
                  _status = value.toString();
                });
              }),
          RadioListTile(
              title: Text('Online'),
              value: 'Online',
              groupValue: _status,
              onChanged: (value) {
                setState(() {
                  _status = value.toString();
                });
              }),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FiltersPage()));
                    },
                    icon: Icon(Icons.tune_sharp),
                    label: Text('Filters')),
                SizedBox(
                  width: 3,
                ),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.calendar_today),
                    label: Text('Anytime')),
                SizedBox(
                  width: 3,
                ),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.music_note),
                    label: Text('Music')),
                SizedBox(
                  width: 3,
                ),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.business_center),
                    label: Text('Business')),
                SizedBox(
                  width: 3,
                ),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.fastfood_rounded),
                    label: Text('Food & Drinks')),
                SizedBox(
                  width: 3,
                ),
                ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.format_paint),
                    label: Text('Arts')),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FutureBuilder<List<EventModel>>(
            future: _fetchEvents(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                List<EventModel> events = snapshot.data as List<EventModel>;
                return Column(
                  children: events.map((event) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DetailPage(
                              key: Key('event_details_${event.title}'),
                              eventModel: event,
                              provider: Provider.of<FavouriteProvider>(context),
                            ),
                          ),
                        );
                      },
                      child: EventWidget(
                        key: Key('event_widget_${event.title}'),
                        event: event,
                      ),
                    );
                  }).toList(),
                );
              } else {
                return const Center(child: Text("No events found."));
              }
            },
          ),
        ],
      ),
    );
  }
}
