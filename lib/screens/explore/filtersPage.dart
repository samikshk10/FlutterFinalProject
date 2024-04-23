import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/category.dart' as MyCategory;
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/filterGroupContainer.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({Key? key}) : super(key: key);

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  List<MyCategory.Category> _categories =
      MyCategory.categories; // Accessing categories list

  bool isSwitched = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
        actions: <Widget>[
          TextButton(
            onPressed: () {},
            child: Text('Clear all', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  FilterGroup(title: 'Categories', filters: _categories),
                  // FilterGroup(title: 'Event type', filters: _categories),
                ],
              ),
            ),
            Expanded(child: SizedBox()),
            CustomButton(
              label: 'Apply Filters',
              press: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
