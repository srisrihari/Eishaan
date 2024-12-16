import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/grocery_list.dart';
import '../models/grocery_item.dart';

class CreateListPage extends StatefulWidget {
  @override
  _CreateListPageState createState() => _CreateListPageState();
}

class _CreateListPageState extends State<CreateListPage> {
  final _formKey = GlobalKey<FormState>();
  final ApiService apiService = ApiService();
  String title = '';
  List<GroceryItem> items = [];
  String itemName = '';
  int itemQuantity = 1;
  bool itemPurchased = false;

  void addItem() {
    if (itemName.isNotEmpty && itemQuantity > 0) {
      setState(() {
        items.add(GroceryItem(
          name: itemName,
          quantity: itemQuantity,
          purchased: itemPurchased,
        ));
        itemName = '';
        itemQuantity = 1;
        itemPurchased = false;
      });
    }
  }

  void saveList() async {
    if (_formKey.currentState!.validate() && items.isNotEmpty) {
      final newList = GroceryList(title: title, items: items);
      await apiService.createGroceryList(newList);
      Navigator.pop(context); // Return to the previous screen
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please add at least one item to the list')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Grocery List')),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Input for List Title
                TextFormField(
                  decoration: InputDecoration(labelText: 'List Title'),
                  onChanged: (value) {
                    title = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Input for Item Name
                TextFormField(
                  decoration: InputDecoration(labelText: 'Item Name'),
                  onChanged: (value) {
                    itemName = value;
                  },
                ),
                const SizedBox(height: 10),

                // Input for Item Quantity
                TextFormField(
                  decoration: InputDecoration(labelText: 'Quantity'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    itemQuantity = int.tryParse(value) ?? 1;
                  },
                ),
                const SizedBox(height: 10),

                // Checkbox for Purchased Status
                Row(
                  children: [
                    Checkbox(
                      value: itemPurchased,
                      onChanged: (value) {
                        setState(() {
                          itemPurchased = value ?? false;
                        });
                      },
                    ),
                    const Text('Purchased'),
                  ],
                ),
                const SizedBox(height: 10),

                // Button to Add Item
                ElevatedButton(
                  onPressed: addItem,
                  child: const Text('Add Item'),
                ),
                const SizedBox(height: 20),

                // Display Added Items
                if (items.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Items:',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      ...items.map((item) {
                        return ListTile(
                          title: Text(item.name),
                          subtitle: Text('Quantity: ${item.quantity}'),
                          trailing: Icon(
                            item.purchased ? Icons.check_circle : Icons.circle_outlined,
                            color: item.purchased ? Colors.green : Colors.grey,
                          ),
                        );
                      }).toList(),
                    ],
                  ),

                const SizedBox(height: 20),

                // Button to Save List
                ElevatedButton(
                  onPressed: saveList,
                  child: const Text('Save Grocery List'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
