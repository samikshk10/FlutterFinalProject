import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/app_state.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/screens/widgets/cardPopularEvents.dart';
import 'package:flutterprojectfinal/services/provider/favouriteProvider.dart';
import 'package:flutterprojectfinal/ui/event_detail/event_details.dart';
import 'package:flutterprojectfinal/ui/event_details/event_details_page.dart';
import 'package:flutterprojectfinal/ui/homepage/category_widget.dart';
import 'package:flutterprojectfinal/ui/homepage/event_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_state.dart';
import 'category_widget.dart';
import 'event_widget.dart';
import 'package:flutterprojectfinal/app/configs/colors.dart';
import '../../styleguide.dart';
import '../../app/configs/colors.dart';
import 'package:flutterprojectfinal/screens/profile/favouritePage.dart';
import 'package:flutterprojectfinal/model/category.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String selectedCategoryName = "All";
  final TextEditingController _searchController = TextEditingController();
  bool isOrganizer = false;
  String _searchQuery = "";
  void checkOrganizer() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      isOrganizer = pref.getBool("isOrganizer") ?? false;
    });
  }

  @override
  void initState() {
    super.initState();
    checkOrganizer();
  }

  Future<List<EventModel>> _fetchPopularEvents() async {
    // Wait for Firestore to return the documents from the 'favouriteevents' collection
    QuerySnapshot favouriteSnapshot =
        await FirebaseFirestore.instance.collection('favouriteEvents').get();

    // Initialize a map to store event IDs and their corresponding like counts
    Map<String, int> eventLikes = {};

    // Iterate through the documents in the 'favouriteevents' collection
    favouriteSnapshot.docs.forEach((doc) {
      // Extract the event ID from each document
      String eventId = doc['event'];

      print("event>>> $eventId");
      // Increment the like count for the corresponding event ID
      eventLikes[eventId] = (eventLikes[eventId] ?? 0) + 1;
    });

    // Sort the event IDs based on their like counts in descending order
    List<String> sortedEventIds = eventLikes.keys.toList()
      ..sort((a, b) => eventLikes[b]!.compareTo(eventLikes[a]!));

    // Limit the result to the top 5 event IDs
    sortedEventIds = sortedEventIds.take(5).toList();

    if (sortedEventIds.isNotEmpty) {
      // Query the 'events' collection based on the top 5 event IDs
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('events')
          .where('eventId', whereIn: sortedEventIds)
          .get();

      // Map the query results to EventModel objects
      List<EventModel> popularEvents = querySnapshot.docs
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();

      return popularEvents;
    } else {
      // Handle case when no popular events are found
      return [];
    }
  }

  void _onRefresh() async {
    try {
      await _fetchEvents(selectedCategoryName);
      await _fetchPopularEvents();
      _refreshController.refreshCompleted();
    } catch (error) {
      // Handle any errors that occur during refresh
      print("Error during refresh: $error");
      _refreshController.refreshFailed();
    }
  }

  List<EventModel> LocalEvents = [];

  Future<Placemark> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error(
          'Location services are disabled. Please enable to view local events');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position coordinates = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude, coordinates.longitude);
    Placemark place = placemarks[0];

    return place;
  }

  Future<int> countFavorites(String eventId) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore
        .instance
        .collection('favouriteEvents')
        .where("event", isEqualTo: eventId)
        .get();

    return snapshot.size;
  }

  Future<List<EventModel>> _fetchEvents(String? categoryName) async {
    // Determine the updated position after turning on location services
    Placemark place = await _determinePosition();
    // Use the updated location to fetch events
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();
    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs
          .where((doc) =>
              doc['location'].toString().split(",")[3].trim() ==
                  place.subAdministrativeArea.toString() &&
              (categoryName == "All" || doc['category'] == categoryName))
          .map((doc) => EventModel.fromFirestore(doc))
          .toList();
    } else {
      return Future.error("No events found");
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: Stack(
        children: <Widget>[
          SmartRefresher(
            controller: _refreshController,
            onRefresh: _onRefresh,
            enablePullDown: true,
            child: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            "Local Events",
                            style: fadedTextStyle,
                          ),
                          Spacer(),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 32.0, vertical: 8.0),
                          child: isOrganizer
                              ? Text("Organizer", style: headingTextStyle)
                              : Text(
                                  "What's Up",
                                  style: blackHeadingTextStyle,
                                ),
                        ),
                      ],
                    ),
                    _buildSearch(),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Consumer<AppState>(
                        builder: (context, appState, _) =>
                            SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: <Widget>[
                              for (final category in categories)
                                _categoryWidget(context, category)
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Popular Event",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _popularEventsBuilder(),
                    const SizedBox(height: 10),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            "Local Events",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                        ],
                      ),
                    ),
                    FutureBuilder<List<EventModel>>(
                      future: _fetchEvents(selectedCategoryName),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (snapshot.hasData) {
                          List<EventModel> events =
                              snapshot.data as List<EventModel>;
                          if (events.length == 0) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: selectedCategoryName == "All"
                                      ? Text("No events found")
                                      : Text(
                                          "No events found in $selectedCategoryName category.")),
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
                                  child: Text(
                                      "No events found for $_searchQuery"));
                            }
                          }
                          return Column(
                            children: events.map((event) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        key:
                                            Key('event_details_${event.title}'),
                                        eventModel: event,
                                        provider:
                                            Provider.of<FavouriteProvider>(
                                                context),
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryWidget(BuildContext context, Category category) {
    final appState = Provider.of<AppState>(context);
    final isSelected = appState.selectedCategoryId == category.categoryId;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          appState.updateCategoryId(category.categoryId);
          setState(() {
            selectedCategoryName = category.name;
          });
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        width: 90,
        height: 90,
        decoration: BoxDecoration(
          border: Border.all(
              color: isSelected ? Colors.black : Colors.blue, width: 3),
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: isSelected ? Colors.blue : Colors.transparent,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              category.icon,
              color: isSelected ? Colors.white : Colors.black,
              size: 40,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              category.name,
              style: isSelected ? selectedCategoryTextStyle : categoryTextStyle,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSearch() => Container(
        height: 48,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 24),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(50)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: _searchController,
                onFieldSubmitted: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
                onChanged: ((value) {
                  if (value == "")
                    setState(() {
                      _searchQuery = "";
                      _fetchEvents(selectedCategoryName);
                    });
                }),
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  hintText: "Search local event...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w400,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      );

  Widget _popularEventsBuilder() {
    return FutureBuilder<List<EventModel>>(
      future: _fetchPopularEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text(snapshot.error.toString()));
        } else {
          List<EventModel> events = snapshot.data ?? [];
          if (events.isEmpty) {
            return Center(child: Text("No Popular events found"));
          } else {
            return _listPopularEvent(events);
          }
        }
      },
    );
  }

  Widget _listPopularEvent(List<EventModel> events) => Container(
        width: double.infinity, // or set a specific width
        height: 270,
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          physics: const BouncingScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: events.length,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 250,
              height: 270,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        key: Key('event_details_${events[index].title}'),
                        eventModel: events[index],
                        provider: Provider.of<FavouriteProvider>(context),
                      ),
                    ),
                  );
                },
                child: CardPopularEvent(
                  eventModel: events[index],
                ),
              ),
            ),
          ),
        ),
      );
}
