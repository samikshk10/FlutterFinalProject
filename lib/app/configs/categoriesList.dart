class CategoryList {
  static final CategoryList _instance = CategoryList._internal();

  factory CategoryList() {
    return _instance;
  }

  CategoryList._internal();

  List<String> categories = [
    'Category 1',
    'Category 2',
    'Category 3',
  ];
}
