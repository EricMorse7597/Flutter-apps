import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ItemListScreen(),
    );
  }
}

/// Custom StatelessWidget to display a title and subtitle
class TitleSubtitle extends StatelessWidget {
  final String title;
  final String subtitle;

  const TitleSubtitle({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

/// StatefulWidget to manage a list of items
class ItemListScreen extends StatefulWidget {
  const ItemListScreen({super.key});

  @override
  State<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends State<ItemListScreen> {
  final TextEditingController _textController = TextEditingController();
  final List<String> _items = [];

  void _addItem() {
    final String newItem = _textController.text;
    if (newItem.isNotEmpty) {
      setState(() {
        _items.add(newItem);
        _textController.clear();
      });
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TitleSubtitle(
              title: 'My Items',
              subtitle: 'Add or remove items from the list',
            ),
            SizedBox(height: 16), // Spacing between title and input
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      labelText: 'Enter item',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addItem,
                  child: Text('Add'),
                ),
              ],
            ),
            SizedBox(height: 16), // Spacing between input and list
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_items[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      onPressed: () => _deleteItem(index),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
