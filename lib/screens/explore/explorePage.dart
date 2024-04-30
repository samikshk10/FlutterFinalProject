import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/category.dart';
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
  String _searchQuery = "";

  String _selectedCategoryName = "All";
  Future<int> countFavorites(String eventId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('favouriteEvents')
        .where("event", isEqualTo: eventId)
        .get();

    return snapshot.size;
  }

  Future<List<EventModel>> _fetchEvents(String? categoryName) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('events')
        .orderBy('createdAt',
            descending: true) // Order by createdAt in descending order
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .where((doc) =>
              (categoryName == "All" || doc['category'] == categoryName))
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } else {
      return Future.error("No events found.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchBar(
              onChanged: ((value) {
                if (value.isEmpty)
                  setState(() {
                    _searchQuery = "";
                    _fetchEvents(_selectedCategoryName);
                  });
              }),
              leading: Icon(Icons.search),
              hintText: 'Search for...',
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                for (final category in categories)
                  Padding(
                    padding: const EdgeInsets.only(left: 4.0, top: 12.0),
                    child: Container(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor:
                              _selectedCategoryName == category.name
                                  ? Colors.white
                                  : Colors.black,
                          backgroundColor:
                              _selectedCategoryName == category.name
                                  ? Colors.blue
                                  : Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Row(children: [
                          Icon(category.icon),
                          SizedBox(width: 4),
                          Text(category.name),
                        ]),
                        onPressed: () {
                          setState(() {
                            _selectedCategoryName = category.name;
                          });
                        },
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 2),
          FutureBuilder<List<EventModel>>(
            future: _fetchEvents(_selectedCategoryName),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasData) {
                List<EventModel> events = snapshot.data as List<EventModel>;
                if (events.length == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: Center(
                        child: _selectedCategoryName == "All"
                            ? Text("No events found")
                            : Text(
                                "No events found in $_selectedCategoryName category.")),
                  );
                }
                if (_searchQuery.isNotEmpty) {
                  events = events
                      .where((event) => event.title
                          .toLowerCase()
                          .contains(_searchQuery.toLowerCase()))
                      .toList();
                  if (events.length == 0) {
                    return Center(
                        child: Text("No events found for $_searchQuery"));
                  }
                }
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
                        favouriteCount: countFavorites(event.eventId),
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
