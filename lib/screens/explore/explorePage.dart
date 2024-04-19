import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/event.dart';
import 'package:flutterprojectfinal/screens/explore/filtersPage.dart';
import 'package:flutterprojectfinal/ui/event_details/event_details_page.dart';
import 'package:flutterprojectfinal/ui/homepage/event_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutterprojectfinal/app_state.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  String _status = 'Online';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
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
                    label: Text('Food & Dirnks')),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Consumer<AppState>(
              builder: (context, appState, _) => Column(
                children: <Widget>[
                  for (final event in events.where((e) =>
                      e.categoryIds.contains(appState.selectedCategoryId)))
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => EventDetailsPage(
                                key: Key('event_details'), event: event),
                          ),
                        );
                      },
                      child: EventWidget(
                        key: Key('event_widget'),
                        event: event,
                      ),
                    )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
