import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/grocery_list.dart';

class ApiService {
  final String baseUrl = "http://localhost:8000"; // Update with backend URL

  Future<List<GroceryList>> fetchGroceryLists() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/grocery-lists/'));
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => GroceryList.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load grocery lists');
      }
    } catch (e) {
      print('Error fetching lists: $e');
      throw e;
    }
  }


  Future<void> createGroceryList(GroceryList list) async {
    final response = await http.post(
      Uri.parse('$baseUrl/grocery-lists/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(list.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to create grocery list');
    }
  }
}
