class GroceryItem {
  String name;
  int quantity;
  bool purchased;

  GroceryItem({
    required this.name,
    required this.quantity,
    this.purchased = false,
  });

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      name: json['name'],
      quantity: json['quantity'],
      purchased: json['purchased'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'quantity': quantity,
      'purchased': purchased,
    };
  }
}
