import 'grocery_item.dart';

class GroceryList {
  String title;
  List<GroceryItem> items;

  GroceryList({required this.title, required this.items});

  factory GroceryList.fromJson(Map<String, dynamic> json) {
    return GroceryList(
      title: json['title'],
      items: (json['items'] as List)
          .map((item) => GroceryItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}
