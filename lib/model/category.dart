import 'package:flutter/material.dart';

class Category {
  final int categoryId;
  final String name;
  final IconData icon;

  Category({required this.categoryId, required this.name, required this.icon});
}

List<Category> categories = [
  Category(categoryId: 0, name: "All", icon: Icons.search),
  Category(categoryId: 1, name: "Music", icon: Icons.music_note),
  Category(categoryId: 2, name: "Sports", icon: Icons.sports),
  Category(categoryId: 3, name: "Food", icon: Icons.restaurant),
  Category(categoryId: 4, name: "Travel", icon: Icons.airplanemode_active),
  Category(categoryId: 5, name: "Fashion", icon: Icons.shopping_bag),
  Category(categoryId: 6, name: "Technology", icon: Icons.computer),
  Category(categoryId: 7, name: "Education", icon: Icons.school),
  Category(categoryId: 8, name: "Health", icon: Icons.favorite),
  Category(categoryId: 9, name: "Business", icon: Icons.business),
  Category(categoryId: 10, name: "Art", icon: Icons.palette),
  Category(categoryId: 11, name: "Others", icon: Icons.category),
];
