import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

// NOTE: This package enables support for `sqflite` in a web environment
// - For Android/iOS emulators, this package is not needed!
// - For web emulators (Chrome, Edge, etc.), make sure the pre-requisite binaries
//   are set up before emulation. To do this, follow the instructions highlighted in the exercise
//   instructions or the official documentation: https://pub.dev/packages/sqflite_common_ffi_web#setup-binaries
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart'; // Enables support for `sqflite` via a web emulator

// This class will model the data for a Journal within our database
class Journal {
  int? id;
  String title;
  String content;

  Journal({this.id, required this.title, required this.content});

  // Converts a Journal into a map. The keys must correspond to the names of the
  // columns in our database
  Map<String, dynamic> toMap() {
    return {"id": id, "title": title, "content": content};
    // TODO 1: Return a map containing `id`, `title`, and `content` keys with their respective values
  }

  // A factory constructor which allows us to make a Journal directly from a map
  // See here for more details on factory constructors: https://dart.dev/language/constructors#factory-constructors
  factory Journal.fromMap(Map<String, dynamic> map) {
    return Journal(id: map["id"], title: map["title"], content: map["content"]);
    // TODO 2: Return a Journal object by mapping the provided map's keys to the Journal's properties
  }
}

Future<void> main() async {
  // The `sqflite` package doesn't support web development out of the box.
  // If the application is running on the web, we must use `databaseFactoryFfiWeb`
  // to enable database operations in a web environment
  if (kIsWeb) {
    databaseFactory = databaseFactoryFfiWeb;
  }

  // Ensure that the Flutter framework is fully initialized before running any other code
  WidgetsFlutterBinding.ensureInitialized();

  // NOTE: The location of the data stored by `sqflite` will depend on which device is used, the
  // location is also determined by the following standard plugin: https://pub.dev/packages/path_provider
  try {
    Directory dataDir = await getApplicationDocumentsDirectory();
    debugPrint('View databases under $dataDir');
  } on MissingPluginException {
    debugPrint(
        '`getApplicationDocumentsDirectory` is not supported on this platform');
    debugPrint(
        'For web environments: View databases under CTRL + SHIFT + I (Inspect) > Application > Storage > IndexedDB');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This is the root of our application
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Journal App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: JournalPage(),
    );
  }
}

class JournalPage extends StatefulWidget {
  const JournalPage({super.key});

  @override
  State<JournalPage> createState() => _JournalPageState();
}

class _JournalPageState extends State<JournalPage> {
  late Database _database;
  List<Journal> _journals = []; // The list of journals from our database
  Journal? _editingJournal; // The journal we're currently editing

  // Handle any required work for the initialization of our page/object.
  // NOTE: `initState` is only called once when the object is inserted into the tree,
  // see the official documentation for more details: https://api.flutter.dev/flutter/widgets/State/initState.html
  @override
  void initState() {
    super.initState();
    _initializeDatabase();
  }

  // Initializes our database
  Future<void> _initializeDatabase() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'journal_database.db'),
      onCreate: (db, version) {
        return db.execute(
          "CREATE TABLE journals(id INTEGER PRIMARY KEY, title TEXT, content TEXT)",
        );
      },
    );
    // TODO 3: Open a SQLite database and create a table `journals` with columns `id`, `title`, and `content`
    // if it does not exist. The database should be assigned to the variable `_database`

    // Reloads the journals by calling `setState`
    _loadJournals();
  }

  // Loads all journals from our database
  Future<void> _loadJournals() async {
    final db = await _database;
    final List<Map<String, dynamic>> journals = await db.query('journals');
    for (final journal in journals) {
      _journals.add(Journal(
          id: journal["id"],
          title: journal["title"],
          content: journal["content"]));
    }
    // TODO 4: Fetch ALL journal entries from the `journals` table in the database. The entries should be assigned
    // to the variable `_journals`. Don't forget to call `setState` to reload the journals
  }

  // Adds a new journal in our database
  Future<void> _addJournal(String title, String content) async {
    // TODO 5: Create a new Journal object with the given title and content, insert it into the `journals` table in the database.
    // Don't forget to set the generated ID to the new Journal object, or else you will run into a bug!

    // Reloads the journals and clears filled in fields by calling `setState`
    _loadJournals();
    _clearFields();
  }

  // Updates a pre-existing journal in our database
  Future<void> _updateJournal(String title, String content) async {
    // If we are updating a journal, the instance variable `_editingJournal` should not be `null`
    if (_editingJournal == null) return;

    _editingJournal!.title = title;
    _editingJournal!.content = content;

    // TODO 6: Update the `journals` table in the database with the current journal's data based on its ID

    // Reloads the journals and clears filled in fields by calling `setState`
    _loadJournals();
    _clearFields();
  }

  // Deletes a journal from our database
  Future<void> _deleteJournal(int id) async {
    // TODO 7: Delete a journal entry from the `journals` table in the database using the provided ID

    // Reloads the journals by calling `setState`
    _loadJournals();
  }

  // Set up the title and content for editing a journal
  void _startEditing(Journal journal) {
    setState(() {
      _editingJournal = journal;
      _titleController.text = journal.title;
      _textController.text = journal.content;
    });
  }

  // Clear the text fields and stop editing a journal
  void _clearFields() {
    setState(() {
      _titleController.clear();
      _textController.clear();
      _editingJournal = null;
    });
  }

  // Controllers for the text fields
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Journal App'),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              // Text field which stores the journal title via `_titleController`
              TextField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Journal Title'),
              ),
              SizedBox(height: 8),
              // Text field which stores the journal content via `_textController`
              TextField(
                controller: _textController,
                decoration: InputDecoration(labelText: 'Journal Content'),
                onSubmitted: (text) {
                  // TODO 8: Retrieve the title from the text controller and add a journal entry using the title and text
                },
              ),
              SizedBox(height: 16),
              // Button to add or update a journal depending on the value of `_editingJournal`
              ElevatedButton(
                onPressed: () {
                  String title = _titleController.text;
                  String content = _textController.text;
                  _editingJournal == null
                      ? _addJournal(title, content)
                      : _updateJournal(title, content);
                },
                child: Text(
                    _editingJournal == null ? 'Add Journal' : 'Update Journal'),
              ),
              // List of all journals
              Expanded(
                child: ListView.builder(
                  itemCount: _journals.length,
                  itemBuilder: (context, index) {
                    final journal = _journals[index];
                    return ListTile(
                      title: Text(journal.title),
                      subtitle: Text(journal.content),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Button to start editing a journal
                          IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () => _startEditing(journal),
                          ),
                          // Button to delete a journal
                          IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              // TODO 9: Delete a journal entry using the ID
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
