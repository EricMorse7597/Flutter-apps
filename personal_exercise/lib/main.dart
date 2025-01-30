import 'package:flutter/material.dart';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

const String supabaseUrl = 'https://swizlgkcvtzprkuuhevy.supabase.co';
const String supabaseKey =
    'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InN3aXpsZ2tjdnR6cHJrdXVoZXZ5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3Mzc5MTU3MjAsImV4cCI6MjA1MzQ5MTcyMH0.2T9ZkQx2H8YxehnRkyLr_rBjX2EezdAhjXTvnDBJPhU';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  Supabase.initialize(url: supabaseUrl, anonKey: supabaseKey);
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

  String myText = 'Press Button';

  void _addItem() {
    final String newItem = _textController.text;
    if (newItem.isNotEmpty) {
      setState(() {
        _items.add(newItem);
        _textController.clear();
      });
    }
  }

  Future<void> fetchCourse() async {
    final response = await Supabase.instance.client
        .from('Couses')
        .select()
        .eq('Course Code', 'CIS*1300')
        .single();

    setState(() {
      myText = response['Course Name'];
    });
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
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: fetchCourse,
                  child: Text('Fetch'),
                ),
              ],
            ),
            SizedBox(height: 16), // Spacing between input and list
            Expanded(
              child: Text(myText),
            ),
          ],
        ),
      ),
    );
  }
}
