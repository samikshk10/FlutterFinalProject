import 'package:flutter/material.dart';
class Category extends StatelessWidget {
  final List<String> categories = [
    'Music',
    'Business',
    'Food & drink',
    'Community',
    'Arts',
    'Film & Media',
    'Health'
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index){
      return ListTile(title: Text(categories[index]),);
    });
  }
}
