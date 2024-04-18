import 'package:flutter/material.dart';

class FilterGroup extends StatefulWidget {
  final String title;
  final List<String> filters;

  const FilterGroup({
    super.key,
    required this.title,
    required this.filters,
  });

  @override
  State<FilterGroup> createState() => _FilterGroupState();
}

class _FilterGroupState extends State<FilterGroup> {
  late List<String> visibleFilters;
  bool showAll = false;

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
              return FilterButton(filterName: visibleFilters[index]);
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
  final String filterName;
  const FilterButton({Key? key, required this.filterName}) : super(key: key);

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
      onPressed: _toggleColor,
      style: OutlinedButton.styleFrom(
        foregroundColor: _isClicked ? Colors.blue : Colors.grey
      ),
      child: Text(widget.filterName),
    );
  }
}
