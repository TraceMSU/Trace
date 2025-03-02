import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter & Rails Template',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MainScreen(),
    );
  }
}

/// The MainScreen widget manages two pages and displays a bottom navigation bar.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Current index of the page. 0 = Search, 1 = Results.
  int _currentIndex = 0;

  // State for the search query and its results.
  String _searchQuery = '';
  List<String> _searchResults = [];

Future<void> _performSearch(String query) async {
  setState(() {
    _searchQuery = query;
  });

  if (query.isEmpty) {
    setState(() {
      _searchResults = [];
    });
    return;
  }

  // Append the search query as a query parameter named "q"
  final url = Uri.parse('http://localhost:3000/search?q=${Uri.encodeComponent(query)}');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = jsonDecode(response.body);
      setState(() {
        _searchResults = List<String>.from(
          data['results'].map((result) => result.toString())
        );
      });
    } else {
      setState(() {
        _searchResults = ['Error: Unable to fetch data'];
      });
    }
  } catch (e) {
    setState(() {
      _searchResults = ['Error: $e'];
    });
  }
}


  @override
  Widget build(BuildContext context) {
    // Build the two pages, passing necessary data and callbacks.
    final List<Widget> pages = [
      SearchPage(
        onSearch: _performSearch,
      ),
      ResultsPage(
        query: _searchQuery,
        results: _searchResults,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('TRACE template'),
      ),
      body: pages[_currentIndex],
      bottomNavigationBar: BottomAppBar(
        // A simple BottomAppBar with two IconButtons.
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Button for the Search page.
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: _currentIndex == 0 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              // Button for the Results page.
              IconButton(
                icon: Icon(
                  Icons.list,
                  color: _currentIndex == 1 ? Colors.blue : Colors.grey,
                ),
                onPressed: () {
                  setState(() {
                    _currentIndex = 1;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The SearchPage widget contains a text field and a button to perform a search.
class SearchPage extends StatelessWidget {
  final Function(String) onSearch;

  const SearchPage({super.key, required this.onSearch});

  @override
  Widget build(BuildContext context) {
    // Use a controller to get the text from the TextField.
    final TextEditingController controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Search',
              hintText: 'Enter search term',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (value) {
              onSearch(value);
            },
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              onSearch(controller.text);
            },
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }
}

/// The ResultsPage widget displays the search query and a list of results.
class ResultsPage extends StatelessWidget {
  final String query;
  final List<String> results;

  const ResultsPage({super.key, required this.query, required this.results});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: results.isEmpty
          ? Center(
              child: Text(
                query.isEmpty
                    ? 'No search performed yet.'
                    : 'No results found for "$query".',
                style: const TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              itemCount: results.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(results[index]),
                );
              },
            ),
    );
  }
}