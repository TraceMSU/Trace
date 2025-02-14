import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// The main application widget.
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Current index of the page. 0 = Search, 1 = Results.
  int _currentIndex = 0;

  // State for the search query and its results.
  String _searchQuery = '';
  List<String> _searchResults = [];

  /// Simulates a search operation. Later, replace with Rails call
  void _performSearch(String query) {
    setState(() {
      _searchQuery = query;
      // Simulate search results by generating a few dummy entries.
      _searchResults = List.generate(
          5, (index) => "Result ${index + 1} for '$query'");
    });
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

  const SearchPage({Key? key, required this.onSearch}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use a controller to get the text from the TextField.
    final TextEditingController _controller = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _controller,
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
              onSearch(_controller.text);
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

  const ResultsPage({Key? key, required this.query, required this.results})
      : super(key: key);

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
