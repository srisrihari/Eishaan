import 'package:flutter/material.dart';
import 'screens/grocery_list_page.dart';

void main() {
  runApp(GroceryApp());
}

class GroceryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Grocery Manager',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: GroceryListPage(),
    );
  }
}
