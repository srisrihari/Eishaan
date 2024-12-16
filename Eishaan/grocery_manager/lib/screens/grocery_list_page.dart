import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/grocery_list.dart';
import 'create_list_page.dart';


class GroceryListPage extends StatefulWidget {
  @override
  _GroceryListPageState createState() => _GroceryListPageState();
}

class _GroceryListPageState extends State<GroceryListPage> {
    final ApiService apiService = ApiService();
    late Future<List<GroceryList>> futureGroceryLists;

    @override
    void initState() {
    super.initState();
    futureGroceryLists = apiService.fetchGroceryLists();
    }

    @override
    Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Grocery Lists')),
        body: FutureBuilder<List<GroceryList>>(
        future: futureGroceryLists,
        builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator()); // Loading state
            } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Error state
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No grocery lists available. Add a new one!')); // Empty state
            } else {
            return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                final list = snapshot.data![index];
                return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ExpansionTile(
                    title: Text(list.title),
                    subtitle: Text('${list.items.length} items'),
                    children: list.items.map((item) {
                        return ListTile(
                        title: Text(item.name),
                        subtitle: Text('Quantity: ${item.quantity}'),
                        trailing: Icon(
                            item.purchased ? Icons.check_circle : Icons.circle_outlined,
                            color: item.purchased ? Colors.green : Colors.grey,
                        ),
                        );
                    }).toList(),
                    ),
                );
                },
            );
            }
        },
        ),
        floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateListPage()),
            ).then((_) {
            // Refresh data after returning from the create page
            setState(() {
                futureGroceryLists = apiService.fetchGroceryLists();
            });
            });
        },
        child: const Icon(Icons.add),
        ),
    );
    }

}
