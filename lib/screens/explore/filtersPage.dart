import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/category.dart';
import 'package:flutterprojectfinal/screens/customWidgets/customButton.dart';
import 'package:flutterprojectfinal/screens/customWidgets/filterGroupContainer.dart';
import 'package:flutterprojectfinal/app/configs/categories.dart';

class FiltersPage extends StatefulWidget {
  const FiltersPage({super.key});

  @override
  State<FiltersPage> createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  final List<String> _categories = [
    'Music',
    'Business',
    'Food & drink',
    'Community',
    'Arts',
    'Film & Media',
    'Health'
  ];
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
                FilterGroup(title: 'Event type', filters: _categories),
                ListTile(
                  leading: Text('Only free events'),
                  trailing: Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = !isSwitched;
                        });
                      }),
                )
              ],
            )),
            Expanded(child: SizedBox()),
            CustomButton(label: 'Apply Filters', press: (){
              Navigator.pop(context);
            })
          ],
        ),
      ),
    );
  }
}
