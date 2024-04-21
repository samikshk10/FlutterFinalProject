import 'package:flutter/material.dart';

class FavouriteTile extends StatefulWidget {
  @override
  State<FavouriteTile> createState() => _FavouriteTileState();
}

class _FavouriteTileState extends State<FavouriteTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListTile(
        leading: Image(image: AssetImage("")),
      ),
    );
  }
}
