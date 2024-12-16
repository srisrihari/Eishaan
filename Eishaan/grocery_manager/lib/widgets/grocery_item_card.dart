import 'package:flutter/material.dart';
import '../models/grocery_item.dart';

class GroceryItemCard extends StatelessWidget {
  final GroceryItem item;

  GroceryItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item.name),
        subtitle: Text('Quantity: ${item.quantity}'),
        trailing: Icon(
          item.purchased ? Icons.check_circle : Icons.circle_outlined,
          color: item.purchased ? Colors.green : Colors.grey,
        ),
      ),
    );
  }
}
