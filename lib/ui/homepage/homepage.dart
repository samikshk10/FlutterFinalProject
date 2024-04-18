import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/app_state.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/model/eventModel.dart';
import 'package:flutterprojectfinal/screens/widgets/cardPopularEvents.dart';
import 'package:flutterprojectfinal/ui/event_details/event_details_page.dart';
import 'package:flutterprojectfinal/ui/homepage/category_widget.dart';
import 'package:flutterprojectfinal/ui/homepage/event_widget.dart';

import 'package:provider/provider.dart';

import '../../app_state.dart';
import 'category_widget.dart';
import 'event_widget.dart';
import 'package:flutterprojectfinal/app/configs/colors.dart';
import '../../model/category.dart';
import '../../styleguide.dart';
import '../../app/configs/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
  }

  Future<List<Event>> _fetchPopularEvents() async {
    await Future.delayed(Duration(seconds: 2));
    return events;
  }

  List<EventModel> eventAll = [];

  Future<List<EventModel>> _fetchEvents() async {
    // eventAll.clear();
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('events').get();
    querySnapshot.docs.forEach((doc) {
      eventAll.add(EventModel.fromFirestore(doc));
    });
    return eventAll;
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
          SafeArea(
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
                      builder: (context, appState, _) => SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: <Widget>[
                            for (final category in categories)
                              CategoryWidget(
                                  key: Key(category.categoryId.toString()),
                                  category: category)
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
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                  // FutureBuilder for fetching events
                  FutureBuilder<List<EventModel>>(
                    future: _fetchEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
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
                                    builder: (context) => EventDetailsPage(
                                      key: Key('event_details'),
                                      event: event,
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
        ],
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
