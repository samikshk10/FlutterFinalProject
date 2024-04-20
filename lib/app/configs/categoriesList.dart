class CategoryList {
  static final CategoryList _instance = CategoryList._internal();

  factory CategoryList() {
    return _instance;
  }

  CategoryList._internal();

  List<String> categories = [
    'Music',
    'Sports',
    'Food',
    'Travel',
    'Fashion',
    'Technology',
    'Education',
    'Health',
    'Business',
    'Art',
    'Others'
  ];
}
