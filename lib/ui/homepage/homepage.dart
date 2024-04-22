import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/app_state.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/screens/widgets/cardPopularEvents.dart';
import 'package:flutterprojectfinal/ui/event_detail/event_details.dart';
import 'package:flutterprojectfinal/ui/event_details/event_details_page.dart';
import 'package:flutterprojectfinal/ui/homepage/category_widget.dart';
import 'package:flutterprojectfinal/ui/homepage/event_widget.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'category_widget.dart';
import 'event_widget.dart';
import 'package:flutterprojectfinal/app/configs/colors.dart';
import '../../styleguide.dart';
import '../../app/configs/colors.dart';
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
  @override
  void initState() {
    super.initState();
  }

  Future<List<Event>> _fetchPopularEvents() async {
    await Future.delayed(Duration(seconds: 2));
    return events;
  }

  void _onRefresh() async {
    await _fetchEvents("All");
    await _fetchPopularEvents();
    _refreshController.refreshCompleted();
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
      return Future.error('Location services are disabled.');
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

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    Position coordinates = await Geolocator.getCurrentPosition();
    List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude, coordinates.longitude);
    Placemark place = placemarks[0];

    return place;
  }

  // Future<List<EventModel>> _fetchEvents(String? categoryName) async {
  //   LocalEvents.clear();

  //   QuerySnapshot querySnapshot =
  //       await FirebaseFirestore.instance.collection('events').get();
  //   Placemark place = await _determinePosition();
  //   print("postion  $place.subAdministrativeArea");

  //   querySnapshot.docs.forEach((doc) {
  //     var eventData = EventModel.fromFirestore(doc);
  //     List<String> locations = eventData.location!.split(",");
  //     if (locations[3].trim() ==
  //         place.subAdministrativeArea.toString()) if (categoryName == "All") {
  //       LocalEvents.add(EventModel.fromFirestore(doc));
  //     } else if (eventData.category == categoryName) {
  //       LocalEvents.add(EventModel.fromFirestore(doc));
  //     }
  //   });

  //   return LocalEvents;
  // }

  Future<List<EventModel>> _fetchEvents(String? categoryName) async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();
    Placemark place = await _determinePosition();
    print("postion  $place.subAdministrativeArea");

    return querySnapshot.docs
        .where((doc) {
          var eventData = EventModel.fromFirestore(doc);
          List<String> locations = eventData.location!.split(",");
          return locations[3].trim() ==
                  place.subAdministrativeArea.toString() &&
              (categoryName == "All" || eventData.category == categoryName);
        })
        .map((doc) => EventModel.fromFirestore(doc))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppState>(
      create: (_) => AppState(),
      child: Stack(
        children: <Widget>[
          // HomePageBackground(
          //   screenHeight: MediaQuery.of(context).size.height,
          // ),
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
                          // Text(
                          //   "Welcome " +
                          //       (FirebaseAuth.instance.currentUser != null
                          //           ? FirebaseAuth
                          //                   .instance.currentUser!.displayName ??
                          //               "ANONYMOUS"
                          //           : "ANONYMOUS"),
                          //   style: TextStyle(
                          //     fontWeight: FontWeight.bold,
                          //     fontSize: 14,
                          //     color: Colors.black,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Text(
                        "What's Up",
                        style: blackHeadingTextStyle,
                      ),
                    ),
                    _buildSearch(), // Add the search widget here
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
                          Text(
                            "View All",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    FutureBuilder<List<Event>>(
                      future: _fetchPopularEvents(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(child: Text(snapshot.error.toString()));
                        } else if (snapshot.hasData) {
                          List<Event> events = snapshot.data as List<Event>;
                          return _listPopularEvent(events);
                        } else {
                          return const Center(child: Text("No events found."));
                        }
                      },
                    ),
                    const SizedBox(height: 16),
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
                          Text(
                            "View All",
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 12,
                              color: AppColors.greyTextColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // FutureBuilder for fetching events
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

                    // Other widgets
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _categoryWidget(BuildContext context, Category category) {
    final appState = Provider.of<AppState>(context);
    // print(
    //     "app state >>> ${appState.selectedCategoryId} category >>> ${category.categoryId}");
    final isSelected = appState.selectedCategoryId == category.categoryId;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          appState.updateCategoryId(category.categoryId);
          setState(() {
            selectedCategoryName = category.name;
            // _fetchEvents(category.name);
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
      child: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.grey),
          hintText: "Search event...",
          hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w400),
          border: InputBorder.none,
        ),
      ),
    );

Widget _listPopularEvent(List<Event> events) => Container(
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
              onTap: () => Navigator.pushNamed(
                context,
                '/signup', // Make sure this is the correct route
                arguments: events[index],
              ),
              child: CardPopularEvent(eventModel: events[index]),
            ),
          ),
        ),
      ),
    );
