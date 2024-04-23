import 'package:flutter/material.dart';
import 'package:flutterprojectfinal/model/category.dart';

class FilterGroup extends StatefulWidget {
  final String title;
  final List<Category> filters;

  const FilterGroup({
    Key? key,
    required this.title,
    required this.filters,
  }) : super(key: key);

  @override
  State<FilterGroup> createState() => _FilterGroupState();
}

class _FilterGroupState extends State<FilterGroup> {
  late List<Category> visibleFilters;
  bool showAll = false;
  List<String> addedFilters = []; // Initialize here

  @override
  void initState() {
    super.initState();
    visibleFilters = widget.filters.sublist(0, 4);
  }

  void toggleFilters() {
    setState(() {
      showAll = !showAll;
      visibleFilters = showAll ? widget.filters : widget.filters.sublist(0, 4);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 4,
              mainAxisSpacing: 4,
              childAspectRatio: 3,
            ),
            itemCount: visibleFilters.length,
            itemBuilder: (context, index) {
              return FilterButton(
                filterName: visibleFilters[index],
                addedFilters: addedFilters, // Pass the list down
              );
            },
          ),
          TextButton(
            onPressed: toggleFilters,
            child: Text(showAll ? 'Show less' : 'Show all'),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatefulWidget {
  final Category filterName;
  final List<String> addedFilters; // Receive the list here
  const FilterButton({Key? key, required this.filterName, required this.addedFilters}) : super(key: key);

  @override
  State<FilterButton> createState() => _FilterButtonState();
}

class _FilterButtonState extends State<FilterButton> {
  bool _isClicked = false;

  void _toggleColor() {
    setState(() {
      _isClicked = !_isClicked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {
        _toggleColor();
        setState(() {
          widget.addedFilters.add(widget.filterName.name);
        });
        print(widget.addedFilters); // Print here
      },
      style: OutlinedButton.styleFrom(
          foregroundColor: _isClicked ? Colors.blue : Colors.grey),
      child: Text(widget.filterName.name),
    );
  }
}
